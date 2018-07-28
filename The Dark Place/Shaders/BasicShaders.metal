#include "SharedTypes.metal"
using namespace metal;

vertex RasterizerData basic_vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                                          constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                          constant ModelConstants &modelConstants [[ buffer(2) ]]){
    RasterizerData rd;
    
    //Model View Projection Matrix
    float4x4 mvp = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * modelConstants.modelMatrix;
    
    //The vertex position with relation to the mvp matrix
    float4 position = mvp * float4(vertexIn.position,1);
    
    rd.position = position;
    rd.textureCoordinate = vertexIn.textureCoordinate;
    rd.surfaceNormal = float4(modelConstants.normalMatrix * vertexIn.normal,1).xyz;
    
    rd.color = vertexIn.color;
    rd.worldPosition = float3(modelConstants.modelMatrix * position).xyz;
    rd.eyePosition = sceneConstants.eyePosition;
    
    return rd;
}

fragment half4 basic_fragment_shader(const RasterizerData rd [[ stage_in ]],
                                     constant Material &material [[ buffer(1) ]],
                                     constant Light &light [[ buffer(2) ]]){

    float4 color = float4(material.diffuse,1);
    
    //Ambient
    float3 ambient = material.ambient * light.color * light.brightness;
    
    //Diffuse
    float3 norm = normalize(rd.surfaceNormal);
    float3 lightDirection = normalize(light.position - rd.worldPosition);
    float diff = max(dot(norm, lightDirection), 0.2);
    float3 diffuse = material.diffuse * diff * light.color * light.brightness;
    
    //Specular
    float3 viewDirection = normalize(rd.eyePosition - rd.worldPosition);
    float3 reflectDirection = reflect(-lightDirection, norm);
    float spec = pow(max(dot(viewDirection, reflectDirection), 0.0), 32);
    float3 specular = material.specular * spec * light.color * light.brightness;
    
    float4 result = float4(ambient + diffuse + specular, color.a) * color;

    return half4(result.r, result.g, result.b, result.a);
}

