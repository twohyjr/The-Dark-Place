import MetalKit

class PracticeScene: Scene {

    
    override func buildScene() {
        addCameras()
        
        addLights()
        
        addObjects()
    }
    
    let debugCamera = DebugCamera()
    func addCameras(){
        debugCamera.setPosition(float3(0, 5, 10))
        debugCamera.setPitch(0.23)
        addCamera(camera: debugCamera)
    }
    
    let light = Lantern(.Green)
    func addLights(){
        light.setRotation(float3(0.0, 3, 0.0))
        light.brightness = 1
        light.moveY(1)
        addChild(light)
    }
    
    func addObjects(){
        let cube = Cube()

        addChild(cube)
    }
    
    override func update(deltaTime: Float) {
        super.update(deltaTime: deltaTime)
    }
    
}
