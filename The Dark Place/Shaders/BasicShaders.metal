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
};

struct ModelConstants{
    float4x4 modelMatrix;
};

struct SceneConstants {
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
};

struct Material {
    float3 ambient; //Ka
    float3 diffuse; //Kd
    float3 specular; //Ks
};

struct LightData {
    float3 position;
    float3 ambientIntensity;
    float3 diffuseIntensity;
    float3 specularIntensity;
};

vertex RasterizerData basic_vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                                          constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                          constant ModelConstants &modelConstants [[ buffer(2) ]]){
    RasterizerData rd;
    
    float4x4 mvp = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * modelConstants.modelMatrix;
    
    rd.position = mvp * float4(vertexIn.position, 1);
    rd.color = vertexIn.color;
    
    return rd;
}

fragment half4 basic_fragment_shader(const RasterizerData rastData [[ stage_in ]],
                                     constant Material &material [[ buffer(1) ]]){
    float4 color = float4(material.diffuse,1);
   
    
    return half4(color.r, color.g, color.b, color.a);
}


vertex RasterizerData lit_basic_vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                                              constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                              constant ModelConstants &modelConstants [[ buffer(2) ]]){
    RasterizerData rd;
    
    float4x4 mvp = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * modelConstants.modelMatrix;
    
    rd.position = mvp * float4(vertexIn.position, 1);
    rd.color = vertexIn.color;
    
    return rd;
}

fragment half4 lit_basic_fragment_shader(const RasterizerData rastData [[ stage_in ]],
                                         constant Material &material [[ buffer(1) ]],
                                         constant LightData *lights [[ buffer(2) ]]){
    float4 color = float4(material.diffuse,1);
    if(sizeof(lights) > 0){
        LightData lightData = lights[0];
        color = float4(lightData.position,1);
    }
    return half4(color.r, color.g, color.b, color.a);
}

