import MetalKit

class PracticeScene: Scene {
    
    override func buildScene() {
        addCameras()
        
        addLights()
        
        addObjects()
        
        setFog()
    }
    
    let debugCamera = DebugCamera()
    func addCameras(){
        debugCamera.setPosition(float3(0, 5, 10))
        debugCamera.setPitch(0.23)
        addCamera(camera: debugCamera)
    }
    
    let cubeRed = Cube()
    let lightRed = Light()
    let cubeGreen = Cube()
    let lightGreen = Light()
    func addLights(){
        lightRed.setPosition(float3(1.5,3,0))
        lightRed.setColor(float3(1,0,0))
        cubeRed.setScale(0.2)
        cubeRed.setColor(float4(1,0,0,1))
        addChild(cubeRed)
        
        lightGreen.setPosition(float3(-1.5,3,0))
        lightGreen.setColor(float3(0,1,0))
        cubeGreen.setScale(0.2)
        cubeGreen.setColor(float4(0,1,0,1))
        addChild(cubeGreen)
        
//        let whiteLight = Light()
//        whiteLight.setBrightness(0.6)
//        whiteLight.setPosition(float3(0,100,400))
    }
    
    var terrain: Terrain!
    func addObjects(){
        let terrainData = TerrainData(width: 200, depth: 200)
        terrain = Terrain(gridSize: 1000, terrainData: terrainData, textureType: TextureTypes.CartoonGrass, name: "Main Terrain")
        addChild(terrain)
        
        let animatedModel = Cowboy()
        addChild(animatedModel)
    }
    
    func setFog(){
        fog.density = 0.019000001
        fog.gradient = 2.0999603
    }
    
    override func update(deltaTime: Float) {
        cubeRed.setPosition(lightRed.getPosition())
        cubeGreen.setPosition(lightGreen.getPosition())
        
        DebugSettings.nameValue1 = "Att X"
        DebugSettings.nameValue2 = "Att Y"
        DebugSettings.nameValue3 = "Att Z"
        lightRed.setAttenuation(float3(DebugSettings.value1, DebugSettings.value2, DebugSettings.value3))
        lightGreen.setAttenuation(float3(DebugSettings.value1, DebugSettings.value2, DebugSettings.value3))
        
        DebugSettings.nameValue4 = "Mat Shin"
        DebugSettings.nameValue5 = "Mat Spec"
        terrain.setShininess(DebugSettings.value4)
        terrain.setSpecular(float3(DebugSettings.value5))

        super.update(deltaTime: deltaTime)
    }
    
}
