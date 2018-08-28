import MetalKit

class PracticeScene: Scene {

    
    override func buildScene() {
        addCameras()
        
        addLights()
        
        addObjects()
    }
    
    let debugCamera = DebugCamera()
    func addCameras(){
        debugCamera.setPosition(float3(0, 5, 8))
        debugCamera.setPitch(0.5)
        addCamera(camera: debugCamera)
    }
    
    func addLights(){
        let light = LampGameObject()
        light.brightness = 0.4
        light.setPosition(float3(10,20,20))
        addChild(light)
    }
    
    func addObjects(){
        let cube = Cube()
        addChild(cube)
    }
    
}
