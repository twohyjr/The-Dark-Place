import MetalKit

class VillageScene: Scene {
    
    var debugCamera = Debug_Camera()
    override func buildScene() {
        
        addCamera(camera: debugCamera)
        
        addChild(VillageTerrain())
        
    }

    
    override func update(deltaTime: Float) {
        print(debugCamera.position)
        super.update(deltaTime: deltaTime)
    }
}
