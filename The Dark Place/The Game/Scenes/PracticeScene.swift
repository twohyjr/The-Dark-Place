import MetalKit

class PracticeScene: Scene {
    
    var lastPos = float3(100,0,0)
    
    override func buildScene() {
        addCameras()
        
        addLights()
        
        addObjects()
        
        setFog()
    }
    
    let debugCamera = DebugCamera()
    func addCameras(){
        debugCamera.setPosition(float3(0, 5, 11.5))
        debugCamera.setPitch(0.17)
        addCamera(camera: debugCamera)
    }
    
    let cubeRed = Cube()
    let lightRed = Light()
    let cubeGreen = Cube()
    let lightGreen = Light()
    let whiteLight = Light()
    func addLights(){
        lightRed.setPosition(float3(1.5,5,0))
        lightRed.setColor(float3(1,0,0))
        lightRed.setBrightness(1.5)
        lightRed.setAttenuation(float3(0,0.532,0))
        cubeRed.setScale(0.2)
        cubeRed.setColor(float4(1,0,0,1))
        addChild(cubeRed)
        
        lightGreen.setPosition(float3(-1.5,5,0))
        lightGreen.setColor(float3(0,1,0))
        lightGreen.setAttenuation(float3(0,0.532,0))
        cubeGreen.setScale(0.2)
        cubeGreen.setColor(float4(0,1,0,1))
        addChild(cubeGreen)
        
        
        whiteLight.setBrightness(0.4)
        whiteLight.setPosition(float3(0,100,400))
    }
    
    var terrain: Terrain!
    let animatedModel = Cowboy()
    func addObjects(){
        let terrainData = TerrainData(width: 200, depth: 200)
        terrain = Terrain(gridSize: 1000, terrainData: terrainData, textureType: TextureTypes.CartoonGrass, name: "Main Terrain")
        addChild(terrain)
        
       
        addChild(animatedModel)
    }
    
    func setFog(){
        fog.density = 0.019000001
        fog.gradient = 2.0999603
    }
    
    var time: Float = 0
    override func update(deltaTime: Float) {
        time += deltaTime
        
        cubeRed.setPosition(lightRed.getPosition())
        cubeGreen.setPosition(lightGreen.getPosition())

        super.update(deltaTime: deltaTime)
    }
    
}
