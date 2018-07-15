import MetalKit

class VillageScene: Scene {
    
    var gridSize: Int = 25
    var terrain: Terrain!
    
    override func buildScene() {
        setCameras()
        
        addTerrain()
    }
    
    private func setCameras(){
        let debugCamera = Debug_Camera()
        addCamera(camera: debugCamera)
    }
    
    private func addTerrain(){
        terrain = Terrain(gridSize: gridSize, cellsWide: 50, cellsBack: 50)
        addChild(terrain)
    }
}
