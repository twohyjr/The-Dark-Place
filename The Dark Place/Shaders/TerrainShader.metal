#include <metal_stdlib>
using namespace metal;

struct VertexIn{
    float3 position [[ attribute(0) ]];
    float4 color [[ attribute(1) ]];
    float3 normal [[ attribute(2) ]];
    float2 textureCoordinate [[ attribute(3) ]];
};

struct TerrainRasterizerData {
    float4 position [[ position ]];
    float2 textureCoordinate;
};

struct ModelConstants{
    float4x4 modelMatrix;
};

struct SceneConstants {
    float4x4 viewMatrix;
    float4x4 projectionMatrix;
};

vertex TerrainRasterizerData village_terrain_vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                                                           constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                                           constant ModelConstants &modelConstants [[ buffer(2) ]]){
    TerrainRasterizerData rd;
    float4x4 mvp = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * modelConstants.modelMatrix;
    
    rd.position = mvp * float4(vertexIn.position, 1);
    rd.textureCoordinate = vertexIn.textureCoordinate;
    return rd;
}


constexpr sampler sampler2d(address::clamp_to_zero,
                    filter::linear,
                    compare_func::less);

fragment half4 village_terrain_fragment_shader(const TerrainRasterizerData rd [[ stage_in ]],
                                               texture2d<float> texture [[ texture(0) ]]){
    float4 color = texture.sample(sampler2d, rd.textureCoordinate);
    
    return half4(color.r, color.g, color.b, color.a);
}
