#include "Types.metal"
using namespace metal;

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
    float4 color = material.isLit ? float4(material.diffuse,1) : material.color;
    
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

    return half4(color.r, color.g, color.b, 1);
}

fragment half4 rigged_fragment_shader(const RasterizerData rd [[ stage_in ]],
                                        texture2d<float> texture [[ texture(0) ]],
                                        sampler sampler2d [[ sampler(0) ]],
                                        constant Material &material [[ buffer(1) ]],
                                        constant LightData *lightDatas [[ buffer(2) ]],
                                        constant int &lightCount [[ buffer(3) ]]){
    float4 color = texture.sample(sampler2d, rd.textureCoordinate);
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
    
    return half4(color.r, color.b, color.g, 1);
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
