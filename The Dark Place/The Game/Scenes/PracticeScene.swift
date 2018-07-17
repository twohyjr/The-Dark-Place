import MetalKit

class PracticeScene: Scene {
    
    var gridSize: Int = 25
    var terrain: Terrain!
    
    override func buildScene() {
        setCameras()
        
        addTerrain()
    }
    
    
    private func setCameras(){
        let debugCamera = Debug_Camera()
        debugCamera.position = float3(0, 14.166669, 29.5833344)
        addCamera(camera: debugCamera)
    }
    
    private func addTerrain(){
        terrain = Terrain(gridSize: gridSize, cellsWide: 50, cellsBack: 50, textureType: .CartoonGrass)
        addChild(terrain)
    }
}
