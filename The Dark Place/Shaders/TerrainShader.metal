#include "SharedTypes.metal"
using namespace metal;

vertex RasterizerData village_terrain_vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                                                           constant SceneConstants &sceneConstants [[ buffer(1) ]],
                                                           constant ModelConstants &modelConstants [[ buffer(2) ]]){
    RasterizerData rd;
    float4x4 mvp = sceneConstants.projectionMatrix * sceneConstants.viewMatrix * modelConstants.modelMatrix;
    
    rd.position = mvp * float4(vertexIn.position, 1);
    rd.textureCoordinate = vertexIn.textureCoordinate;
    return rd;
}


constexpr sampler sampler2d(address::clamp_to_zero,
                    filter::linear,
                    compare_func::less);

fragment half4 village_terrain_fragment_shader(const RasterizerData rd [[ stage_in ]],
                                               texture2d<float> texture [[ texture(0) ]],
                                               constant Material &Material [[ buffer(1) ]]){
    float4 color = texture.sample(sampler2d, rd.textureCoordinate);
    
    return half4(color.b, color.g, color.r, color.a);
}
