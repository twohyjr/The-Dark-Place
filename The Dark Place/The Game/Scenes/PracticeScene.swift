import MetalKit

class PracticeScene: Scene {
    
    var light = LampGameObject()

    override func buildScene() {
        createScene()
        
        setCameras()
        
        addLights()
    }
    
    private func setCameras(){
        let camera = Drag_Camera()
        camera.position = float3(0, 0, 4)
        addCamera(camera: camera)
    }
    
    let pyramid = QuadPyramid()
    private func createScene(){
        addChild(pyramid)
    }

    private func addLights(){
        light.position = float3(0)
        addChild(light)
    }
    
    override func update(deltaTime: Float) {
        super.update(deltaTime: deltaTime)
//        self.pyramid.rotation.x -= deltaTime
    }

}
