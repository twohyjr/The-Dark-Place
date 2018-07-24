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
                                     constant Material &material [[ buffer(1) ]]){
    
    float4 color = float4(material.diffuse,1);
    
    float3 lightColor = float3(1);
    float lightBrightness = 1.8;
    float3 lightPosition = float3(400,100,250);
    
    //Ambient
    float3 ambientStrength = 0.1;
    float3 ambient = material.ambient * ambientStrength * lightColor * lightBrightness;
    
    //Diffuse
    float3 norm = normalize(rd.surfaceNormal);
    float3 lightDirection = normalize(lightPosition - rd.worldPosition);
    float diff = max(dot(norm, lightDirection), 0.2);
    float3 diffuse = material.diffuse * diff * lightColor * lightBrightness;
    
    float specularStrength = 0.5;
    float3 viewDirection = normalize(rd.eyePosition - rd.worldPosition);
    float3 reflectDirection = reflect(-lightDirection, norm);
    float spec = pow(max(dot(viewDirection, reflectDirection), 0.0), 32);
    float3 specular = material.specular * specularStrength * spec * lightColor * lightBrightness;
    
    float4 result = float4(ambient + diffuse + specular, color.a) * color;

    return half4(result.r, result.g, result.b, result.a);
}

