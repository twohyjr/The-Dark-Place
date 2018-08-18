import MetalKit

class Cube_CustomMesh: CustomModelMesh {
    
    private var mins: float3!
    private var maxs: float3!
    
    init(mins: float3 = float3(-1,-1,-1), maxs: float3 = float3(1,1,1), isBoundingBox: Bool = false){
        self.mins = mins
        self.maxs = maxs
        super.init(isBoundingBox: isBoundingBox)
    }
    override func createVertices() {
        //Left
        addVertex(position: float3(mins.x, mins.y, mins.z), color: float4(1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(mins.x, mins.y, maxs.z), color: float4(1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(mins.x, maxs.y, maxs.z), color: float4(1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(mins.x, mins.y, mins.z), color: float4(1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(mins.x, maxs.y, maxs.z), color: float4(1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(mins.x, maxs.y, mins.z), color: float4(1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        
        //RIGHT
        addVertex(position: float3(maxs.x, maxs.y, maxs.z), color: float4(1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(maxs.x, mins.y, mins.z), color: float4(1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(maxs.x, maxs.y, mins.z), color: float4(1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(maxs.x, mins.y, mins.z), color: float4(1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(maxs.x, maxs.y, maxs.z), color: float4(1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(maxs.x, mins.y, maxs.z), color: float4(1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        
        //TOP
        addVertex(position: float3(maxs.x, maxs.y, maxs.z), color: float4(1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(maxs.x, maxs.y, mins.z), color: float4(1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(mins.x, maxs.y, mins.z), color: float4(1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(maxs.x, maxs.y, maxs.z), color: float4(1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(mins.x, maxs.y, mins.z), color: float4(1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(mins.x, maxs.y, maxs.z), color: float4(1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        
        //BOTTOM
        addVertex(position: float3(maxs.x, mins.y, maxs.z), color: float4(1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(mins.x, mins.y, mins.z), color: float4(1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(maxs.x, mins.y, mins.z), color: float4(1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(maxs.x, mins.y, maxs.z), color: float4(1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(mins.x, mins.y, maxs.z), color: float4(1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(mins.x, mins.y,maxs.z), color: float4(1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        
        //BACK
        addVertex(position: float3(maxs.x, maxs.y, mins.z), color: float4(1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(mins.x, mins.y, mins.z), color: float4(1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(mins.x, maxs.y, mins.z), color: float4(1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(maxs.x, maxs.y, mins.z), color: float4(1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(maxs.x, mins.y, mins.z), color: float4(1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(mins.x, mins.y, mins.z), color: float4(1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        
        //FRONT
        addVertex(position: float3(mins.x, maxs.y, maxs.z), color: float4(1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(mins.x, mins.y, maxs.z), color: float4(1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(maxs.x, mins.y, maxs.z), color: float4(1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(maxs.x, maxs.y, maxs.z), color: float4(1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(mins.x, maxs.y, maxs.z), color: float4(1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(maxs.x, mins.y, maxs.z), color: float4(1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
    }
}
