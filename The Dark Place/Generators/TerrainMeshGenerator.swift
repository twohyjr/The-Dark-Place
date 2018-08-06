import MetalKit

class TerrainMeshGenerator{
    public static func GenerateTerrainMesh(gridSize: Int, terrainData: TerrainData)->CustomMesh{
        let terrainMesh = CustomModelMesh()
        let cellsWide = terrainData.width
        let cellsBack = terrainData.depth

        //Gives you the location to place the next vertex
        let stepValueX: Float = Float(gridSize) / Float(cellsWide)
        let stepValueY: Float = Float(gridSize) / Float(cellsBack)
        
        for column in 0..<cellsWide{
            for row in 0..<cellsBack{
                var origin = float2(Float(Float(column) / Float(cellsWide)) * Float(gridSize),
                                    Float(Float(row) / Float(cellsBack)) * Float(gridSize))
                
                let heightTopRight = terrainData.getHeightAt(x: column + 1, z: row)
                let heightTopLeft = terrainData.getHeightAt(x: column, z: row)
                let heightBottomLeft = terrainData.getHeightAt(x:column, z: row + 1)
                let heightBottomRight = terrainData.getHeightAt(x: column + 1, z: row + 1)
                
                let vTopRight = float3(origin.x + stepValueX, heightTopRight, origin.y)
                let vTopLeft = float3(origin.x, heightTopLeft, origin.y)
                let vBottomLeft = float3(origin.x, heightBottomLeft, origin.y + stepValueY)
                let vBottomRight = float3(origin.x + stepValueX, heightBottomRight, origin.y + stepValueY)

                let normalTopRight = calculateNormal(terrainData: terrainData, x: column + 1, z: row)
                let normalTopLeft = calculateNormal(terrainData: terrainData, x: column, z: row)
                let normalBottomLeft = calculateNormal(terrainData: terrainData, x: column, z: row + 1)
                let normalBottomRight = calculateNormal(terrainData: terrainData, x: column + 1, z: row + 1)
                
                terrainMesh.addVertex(position: vTopRight, normal: normalTopRight, textureCoordinate: float2(1,0))
                terrainMesh.addVertex(position: vTopLeft, normal: normalTopLeft, textureCoordinate: float2(0,0))
                terrainMesh.addVertex(position: vBottomLeft, normal: normalBottomLeft, textureCoordinate: float2(0,1))
                
                terrainMesh.addVertex(position: vTopRight, normal: normalTopRight, textureCoordinate: float2(1,0))
                terrainMesh.addVertex(position: vBottomLeft, normal: normalBottomLeft, textureCoordinate: float2(0,1))
                terrainMesh.addVertex(position: vBottomRight, normal: normalBottomRight, textureCoordinate: float2(1,1))
            }
        }
        
        terrainMesh.createBuffers()
        
        return terrainMesh
    }
    
    private static func calculateNormal(terrainData: TerrainData, x: Int, z: Int)->float3{
        let heightL = terrainData.getHeightAt(x: x - 1, z: z)
        let heightR = terrainData.getHeightAt(x: x + 1, z: z)
        let heightD = terrainData.getHeightAt(x: x - 1, z: z - 1)
        let heightU = terrainData.getHeightAt(x: x, z: z + 1)
        var normal = float3(heightL - heightR, 2.0, heightD - heightU)
        normal = normalize(normal)
        return normal
    }
}
