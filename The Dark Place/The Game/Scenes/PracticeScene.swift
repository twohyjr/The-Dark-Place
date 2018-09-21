import MetalKit

class PracticeScene: Scene {

    
    override func buildScene() {
        addCameras()
        
        addLights()
        
        addObjects()
    }
    
    let debugCamera = DebugCamera()
    func addCameras(){
        debugCamera.setPosition(float3(4, 5, 8))
        debugCamera.setPitch(0.5)
        addCamera(camera: debugCamera)
    }
    
    let light = LampGameObject()
    func addLights(){
//        light.brightness = 1.0
        light.setColor(float4(0.2,0.5,0,1))
        light.showGameModel()
        light.setPositionY(2)
        addChild(light)
    }
    
    func addObjects(){
        let cube = Cube()

        addChild(cube)
    }
    
    override func update(deltaTime: Float) {
        if(Keyboard.IsKeyPressed(.w)){
           light.moveY(deltaTime)
        }
        if(Keyboard.IsKeyPressed(.s)){
            light.moveY(-deltaTime)
        }
        if(Keyboard.IsKeyPressed(.a)){
            light.moveX(-deltaTime)
        }
        if(Keyboard.IsKeyPressed(.d)){
            light.moveX(deltaTime)
        }
        if(Keyboard.IsKeyPressed(.q)){
            light.moveZ(-deltaTime)
        }
        if(Keyboard.IsKeyPressed(.z)){
            light.moveZ(deltaTime)
        }
        
        super.update(deltaTime: deltaTime)
    }
    
}
