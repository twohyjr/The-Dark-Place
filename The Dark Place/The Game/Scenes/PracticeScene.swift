import MetalKit

class PracticeScene: Scene {

    
    override func buildScene() {
        addCameras()
        
        addTerrain()
        
        addObjects()
        
        addLights()
    }
    
    let debugCamera = DebugCamera()
    func addCameras(){
        debugCamera.setPosition(float3(-1.4901161e-08, 10.499996, 16.08331))
        debugCamera.setPitch(0.5)
        addCamera(camera: debugCamera)
    }
    
    func addTerrain(){
        let terrainData = TerrainData(width: 10, depth: 10)
        let terrain = Terrain(gridSize: 10, terrainData: terrainData, textureType: TextureTypes.CartoonSand)
        addChild(terrain)
    }
    
    func addObjects(){
        let tent = Tent()
        tent.setRotation(float3(0.0, 3.3833308, 0.0))
        tent.setPosition(float3(-1,-0.01,0))
        addChild(tent)
        
        let tentWithPoles = TentWithPoles()
        tentWithPoles.setRotation(float3(0.0, 3.0, 0.0))
        tentWithPoles.setPosition(float3(3,0,0))
        addChild(tentWithPoles)
    }
    
    let light = LampGameObject()
    func addLights(){
        light.setPosition(float3(0,0.2,0))
        light.showGameModel()
        light.setScale(0.01)
        addChild(light)
    }
    
    override func update(deltaTime: Float) {
        let delta: Float = 0.01
        if(Keyboard.IsKeyPressed(.one)){
            light.setAttenuation(float3(light.getAttenuation().x + delta, light.getAttenuation().y, light.getAttenuation().z))
        }
        
        if(Keyboard.IsKeyPressed(.two)){
            light.setAttenuation(float3(light.getAttenuation().x - delta, light.getAttenuation().y, light.getAttenuation().z))
        }
        
        if(Keyboard.IsKeyPressed(.three)){
            light.setAttenuation(float3(light.getAttenuation().x, light.getAttenuation().y + delta, light.getAttenuation().z))
        }
        
        if(Keyboard.IsKeyPressed(.four)){
            light.setAttenuation(float3(light.getAttenuation().x, light.getAttenuation().y - delta, light.getAttenuation().z))
        }
        
        if(Keyboard.IsKeyPressed(.five)){
            light.setAttenuation(float3(light.getAttenuation().x, light.getAttenuation().y, light.getAttenuation().z + delta))
        }
        
        if(Keyboard.IsKeyPressed(.six)){
            light.setAttenuation(float3(light.getAttenuation().x, light.getAttenuation().y, light.getAttenuation().z - delta))
        }
        
        print(light.getAttenuation())
        
        
        if(Keyboard.IsKeyPressed(.s)){
            light.moveZ(deltaTime)
        }
        if(Keyboard.IsKeyPressed(.w)){
            light.moveZ(-deltaTime)
        }
        if(Keyboard.IsKeyPressed(.d)){
            light.moveX(deltaTime)
        }
        if(Keyboard.IsKeyPressed(.a)){
            light.moveX(-deltaTime)
        }
        if(Keyboard.IsKeyPressed(.upArrow)){
            light.moveY(deltaTime)
        }
        if(Keyboard.IsKeyPressed(.downArrow)){
            light.moveY(-deltaTime)
        }
        if(Keyboard.IsKeyPressed(.one)){
            light.brightness += deltaTime
        }
        if(Keyboard.IsKeyPressed(.two)){
            light.brightness -= deltaTime
        }
        super.update(deltaTime: deltaTime)
    }
    
}
