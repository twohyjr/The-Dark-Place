import MetalKit

class VillageScene: Scene {
    
    var gridSize: Int = 15
    var terrain: Terrain!
    var sunBackLeft = LampObject(.Cube_Custom)
    var sunBackRight = LampObject(.Cube_Custom)
    var sunMiddleBack = LampObject(.Cube_Custom)
    override func buildScene() {
        setCameras()
        
        addSun()
        
        addTerrain()
        
        addTents()
        
        addCampfire()
        
        addMushrooms()
        
        addTrees()
    }
    
    private func setCameras(){
        let debugCamera = Debug_Camera()
        debugCamera.position = float3(-1.4901161e-08, 10.499996, 16.08331)
        debugCamera.pitch = 0.5
        addCamera(camera: debugCamera)
    }
    
    
    private func addSun(){
        sunBackLeft.position = float3(-1000, 500, 1000)
        sunBackLeft.brightness = 0.2
        addChild(sunBackLeft)
        
        sunBackRight.position = float3(1000, 500, 1000)
        sunBackRight.brightness = 0.2
        addChild(sunBackRight)
        
        sunMiddleBack.position = float3(0, 100, 1000)
        sunMiddleBack.brightness = 0.2
        addChild(sunMiddleBack)
        
        let redLight = LampObject(.Cube_Custom)
        redLight.position = float3(0,5,50)
        redLight.color = float3(1,0,0)
        addChild(redLight)
    }
    
    private func addTerrain(){
        terrain = Terrain(gridSize: gridSize, cellsWide: 10, cellsBack: 10, textureType: .CartoonGrass)
        terrain.diffuse = 1.5
        addChild(terrain)
    }

    private func addTents(){
        let tent = Tent()
        tent.rotation = float3(0.0, 3.3833308, 0.0)
        tent.position.x = -1
        tent.position.y = -0.01
        addChild(tent)
        
        let tentWithPoles = TentWithPoles()
        tentWithPoles.rotation = float3(0.0, 3.0, 0.0)
        tentWithPoles.position.x = 3
        
        addChild(tentWithPoles)
    }
    
    private func addCampfire(){
        let campfire = Campfire()
        campfire.position.x = 0
        campfire.position.z = 4
        addChild(campfire)
    }
    
    private func addMushrooms(){
        var mushroomCount: Int = 20
        var count: Int{
            return Int(mushroomCount / 2)
        }
        for _ in -count..<count {
            let redMushroom = RedMushroom()
            redMushroom.position.x = Float.random(min: Float(-gridSize / 2), max: Float(gridSize / 2))
            redMushroom.position.z = Float.random(min: Float(-gridSize / 2), max: Float(gridSize / 2))
            addChild(redMushroom)
        }
    }
    
    private func addTrees(){
        for i in -5..<5{
            let tree1 = LargeGreenOak()
            tree1.scale.y = 2
            tree1.position.z = (cos(Float(i * 3)) - 3) * 1.3
            tree1.position.x = (Float(i) - 0.5) * 1.5
            addChild(tree1)
        }
    }
}
