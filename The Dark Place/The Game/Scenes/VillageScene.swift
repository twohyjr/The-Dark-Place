import MetalKit

class VillageScene: Scene {
    
    var gridSize: Int = 15
    var terrain: Terrain!
    var sun = Cube()
    override func buildScene() {
        setCameras()
        
        setLight()
        
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
    
    private func setLight(){
        light.position = float3(0,3,0)
        light.brightness = 1.8
    }
    
    private func addSun(){
        sun.scale = float3(0.5)
        sun.color = float3(0.4,0,1)
        addChild(sun)
    }
    
    private func addTerrain(){
        terrain = Terrain(gridSize: gridSize, cellsWide: 10, cellsBack: 10, textureType: .CartoonGrass)
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
        for i in -5..<5 {
            let redMushroom = RedMushroom()
            redMushroom.position.x = Float(i)
            redMushroom.position.z = 6
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
    
    var time: Float = 0
    override func update(deltaTime: Float) {
        time += deltaTime
//        light.position.y += cos(time) / 4
        sun.position = light.position
        super.update(deltaTime: deltaTime)
    }

}
