import MetalKit

class QuadPyramid_CustomMesh: CustomModelMesh {
    override func createVertices() {
        //Front
        addVertex(position: float3( 0, 1, 0), color: float4(1,0,0,1))
        addVertex(position: float3(-1,-1, 1), color: float4(0,1,0,1))
        addVertex(position: float3( 1,-1, 1), color: float4(0,0,1,1))

        //Left
        addVertex(position: float3( 0, 1, 0), color: float4(1,0,0,1))
        addVertex(position: float3(-1,-1,-1), color: float4(0,1,0,1))
        addVertex(position: float3(-1,-1, 1), color: float4(0,1,0,1))

        //Right
        addVertex(position: float3( 0, 1, 0), color: float4(1,0,0,1))
        addVertex(position: float3( 1,-1,-1), color: float4(0,1,0,1))
        addVertex(position: float3( 1,-1, 1), color: float4(0,1,0,1))

        //Back
        addVertex(position: float3( 0, 1, 0), color: float4(1,0,0,1))
        addVertex(position: float3(-1,-1,-1), color: float4(0,1,0,1))
        addVertex(position: float3( 1,-1,-1), color: float4(0,0,1,1))

        //Bottom Left
        addVertex(position: float3(-1,-1,-1), color: float4(1,0,0,1)) //back left
        addVertex(position: float3(-1,-1, 1), color: float4(0,1,0,1)) //front left
        addVertex(position: float3( 1,-1, 1), color: float4(0,0,1,1)) //front right
        
        //Bottom Right
        addVertex(position: float3( 1,-1, 1), color: float4(1,0,0,1)) //front right
        addVertex(position: float3(-1,-1,-1), color: float4(0,1,0,1)) //back left
        addVertex(position: float3( 1,-1,-1), color: float4(0,0,1,1)) //back right
        
    }
}
