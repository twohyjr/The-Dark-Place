#include "SharedTypes.metal"
using namespace metal;

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


constexpr sampler sampler2d(address::clamp_to_zero,
                    filter::linear,
                    compare_func::less);

fragment half4 village_terrain_fragment_shader(const RasterizerData rd [[ stage_in ]],
                                               texture2d<float> texture [[ texture(0) ]],
                                               constant Material &material [[ buffer(1) ]],
                                               constant Light &light [[ buffer(2) ]]){
    float4 color = texture.sample(sampler2d, rd.textureCoordinate);
    
    float3 toLightVector = light.position - rd.worldPosition;
    
    float3 unitNormal = normalize(rd.surfaceNormal);
    float3 unitLightVector = normalize(toLightVector);
    
    float3 ambient = light.color * material.ambient;
    
    float nDot1 = dot(unitNormal, unitLightVector);
    float brightness = max(nDot1, 0.0);
    float3 diffuse = brightness * light.color * light.brightness;
    
    float3 unitVectorToCamera = normalize(rd.toCameraVector);
    float3 lightDirection = -unitLightVector;
    float3 reflectedLightDirection = reflect(lightDirection, unitNormal);
    float specularFactor = saturate(dot(reflectedLightDirection, unitVectorToCamera));
    specularFactor = max(specularFactor, 0.0);
    float dampedFactor = pow(specularFactor, material.shininess);
    float3 finalSpecular = dampedFactor * material.specular * light.color;
    
    color = color * (float4(diffuse, 1.0) + float4(finalSpecular, 1.0) + float4(ambient,1)) * (light.brightness / 2);
    
    if (color.a == 0.0){
        discard_fragment();
    }
    
    return half4(color.x, color.y, color.z, 1);
}
