import MetalKit

class PracticeScene: Scene {

    
    override func buildScene() {
        addCameras()
        
        addTerrain()
        
        addLights()
    }
    
    let camera = DebugCamera()
    func addCameras(){
        camera.setPosition(float3(0, 0.5, 1))
        camera.pitch = 0.5
        addCamera(camera: camera)
    }
    
    func addTerrain(){
        let terrainData = TerrainData(width: 10, depth: 10)
        let terrain = Terrain(gridSize: 1, terrainData: terrainData, textureType: TextureTypes.CartoonSand)
        addChild(terrain)
    }
    
    let light = LampGameObject()
    func addLights(){
        light.setPosition(float3(0,0.2,0))
        light.showObject = true
        light.setScale(0.01)
        light.attenuation = float3(1)
        addChild(light)
    }
    
    override func update(deltaTime: Float) {
        if(Keyboard.IsKeyPressed(.s)){
            light.moveZ(deltaTime / 3)
        }
        if(Keyboard.IsKeyPressed(.w)){
            light.moveZ(-(deltaTime / 3))
        }
        if(Keyboard.IsKeyPressed(.d)){
            light.moveX(deltaTime / 3)
        }
        if(Keyboard.IsKeyPressed(.a)){
            light.moveX(-(deltaTime / 3))
        }
        if(Keyboard.IsKeyPressed(.upArrow)){
            light.moveY(deltaTime / 3)
        }
        if(Keyboard.IsKeyPressed(.downArrow)){
            light.moveY(-(deltaTime / 3))
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
