import MetalKit

class VillageScene: Scene {
    
    var debugCamera = Debug_Camera()
    override func buildScene() {
        
        addCamera(camera: debugCamera)
        
        addChild(VillageTerrain())
        
    }
    
    override func update(deltaTime: Float) {
        let dWheel = Mouse.GetDWheel() * 0.5
        if(debugCamera.zoom + dWheel < 47 && debugCamera.zoom + dWheel > 10) {
            debugCamera.zoom += dWheel
        }
        super.update(deltaTime: deltaTime)
    }
}
