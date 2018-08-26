import MetalKit

class PracticeScene: Scene{
    
    var debugCamera = Debug_Camera()
    
    var cube = Cube()
    override func buildScene() {
        addCamera(debugCamera)
        
        debugCamera.position.z = 8
        
        addChild(cube)
    }
    
    override func update(deltaTime: Float) {
        cube.rotation.x += deltaTime
        cube.rotation.y += deltaTime
        super.update(deltaTime: deltaTime)
    }
}
