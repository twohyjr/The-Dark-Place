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
};

vertex RasterizerData basic_vertex_shader(const VertexIn vertexIn [[ stage_in ]]){
    RasterizerData rd;
    
    rd.position = float4(vertexIn.position, 1);
    
    return rd;
}

fragment half4 basic_fragment_shader(){
    return half4(1,0,0,1);
}

