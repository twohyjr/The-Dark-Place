#include "Types.metal"
using namespace metal;

//------- FUNCTION DEFINITIONS ------------
float4 applyPhongLighting(float4 color, Material material, LightData light, float3 surfaceNormal, float3 toLightVector, float3 toCameraVector);

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
    float viewDistance = length(rd.worldPosition);
    float visibility = exp(-pow((viewDistance * fog.density), fog.gradient));
    rd.visibility = clamp(visibility, 0.0, 1.0);
    
    return rd;
}


vertex RasterizerData village_terrain_vertex_shader(const VertexIn vertexIn [[ stage_in ]],
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
    return rd;
}

//------- FRAGMENT SHADERS ------------
fragment half4 basic_fragment_shader(const RasterizerData rd [[ stage_in ]],
                                     constant Material &material [[ buffer(1) ]],
                                     constant LightData *lightDatas [[ buffer(2) ]],
                                     constant int &lightCount [[ buffer(3) ]]){
    float4 color = material.isLit ? float4(material.diffuse,1) : material.color;
    
    float3 totalAmbient = float3(0.0);
    float3 totalDiffuse = float3(0.0);
    float3 totalSpecular = float3(0.0);
    
    for(int i = 0; i < lightCount; i++){
        LightData lightData = lightDatas[i];
        
        float3 toLightVector = lightData.position - rd.worldPosition;
        float3 unitLightVector = normalize(toLightVector);
        float distance = length(toLightVector);
        float3 attenuation = lightData.attenuation;
        float attenuationFactor = attenuation.x + (attenuation.y * distance) + (attenuation.z * distance * distance);
        float3 unitNormal = normalize(rd.surfaceNormal);
        
        //Ambient
        float3 ambient = (lightData.color * material.ambient) / attenuationFactor;
        totalAmbient += ambient * lightData.brightness;
        
        //Diffuse
        float nDot1 = dot(unitNormal, unitLightVector);
        float brightness = max(nDot1, 0.1);
        float3 diffuse = (brightness * lightData.color * material.diffuse) / attenuationFactor;
        totalDiffuse = totalDiffuse + diffuse * lightData.brightness;
        
        //Specular
        float3 unitVectorToCamera = normalize(rd.toCameraVector);
        float3 lightDirection = -unitLightVector;
        float3 reflectedLightDirection = reflect(lightDirection, unitNormal);
        float specularFactor = saturate(dot(reflectedLightDirection, unitVectorToCamera));
        specularFactor = max(specularFactor, 0.1);
        float dampedFactor = pow(specularFactor, material.shininess);
        float3 specular = (dampedFactor * material.specular * lightData.color) / attenuationFactor;
        totalSpecular = totalSpecular + specular * lightData.brightness;
    }
    
    if(material.isLit){
        color *= (float4(totalDiffuse, 1.0) + float4(totalSpecular, 1.0) + float4(totalAmbient,1));
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
    
    
    float3 totalAmbient = float3(0.0);
    float3 totalDiffuse = float3(0.0);
    float3 totalSpecular = float3(0.0);
    
    for(int i = 0; i < lightCount; i++){
        LightData lightData = lightDatas[i];
        
        //Ambient
        float3 toLightVector = lightData.position - rd.worldPosition;
        float3 unitLightVector = normalize(toLightVector);
        float3 unitNormal = normalize(rd.surfaceNormal);
        float3 ambient = lightData.color * material.ambient * lightData.brightness;
        totalAmbient += ambient / 4;
        
        //Diffuse
        float nDot1 = dot(unitNormal, unitLightVector);
        float brightness = max(nDot1, 0.1);
        float3 diffuse = brightness * lightData.color * material.diffuse * lightData.brightness;
        totalDiffuse += diffuse;
        
        //Specular
        float3 unitVectorToCamera = normalize(rd.toCameraVector);
        float3 lightDirection = -unitLightVector;
        float3 reflectedLightDirection = reflect(lightDirection, unitNormal);
        float specularFactor = saturate(dot(reflectedLightDirection, unitVectorToCamera));
        specularFactor = max(specularFactor, 0.1);
        float dampedFactor = pow(specularFactor, material.shininess);
        float3 specular = dampedFactor * material.specular * lightData.color * lightData.brightness;
        totalSpecular += specular;
    }
    
    if(material.isLit){
        color *= (float4(totalDiffuse, 1.0) + float4(totalSpecular, 1.0) + float4(totalAmbient,1));
    }
    
    return half4(color.r, color.g, color.b, 1);
    
    return half4(color.x, color.y, color.z, 1);
}



