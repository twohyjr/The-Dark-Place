import MetalKit

class TerrainMeshGenerator{
    public static func GenerateTerrainMesh(gridSize: Int, cellsWide: Int, cellsBack: Int)->Mesh{
        let terrainMesh = CustomMesh()

        //Gives you the location to place the next vertex
        let stepValueX: Float = Float(gridSize) / Float(cellsWide)
        let stepValueY: Float = Float(gridSize) / Float(cellsBack)
        
        for row in 0..<cellsWide{
            for column in 0..<cellsBack{
                var origin = float2(Float(Float(column) / Float(cellsWide)) * Float(gridSize),
                                    Float(Float(row) / Float(cellsBack)) * Float(gridSize))
                let vTopRight = float3(origin.x + stepValueX, 0, origin.y)
                let vTopLeft = float3(origin.x, 0, origin.y)
                let vBottomLeft = float3(origin.x, 0, origin.y + stepValueY)
                let vBottomRight = float3(origin.x + stepValueX, 0, origin.y + stepValueY)
                
                terrainMesh.addVertex(position: vTopRight, normal: float3( 0.0, 1.0, 0.0), textureCoordinate: float2(1,0))
                terrainMesh.addVertex(position: vTopLeft, normal: float3( 0.0, 1.0, 0.0), textureCoordinate: float2(0,0))
                terrainMesh.addVertex(position: vBottomLeft, normal: float3( 0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
                
                terrainMesh.addVertex(position: vTopRight, normal: float3( 0.0, 1.0, 0.0), textureCoordinate: float2(1,0))
                terrainMesh.addVertex(position: vBottomLeft, normal: float3( 0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
                terrainMesh.addVertex(position: vBottomRight, normal: float3( 0.0, 1.0, 0.0), textureCoordinate: float2(1,1))
            }
        }
        
        terrainMesh.createBuffers()
        
        return terrainMesh
    }
}
