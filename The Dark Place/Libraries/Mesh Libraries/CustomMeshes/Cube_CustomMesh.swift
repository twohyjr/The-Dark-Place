import MetalKit

class Cube_CustomMesh: CustomModelMesh {
    override func createVertices() {
        //Left
        addVertex(position: float3(-1.0,-1.0,-1.0), color: float4(1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0,-1.0, 1.0), color: float4(1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0, 1.0, 1.0), color: float4(1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0,-1.0,-1.0), color: float4(1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0, 1.0, 1.0), color: float4(1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0, 1.0,-1.0), color: float4(1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        
        //RIGHT
        addVertex(position: float3( 1.0, 1.0, 1.0), color: float4(1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0,-1.0,-1.0), color: float4(1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0, 1.0,-1.0), color: float4(1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0,-1.0,-1.0), color: float4(1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0, 1.0, 1.0), color: float4(1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0,-1.0, 1.0), color: float4(1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        
        //TOP
        addVertex(position: float3( 1.0, 1.0, 1.0), color: float4(1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0, 1.0,-1.0), color: float4(1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0, 1.0,-1.0), color: float4(1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0, 1.0, 1.0), color: float4(1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0, 1.0,-1.0), color: float4(1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0, 1.0, 1.0), color: float4(1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        
        //BOTTOM
        addVertex(position: float3( 1.0,-1.0, 1.0), color: float4(1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0,-1.0,-1.0), color: float4(1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0,-1.0,-1.0), color: float4(1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0,-1.0, 1.0), color: float4(1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0,-1.0, 1.0), color: float4(1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0,-1.0,-1.0), color: float4(1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        
        //BACK
        addVertex(position: float3( 1.0, 1.0,-1.0), color: float4(1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0,-1.0,-1.0), color: float4(1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0, 1.0,-1.0), color: float4(1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0, 1.0,-1.0), color: float4(1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0,-1.0,-1.0), color: float4(1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0,-1.0,-1.0), color: float4(1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        
        //FRONT
        addVertex(position: float3(-1.0, 1.0, 1.0), color: float4(1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0,-1.0, 1.0), color: float4(1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0,-1.0, 1.0), color: float4(1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0, 1.0, 1.0), color: float4(1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0, 1.0, 1.0), color: float4(1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0,-1.0, 1.0), color: float4(1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
    }
}
