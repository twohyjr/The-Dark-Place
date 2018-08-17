import MetalKit

class PracticeScene: Scene {
    
    var light = LampGameObject()

    override func buildScene() {
        createScene()
        
        setCameras()
        
        addLights()
    }
    
    private func setCameras(){
        let debugCamera = Debug_Camera()
        debugCamera.position = float3(1, 5.499996, 9.08331)
        debugCamera.pitch = 0.5
        addCamera(camera: debugCamera)
    }
    
    private func createScene(){
        let tentWithPoles = TentWithPoles()
        tentWithPoles.rotation = float3(0.0, 3.0, 0.0)
        tentWithPoles.position.x = 3
        addChild(tentWithPoles)
    }
    

    
    private func addLights(){
        light.position = float3(10, 10, 10)
        addChild(light)
    }

}
