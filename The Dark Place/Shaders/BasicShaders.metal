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
    float2 textureCoordinate [[ attribute(3) ]];
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

//------- FRAGMENT SHADERS ------------
fragment half4 basic_fragment_shader(const RasterizerData rd [[ stage_in ]],
                                     constant Material &material [[ buffer(1) ]],
                                     constant LightData *lightDatas [[ buffer(2) ]],
                                     constant int &lightCount [[ buffer(3) ]]){
    float4 color = material.color;
    
    if(material.isLit){
        float3 totalAmbient = float3(0);
        
        for(int i = 0; i < lightCount; i++){
            LightData lightData = lightDatas[i];
            float3 toLightVector = lightData.position - rd.worldPosition;
            float distance = length(toLightVector);
            float  attFactor = lightData.attenuation.x + (lightData.attenuation.y * distance) + (lightData.attenuation.z * distance * distance);
            
            totalAmbient += (material.ambient * lightData.ambientIntensity * lightData.color) / attFactor;
        }
        
        color *= (float4(totalAmbient, 1.0));
    }

    
    
//    float3 unitNormal = normalize(rd.surfaceNormal);
//
//
//    float3 totalDiffuse = float3(0.0);
//    float3 totalSpecular = float3(0.0);
//    for(int i = 0; i < lightCount; i++){
//        LightData lightData = lightDatas[i];
//
//        float3 unitNormal = normalize(rd.surfaceNormal);
//        float3 toLightVector = lightData.position - rd.worldPosition;
//        float3 toCameraVector = rd.toCameraVector;
//        float3 unitLightVector = normalize(toLightVector);
//        float3 unitCameraVector = normalize(toCameraVector);
//        float distance = length(toLightVector);
//
//
//
//
//        float  attFactor = lightData.attenuation.x + (lightData.attenuation.y * distance) + (lightData.attenuation.z * distance * distance);
//
//
//
//        float nDot1 = dot(unitNormal, unitLightVector);
//        float brightness = max(nDot1, 0.0);
//        float3 lightDirection = -unitLightVector;
//        float3 reflectedLightDirection = reflect(lightDirection, unitNormal);
//
//        float specularFactor = max(saturate(dot(reflectedLightDirection, unitCameraVector)), 0.1);
//        float dampedFactor = pow(specularFactor, material.shininess);
//
//        totalDiffuse += (brightness * material.diffuse * lightData.color) / attFactor;
//        totalSpecular += (dampedFactor * material.specular * lightData.color) / attFactor;
//
//    }
//
//    totalDiffuse = max(totalDiffuse, 0.2);
//
//    color = (float4(totalDiffuse, 1.0) + float4(totalSpecular, 1.0));
    
    
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
    }else {
        color = material.isLit ? material.color : rd.color;
    }
    float4 totalColor = float4(0);
    
    for(int i = 0; i < lightCount; i++){
        LightData lightData = lightDatas[i];
        
        lightData.brightness = lightData.brightness;
        float4 phongColor = phongShade(lightData,
                                       material,
                                       rd.worldPosition,
                                       rd.surfaceNormal,
                                       rd.toCameraVector);
        
        totalColor += attenuate(phongColor,
                                lightData.attenuation,
                                lightData.position,
                                rd.worldPosition);
    }
    
    //Apply Lighting Calculations
    if(material.isLit){
        color *= totalColor;
    }
    
    color = mix(float4(rd.skyColor, 1), color, rd.visibility);
    
    return half4(color.b, color.g, color.r, 1);
}

fragment half4 village_terrain_fragment_shader(const RasterizerData rd [[ stage_in ]],
                                               texture2d<float> texture [[ texture(0) ]],
                                               sampler sampler2d [[ sampler(0) ]],
                                               constant Material &material [[ buffer(1) ]],
                                               constant LightData *lightDatas [[ buffer(2) ]],
                                               constant int &lightCount [[ buffer(3) ]]){
    float4 color = texture.sample(sampler2d, rd.textureCoordinate);
    color = float4(color.r, color.b, color.g, color.a);
    
    float4 totalColor = color;
    
    for(int i = 0; i < lightCount; i++){
        LightData lightData = lightDatas[i];
        
        lightData.brightness = lightData.brightness;
        float4 phongColor = phongShade(lightData,
                                       material,
                                       rd.worldPosition,
                                       rd.surfaceNormal,
                                       rd.toCameraVector);
        
        totalColor += attenuate(phongColor,
                                lightData.attenuation,
                                lightData.position,
                                rd.worldPosition);
    }
    
    //Apply Lighting Calculations
    if(material.isLit){
        color *= totalColor;
    }
    
    color = mix(float4(rd.skyColor, 1), color, rd.visibility);
    
    return half4(color.r, color.g, color.b, 1);
}

//LIGHTING CODE
float3 specular(float3 normal,
                float3 toCameraVector,
                float3 toLightVector,
                float3 lightColor,
                float lightBrightness,
                float materialShininess,
                float3 materialSpecular){
    float3 unitVectorToCamera = normalize(toCameraVector);
    float3 unitToLightVector = normalize(toLightVector);
    float3 unitNormal = normalize(normal);
    
    float3 lightDirection = -unitToLightVector;
    float3 reflectedLightDirection = reflect(lightDirection, unitNormal);
    float specularFactor = max(saturate(dot(reflectedLightDirection, unitVectorToCamera)), 0.1);
    float dampedFactor = pow(specularFactor, materialShininess);
    float3 specular = dampedFactor * materialSpecular * lightColor;
    return specular * lightBrightness;
}

float3 diffuse(float3 normal,
               float3 toLightVector,
               float3 materialDiffuse,
               float lightBrightness,
               float3 lightColor){
    float3 unitNormal = normalize(normal);
    float3 unitToLightVector = normalize(toLightVector);
    float nDot1 = dot(unitNormal, unitToLightVector);
    float brightness = max(nDot1, 0.1);
    float3 diffuse = (brightness * materialDiffuse * lightColor);
    
    return diffuse;
}

float3 ambient(float3 lightColor,
               float3 materialAmbient,
               float lightBrightness){
    float3 ambientFactor = (lightColor * materialAmbient);
    return ambientFactor * lightBrightness;
}

float4 phongShade(LightData lightData,
                  Material material,
                  float3 worldPosition,
                  float3 normal,
                  float3 toCameraVector){
    float3 toLightVector = lightData.position - worldPosition;
    
    //Ambient
    float3 ambientFactor = ambient(lightData.color,
                                   material.ambient,
                                   lightData.brightness);
    
    
    //Diffuse
    float3 diffuseFactor = diffuse(normal,
                                   toLightVector,
                                   material.diffuse,
                                   lightData.brightness,
                                   lightData.color);
    
    
    //Specular
    float3 specularFactor = specular(normal,
                                     toCameraVector,
                                     toLightVector,
                                     lightData.color,
                                     lightData.brightness,
                                     material.shininess,
                                     material.specular);
    
    float3 phong = ambientFactor + diffuseFactor + specularFactor;
    return float4(phong, 1.0);
}

float4 attenuate(float4 currentColor,
                 float3 attenuation,
                 float3 lightPosition,
                 float3 worldPosition){
    float3 toLightVector = lightPosition - worldPosition;
    float distance = length(toLightVector);
    return currentColor / (attenuation.x + (attenuation.y * distance) + (attenuation.z * distance * distance));
}
