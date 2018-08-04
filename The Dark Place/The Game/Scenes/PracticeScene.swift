import MetalKit

class PracticeScene: Scene {
    
    var gridSize: Int = 15
    var terrain: Terrain!
    var sunBackLeft = LampGameObject(.Cube_Custom)

    override func buildScene() {
        setCameras()
        
        addTerrain()
        
        addLights()
    }
    
    private func setCameras(){
        let debugCamera = Debug_Camera()
        debugCamera.position = float3(-1.4901161e-08, 10.499996, 16.08331)
        debugCamera.pitch = 0.5
        addCamera(camera: debugCamera)
    }
    
    private func addLights(){
        sunBackLeft.position = float3(-1000, 300, 1000)
        sunBackLeft.brightness = 2
        addChild(sunBackLeft)
    }
    
    private func addTerrain(){
        terrain = Terrain(gridSize: gridSize, cellsWide: 10, cellsBack: 10, textureType: .CartoonGrass)
        terrain.diffuse = 1.5
        addChild(terrain)
    }
    
}
