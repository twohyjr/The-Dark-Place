using namespace metal;
#include <metal_stdlib>

struct VertexIn{
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float3 normal [[ attribute(2) ]];
    float2 textureCoordinate [[ attribute(3) ]];
};

struct ModelConstants{
    float4x4 modelMatrix;
    float3x3 normalMatrix;
};

struct Fog {
    float gradient;
    float density;
};

struct SceneConstants {
    float3 skyColor;
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
    float3 eyePosition;
    float4x4 inverseViewMatrix;
    Fog fog;
};

struct Material {
    float shininess;
    float3 ambient; //Ka
    float3 diffuse; //Kd
    float3 specular; //Ks
    bool isLit;
    float4 color;
    bool useTexture;
};

struct LightData {
    float brightness;
    float3 position;
    float3 color;
    float3 attenuation;
    float ambientIntensity;
    float diffuseIntensity;
    float specularIntensity;
};

struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
    float3 surfaceNormal;
    float3 toCameraVector;
    float2 textureCoordinate;
    float3 worldPosition;
    float3 eyePosition;
    float3 skyColor;
    float visibility;
};

struct RiggedVertex {
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float3 normal [[ attribute(2) ]];
    int3 jointIDs [[ attribute(3) ]];
    float3 weights [[ attribute(4) ]];
    float2 textureCoordinate [[ attribute(5) ]];
};



//Lighting Declarations
float3 specular(float3 normal, float3 toCameraVector, float3 toLightVector, float3 lightColor, float lightBrightness, float materialShininess, float3 materialSpecular);
float3 diffuse(float3 normal, float3 toLightVector, float3 materialDiffuse, float lightBrightness, float3 lightColor);
float3 ambient(float3 lightColor, float3 materialAmbient, float lightBrightness);
float4 phongShade(LightData lightData, Material material, float3 worldPosition, float3 normal, float3 toCameraVector);
float4 attenuate(float4 currentColor, float3 attenuation, float3 lightPosition, float3 worldPosition);

//------- VERTEX SHADERS ------------
vertex RasterizerData basic_vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                                          constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                          constant ModelConstants &modelConstants [[ buffer(2) ]]){
    RasterizerData rd;
    
    //Vertex Position Descriptors
    float4x4 transformationMatrix = modelConstants.modelMatrix;
    float4 worldPosition = transformationMatrix * float4(vertexIn.position, 1.0);
    rd.position = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * worldPosition;
    rd.worldPosition = worldPosition.xyz;
    rd.surfaceNormal = (transformationMatrix * float4(vertexIn.normal, 0.0)).xyz;
    rd.toCameraVector = (sceneConstants.inverseViewMatrix * float4(0.0,0.0,0.0,1.0)).xyz - worldPosition.xyz;
    
    //Coloring
    rd.color = vertexIn.color;
    rd.textureCoordinate = vertexIn.textureCoordinate;
    rd.skyColor = sceneConstants.skyColor;
    
    Fog fog = sceneConstants.fog;
    float viewDistance = length(rd.position);
    float visibility = exp(-pow((viewDistance * fog.density), fog.gradient));
    rd.visibility = clamp(visibility, 0.0, 1.0);
    
    return rd;
}

vertex RasterizerData rigged_vertex_shader(const RiggedVertex vertexIn [[ stage_in ]],
                                           constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                           constant ModelConstants &modelConstants [[ buffer(2) ]],
                                           constant float4x4 *jointTransforms [[ buffer(3) ]]){
    RasterizerData rd;
    
    
//    vec4 totalLocalPos = vec4(0.0);
//    vec4 totalNormal = vec4(0.0);
//
//    for(int i=0;i<MAX_WEIGHTS;i++){
//        mat4 jointTransform = jointTransforms[in_jointIndices[i]];
//        vec4 posePosition = jointTransform * vec4(in_position, 1.0);
//        totalLocalPos += posePosition * in_weights[i];
//
//        vec4 worldNormal = jointTransform * vec4(in_normal, 0.0);
//        totalNormal += worldNormal * in_weights[i];
//    }
//
//    gl_Position = projectionViewMatrix * totalLocalPos;
//    pass_normal = totalNormal.xyz;
//    pass_textureCoords = in_textureCoords;
//    
    
    
    
    
    float4 totalLocalPos = float4(0.0);
    float4 totalNormal = float4(0.0);
    
    for(int i = 0; i < 3; i++){
        float4x4 jointTransform = jointTransforms[vertexIn.jointIDs[i]];
        float4 posePosition = jointTransform * float4(vertexIn.position, 1.0);
        totalLocalPos += posePosition * vertexIn.weights[i];
        
        float4 worldNormal = jointTransform * float4(vertexIn.normal, 0.0);
        totalNormal += worldNormal * vertexIn.weights[i];
    }
    
    
    
    //Vertex Position Descriptors
    float4x4 transformationMatrix = modelConstants.modelMatrix;
    float4 worldPosition = transformationMatrix * totalLocalPos;
    rd.position = sceneConstants.projectionMatrix * sceneConstants.viewMatrix  * worldPosition;
    rd.worldPosition = worldPosition.xyz;
    rd.surfaceNormal = (transformationMatrix * float4(vertexIn.normal, 0.0)).xyz;
    rd.toCameraVector = (sceneConstants.inverseViewMatrix * float4(0.0,0.0,0.0,1.0)).xyz - worldPosition.xyz;
    
    //Coloring
    rd.color = vertexIn.color;
    rd.textureCoordinate = vertexIn.textureCoordinate;
    rd.skyColor = sceneConstants.skyColor;
    
    Fog fog = sceneConstants.fog;
    float viewDistance = length(rd.position);
    float visibility = exp(-pow((viewDistance * fog.density), fog.gradient));
    rd.visibility = clamp(visibility, 0.0, 1.0);
    
    return rd;
}

//------- FRAGMENT SHADERS ------------
fragment half4 basic_fragment_shader(const RasterizerData rd [[ stage_in ]],
                                     constant Material &material [[ buffer(1) ]],
                                     constant LightData *lightDatas [[ buffer(2) ]],
                                     constant int &lightCount [[ buffer(3) ]]){
    float4 color = material.color;
    
    if(material.isLit){
        float3 totalAmbient = float3(0);
        float3 totalDiffuse = float3(0);
        float3 totalSpecular = float3(0);
        
        for(int i = 0; i < lightCount; i++){
            LightData lightData = lightDatas[i];
            
            float3 toLightVector = lightData.position - rd.worldPosition;
            float3 toCameraVector = rd.toCameraVector;
            float3 unitLightVector = normalize(toLightVector);
            float3 unitCameraVector = normalize(toCameraVector);
            float distance = length(toLightVector);
            float  attFactor = lightData.attenuation.x + (lightData.attenuation.y * distance) + (lightData.attenuation.z * distance * distance);
            float3 unitNormal = normalize(rd.surfaceNormal);
            float3 lightDirection = -unitLightVector;
            
            //Ambient
            float3 ambientness = material.ambient * lightData.ambientIntensity;
            totalAmbient += (ambientness * lightData.color * lightData.brightness) / attFactor;
            
            //Diffuse
            float3 diffuseness = material.diffuse * lightData.diffuseIntensity;
            float nDot1 = dot(unitNormal, unitLightVector);
            float diffuseBrightness = max(nDot1, 0.0);
            totalDiffuse += (diffuseBrightness * diffuseness * lightData.color * lightData.brightness) / attFactor;
            
            //Specualr
            float3 specularness = material.specular * lightData.specularIntensity;
            float3 reflectedLightDirection = reflect(lightDirection, unitNormal);
            float specularFactor = max(saturate(dot(reflectedLightDirection, unitCameraVector)), 0.1);
            float dampedFactor = pow(specularFactor, material.shininess);
            totalSpecular += (dampedFactor * specularness * lightData.color * lightData.brightness) / attFactor;
        }
        
        totalDiffuse = max(totalDiffuse, 0.2);
        
        color *= (float4(totalAmbient, 1.0) + float4(totalDiffuse, 1.0) + float4(totalSpecular, 1.0));
    }
    
    color = mix(float4(rd.skyColor, 1), color, rd.visibility);
    
    return half4(color.r, color.g, color.b, 1);
}

fragment half4 rigged_fragment_shader(const RasterizerData rd [[ stage_in ]],
                                        texture2d<float> texture [[ texture(0) ]],
                                        sampler sampler2d [[ sampler(0) ]],
                                        constant Material &material [[ buffer(1) ]],
                                        constant LightData *lightDatas [[ buffer(2) ]],
                                        constant int &lightCount [[ buffer(3) ]]){
    float4 color;
    if(material.useTexture){
        color = texture.sample(sampler2d, rd.textureCoordinate);
//        color = float4(color.b, color.g, color.r, color.a);
    }else {
        color = material.isLit ? material.color : rd.color;
    }
    
    if(material.isLit){
        float3 totalAmbient = float3(0);
        float3 totalDiffuse = float3(0);
        float3 totalSpecular = float3(0);
        
        for(int i = 0; i < lightCount; i++){
            LightData lightData = lightDatas[i];
            
            float3 toLightVector = lightData.position - rd.worldPosition;
            float3 toCameraVector = rd.toCameraVector;
            float3 unitLightVector = normalize(toLightVector);
            float3 unitCameraVector = normalize(toCameraVector);
            float distance = length(toLightVector);
            float  attFactor = lightData.attenuation.x + (lightData.attenuation.y * distance) + (lightData.attenuation.z * distance * distance);
            float3 unitNormal = normalize(rd.surfaceNormal);
            float3 lightDirection = -unitLightVector;
            
            //Ambient
            float3 ambientness = material.ambient * lightData.ambientIntensity;
            totalAmbient += (ambientness * lightData.color * lightData.brightness) / attFactor;
            
            //Diffuse
            float3 diffuseness = material.diffuse * lightData.diffuseIntensity;
            float nDot1 = dot(unitNormal, unitLightVector);
            float diffuseBrightness = max(nDot1, 0.0);
            totalDiffuse += (diffuseBrightness * diffuseness * lightData.color * lightData.brightness) / attFactor;
            
            //Specualr
            float3 specularness = material.specular * lightData.specularIntensity;
            float3 reflectedLightDirection = reflect(lightDirection, unitNormal);
            float specularFactor = max(saturate(dot(reflectedLightDirection, unitCameraVector)), 0.1);
            float dampedFactor = pow(specularFactor, material.shininess);
            totalSpecular += (dampedFactor * specularness * lightData.color * lightData.brightness) / attFactor;
        }
        
        totalDiffuse = max(totalDiffuse, 0.2);
        
        color *= (float4(totalAmbient, 1.0) + float4(totalDiffuse, 1.0) + float4(totalSpecular, 1.0));
    }
    
    color = mix(float4(rd.skyColor, 1), color, rd.visibility);
    
    return half4(color.r, color.g, color.b, 1);
}

fragment half4 village_terrain_fragment_shader(const RasterizerData rd [[ stage_in ]],
                                               texture2d<float> texture [[ texture(0) ]],
                                               sampler sampler2d [[ sampler(0) ]],
                                               constant Material &material [[ buffer(1) ]],
                                               constant LightData *lightDatas [[ buffer(2) ]],
                                               constant int &lightCount [[ buffer(3) ]]){
    float4 color = texture.sample(sampler2d, rd.textureCoordinate);
    color = float4(color.b, color.g, color.r, color.a);

    if(material.isLit){
        float3 totalAmbient = float3(0);
        float3 totalDiffuse = float3(0);
        float3 totalSpecular = float3(0);
        
        for(int i = 0; i < lightCount; i++){
            LightData lightData = lightDatas[i];
            
            float3 toLightVector = lightData.position - rd.worldPosition;
            float3 toCameraVector = rd.toCameraVector;
            float3 unitLightVector = normalize(toLightVector);
            float3 unitCameraVector = normalize(toCameraVector);
            float distance = length(toLightVector);
            float  attFactor = lightData.attenuation.x + (lightData.attenuation.y * distance) + (lightData.attenuation.z * distance * distance);
            float3 unitNormal = normalize(rd.surfaceNormal);
            float3 lightDirection = -unitLightVector;
            
            //Ambient
            float3 ambientness = material.ambient * lightData.ambientIntensity;
            totalAmbient += (ambientness * lightData.color * lightData.brightness) / attFactor;
            
            //Diffuse
            float3 diffuseness = material.diffuse * lightData.diffuseIntensity;
            float nDot1 = dot(unitNormal, unitLightVector);
            float diffuseBrightness = max(nDot1, 0.0);
            totalDiffuse += (diffuseBrightness * diffuseness * lightData.color * lightData.brightness) / attFactor;
            
            //Specualr
            float3 specularness = material.specular * lightData.specularIntensity;
            float3 reflectedLightDirection = reflect(lightDirection, unitNormal);
            float specularFactor = max(saturate(dot(reflectedLightDirection, unitCameraVector)), 0.1);
            float dampedFactor = pow(specularFactor, material.shininess);
            totalSpecular += (dampedFactor * specularness * lightData.color * lightData.brightness) / attFactor;
        }
        
        totalDiffuse = max(totalDiffuse, 0.2);
        
        color *= (float4(totalAmbient, 1.0) + float4(totalDiffuse, 1.0) + float4(totalSpecular, 1.0));
    }
    
    color = mix(float4(rd.skyColor, 1), color, rd.visibility);
    
    return half4(color.r, color.g, color.b, 1);
}
