import MetalKit

class Quad_CustomMesh: CustomModelMesh {
    //Origin: Bottom Left
    override func createVertices() {
        //Top Right
        addVertex(position: float3( 1, 1,0), color: float4(1,0,0,1), normal: float3( 0.0, 0.0, -1.0), textureCoordinate: float2(1,0))
        
        //Top Left
        addVertex(position: float3(-1, 1,0), color: float4(0,1,0,1), normal: float3( 0.0, 0.0, -1.0), textureCoordinate: float2(0,0))
        
        //Bottom Left
        addVertex(position: float3(-1,-1,0), color: float4(0,0,1,1), normal: float3( 0.0, 0.0, -1.0), textureCoordinate: float2(0,1))
        
        //Top Right
        addVertex(position: float3( 1, 1,0), color: float4(1,0,0,1), normal: float3( 0.0, 0.0, -1.0), textureCoordinate: float2(1,0))
        
        //Bottom Left
        addVertex(position: float3(-1,-1,0), color: float4(0,0,1,1), normal: float3( 0.0, 0.0, -1.0), textureCoordinate: float2(0,1))
        
        //Bottom Right
        addVertex(position: float3( 1,-1,0), color: float4(1,0,1,1), normal: float3( 0.0, 0.0, -1.0), textureCoordinate: float2(1,1))
    }
}
