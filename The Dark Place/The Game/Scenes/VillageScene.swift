import MetalKit

class VillageScene: Scene {
    
    override func buildScene() {
        addCameras()
        
        setFog()
        
        addTerrain()
        
        addTents()
        
        addTrees()
        
        addLights()
    }
    
    let debugCamera = DebugCamera()
    func addCameras(){
        debugCamera.setPosition(float3(-1.4901161e-08, 10.499996, 25.08331))
        debugCamera.setPitch(0.3)
        addCamera(camera: debugCamera)
    }
    
    func setFog(){
        fog.density = 0.019000001
        fog.gradient = 2.0999603
    }
    
    func addTerrain(){
        let terrainData = TerrainData(width: 40, depth: 40)
        let terrain = Terrain(gridSize: 100, terrainData: terrainData, textureType: TextureTypes.CartoonSand)
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
    
    func addLights(){
        let lantern = Lantern(.Red)
        lantern.setRotation(float3(0.0, 3.3833308, 0.0))
        lantern.attenuation = float3(6.3999963, -3.0099976, 0.40499836)
        lantern.color = float3(1,0,0)
        lantern.brightness = 2
        lantern.moveZ(-4)
        lantern.moveX(4)
        addChild(lantern)
        
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
}
