import MetalKit

class Terrain: GameObject {
    
    init(gridSize: Int, cellsWide: Int, cellsBack: Int){
        super.init()
        self.mesh = TerrainMeshGenerator.GenerateTerrainMesh(gridSize: gridSize,
                                                             cellsWide: cellsWide,
                                                             cellsBack: cellsBack)
        self.position.x -= Float(gridSize / 2)
        self.position.z -= Float(gridSize / 2)
        self.position.y -= Float(1)
    }
    
}
