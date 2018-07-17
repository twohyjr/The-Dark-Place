import MetalKit

class Terrain: GameObject {
    
    let tent = Tent()
    init(gridSize: Int, cellsWide: Int, cellsBack: Int){
        super.init()
        self.mesh = TerrainMeshGenerator.GenerateTerrainMesh(gridSize: gridSize,
                                                             cellsWide: cellsWide,
                                                             cellsBack: cellsBack)
        self.position.x -= Float(gridSize / 2)
        self.position.z -= Float(gridSize / 2)
        self.material.color = float4(0.7, 0.7, 0.7, 1.0)
        
        
        addChild(tent)
    }
    
    override func update(deltaTime: Float) {
        if(Keyboard.IsKeyPressed(.space)){
            self.position.x += deltaTime
        }
        super.update(deltaTime: deltaTime)
    }
}
