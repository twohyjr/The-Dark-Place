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
                                     constant LightData *lights [[ buffer(2) ]]){
    LightData lightData = lights[0];
    float4 color = float4(material.diffuse,1);
    float3 toLightVector = lightData.position - rd.worldPosition;
    
    float4 litColor = applyPhongLighting(color, material, lightData, rd.surfaceNormal, toLightVector, rd.toCameraVector);
    
    color *= litColor;
    
    if (color.a == 0.0){
        discard_fragment();
    }
    
    return half4(color.x, color.y, color.z, 1);
    
    
}

fragment half4 village_terrain_fragment_shader(const RasterizerData rd [[ stage_in ]],
                                               texture2d<float> texture [[ texture(0) ]],
                                               sampler sampler2d [[ sampler(0) ]],
                                               constant Material &material [[ buffer(1) ]],
                                               constant LightData *lights [[ buffer(2) ]]){
    LightData lightData = lights[0];
    float4 color = texture.sample(sampler2d, rd.textureCoordinate);
    
    float3 toLightVector = lightData.position - rd.worldPosition;
    
    float4 litColor = applyPhongLighting(color, material, lightData, rd.surfaceNormal, toLightVector, rd.toCameraVector);
    
    color *= litColor;
    
    if (color.a == 0.0){
        discard_fragment();
    }
    
    return half4(color.x, color.y, color.z, 1);
}

//------- FUNCTION IMPLEMENTATIONS ------------
float4 applyPhongLighting(float4 color, Material material, LightData lightData, float3 surfaceNormal, float3 toLightVector, float3 toCameraVector){
    //Ambient
    float3 unitNormal = normalize(surfaceNormal);
    float3 unitLightVector = normalize(toLightVector);
    float3 ambient = lightData.color * material.ambient;
    
    //Diffuse
    float nDot1 = dot(unitNormal, unitLightVector);
    float brightness = max(nDot1, 0.1);
    float3 diffuse = brightness * lightData.color * lightData.brightness;
    
    //Specular
    float3 unitVectorToCamera = normalize(toCameraVector);
    float3 lightDirection = -unitLightVector;
    float3 reflectedLightDirection = reflect(lightDirection, unitNormal);
    float specularFactor = saturate(dot(reflectedLightDirection, unitVectorToCamera));
    specularFactor = max(specularFactor, 0.1);
    float dampedFactor = pow(specularFactor, material.shininess);
    float3 finalSpecular = dampedFactor * material.specular * lightData.color;
    
    color = (float4(diffuse, 1.0) + float4(finalSpecular, 1.0) + float4(ambient,1)) * lightData.brightness;
    
    return color;
}


