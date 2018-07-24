#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float3 normal [[ attribute(2) ]];
    float2 textureCoordinate [[ attribute(3) ]];
};

struct RasterizerData {
    float4 position [[ position ]];
    float4 color;
    float3 surfaceNormal;
    float2 textureCoordinate;
    float3 worldPosition;
    float3 eyePosition;
};

struct ModelConstants{
    float4x4 modelMatrix;
    float3x3 normalMatrix;
};

struct SceneConstants {
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
    float3 eyePosition;
    float4x4 inverseViewMatrix;
};

struct Material {
    float shininess;
    float3 ambient; //Ka
    float3 diffuse; //Kd
    float3 specular; //Ks
};

struct Light {
    float brightness;
    float3 position;
    float3 color;
    float ambientStrength;
    float diffuseStrength;
    float specularStrength;
};

vertex RasterizerData village_terrain_vertex_shader(const VertexIn vertexIn [[ stage_in ]],
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


constexpr sampler sampler2d(address::clamp_to_zero,
                    filter::linear,
                    compare_func::less);

fragment half4 village_terrain_fragment_shader(const RasterizerData rd [[ stage_in ]],
                                               texture2d<float> texture [[ texture(0) ]],
                                               constant Material &material [[ buffer(1) ]],
                                               constant Light *lights [[ buffer(2) ]],
                                               constant int &lightCount [[ buffer(3) ]]){
    float4 color = texture.sample(sampler2d, rd.textureCoordinate);
    float3 totalAmbient = 0;
    float3 totalDiffuse = 0;
    float3 totalSpecular = 0;
    
    for(int i = 0; i < lightCount; i++){
        Light light = lights[i];
        
        //Ambient
        float3 ambientStrength = light.ambientStrength;
        float3 ambient = material.ambient * ambientStrength * light.color * light.brightness;
        
        //Diffuse
        float diffuseStrength = light.diffuseStrength;
        float3 norm = normalize(rd.surfaceNormal);
        float3 lightDirection = normalize(light.position - rd.worldPosition);
        float brightness = max(dot(norm, lightDirection), 0.0);
        float3 diffuse = material.diffuse * diffuseStrength * brightness * light.color * light.brightness;
        
        //Specular
        float specularStrength = light.specularStrength;
        float3 viewDirection = normalize(rd.eyePosition - rd.worldPosition);
        float3 reflectDirection = reflect(-lightDirection, norm);
        float spec = pow(max(dot(viewDirection, reflectDirection), 0.0), 32);
        float3 specular = material.specular * specularStrength * spec * light.color * light.brightness;
        
        totalAmbient += ambient / lightCount;
        totalDiffuse += diffuse / lightCount;
        totalSpecular += specular / lightCount;
    }
    
    float4 result = float4(totalAmbient + totalDiffuse + totalSpecular, color.a) * color;
    
    return half4(result.r, result.g, result.b, result.a);
    return half4(color.b, color.g, color.r, color.a);
}
