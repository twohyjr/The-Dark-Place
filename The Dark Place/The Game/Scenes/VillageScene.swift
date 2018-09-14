import MetalKit

class VillageScene: Scene {
    
    override func buildScene() {
        addCameras()
        
        setFog()
        
        addTerrain()
        
        addTents()
        
        addTrees()
        
        addLights()
        
        addAnimatedModel()
    }
    
    let debugCamera = DebugCamera()
    func addCameras(){
        debugCamera.setPosition(float3(-1.5, 10.5, 25.10))
        debugCamera.setPitch(0.22)
        debugCamera.setYaw(-0.98)
        addCamera(camera: debugCamera)
    }
    
    func setFog(){
        fog.density = 0.019000001
        fog.gradient = 2.0999603
    }
    
    func addTerrain(){
        let terrainData = TerrainData(width: 200, depth: 200)
        let terrain = Terrain(gridSize: 1000, terrainData: terrainData, textureType: TextureTypes.CartoonSand, name: "Main Terrain")
        addChild(terrain)
    }
    
    func addTents(){
        let tent = Tent()
        tent.setRotation(float3(0.0, 3.3833308, 0.0))
        tent.setPosition(float3(-1,-0.01,0))
        addChild(tent)
        
        let tentWithPoles = TentWithPoles()
        tentWithPoles.setRotation(float3(0.0, 3.0, 0.0))
        tentWithPoles.setPosition(float3(3,0,0))
        addChild(tentWithPoles)
    }
    
    let lanternRed = Lantern(.Red)
    func addLights(){
        lanternRed.setRotation(float3(0.0, 3.3833308, 0.0))
        lanternRed.attenuation = float3(6.3999963, -3.0099976, 0.40499836)
        lanternRed.color = float3(1,0,0)
        lanternRed.brightness = 2
        lanternRed.moveZ(-4)
        lanternRed.moveX(4)
        addChild(lanternRed)
        
        let lanternGreen = Lantern(.Green)
        lanternGreen.setRotation(float3(0.0, 3, 0.0))
        lanternGreen.attenuation = float3(6.3999963, -3.0099976, 0.40499836)
        lanternGreen.color = float3(0,1,0)
        lanternGreen.brightness = 1
        lanternGreen.moveZ(-4)
        lanternGreen.moveX(-4)
        addChild(lanternGreen)
        
        let campfire = Campfire()
        campfire.moveZ(4)
        addChild(campfire)
    }
    
    func addTrees(){
        for _ in -50..<50{
            let tree = LargeGreenOak()
            let posZ: Float = Float.random(min: -15, max: -4)
            let posX: Float = Float.random(min: -15, max: 12)
            tree.setPosition(float3(posX,0,posZ))
            addChild(tree)
        }
    }
    
    let animatedModel = Cowboy()
    func addAnimatedModel(){
        animatedModel.setPosition(float3(-14.020157, 4.9133453, 17.379887))
        addChild(animatedModel)
    }
    
    override func update(deltaTime: Float) {
        if(Keyboard.IsKeyPressed(.w)){
            animatedModel.moveZ(-deltaTime)
        }
        if(Keyboard.IsKeyPressed(.s)){
            animatedModel.moveZ(deltaTime)
        }
        if(Keyboard.IsKeyPressed(.a)){
            animatedModel.moveX(-deltaTime)
        }
        if(Keyboard.IsKeyPressed(.d)){
            animatedModel.moveX(deltaTime)
        }
        if(Keyboard.IsKeyPressed(.q)){
            animatedModel.moveY(deltaTime)
        }
        if(Keyboard.IsKeyPressed(.z)){
            animatedModel.moveY(-deltaTime)
        }
        super.update(deltaTime: deltaTime)
    }

}
