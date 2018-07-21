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
};

struct ModelConstants{
    float4x4 modelMatrix;
    float3x3 normalMatrix;
};

struct SceneConstants {
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
};

struct Material {
    float shininess;
    float3 ambient; //Ka
    float3 diffuse; //Kd
    float3 specular; //Ks
};

struct Light {
    float3 position;
    float ambientIntensity;
};

struct LightData {
    int lightCount;
    device Light *lights;
};

vertex RasterizerData basic_vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                                          constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                          constant ModelConstants &modelConstants [[ buffer(2) ]]){
    RasterizerData rd;
    
    //Model View Projection Matrix
    float4x4 mvp = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * modelConstants.modelMatrix;
    
    //The vertex position with relation to the mvp matrix
    float4 position = mvp * float4(vertexIn.position,1);
    
    //The normal on the surface of the object with relation to the eye
    float3 surfaceNormal = normalize(sceneConstants.viewMatrix * float4(modelConstants.normalMatrix * vertexIn.normal,1)).xyz;
    
    rd.position = position;
    rd.textureCoordinate = vertexIn.textureCoordinate;
    rd.surfaceNormal = surfaceNormal;
    rd.color = vertexIn.color;
    
    return rd;
}

fragment half4 basic_fragment_shader(const RasterizerData rastData [[ stage_in ]],
                                     constant Material &material [[ buffer(1) ]],
                                     constant LightData &lightData [[ buffer(2) ]]){
    float4 color = float4(material.diffuse,1);
    
    return half4(color.r, color.g, color.b, color.a);
}

