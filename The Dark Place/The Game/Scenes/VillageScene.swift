import MetalKit

class VillageScene: Scene {
    
    var gridSize: Int = 25
    var terrain: Terrain!
    
    override func buildScene() {
        setCameras()
        
        addTerrain()
        
        addTents()
        
        addCampfire()
        
        addMushrooms()
        
        addTrees()
    }
    
    private func setCameras(){
        let debugCamera = Debug_Camera()
        debugCamera.position = float3(-0.25000003, 6.0833354, 12.749988)
        addCamera(camera: debugCamera)
    }
    
    private func addTerrain(){
        terrain = Terrain(gridSize: gridSize, cellsWide: 10, cellsBack: 10, textureType: .CartoonGrass)
        addChild(terrain)
    }

    private func addTents(){
        let tent = Tent()
        tent.rotation = float3(0.0, 3.3833308, 0.0)
        tent.position.x = -1
        addChild(tent)
        
        let tentWithPoles = TentWithPoles()
        tentWithPoles.rotation = float3(0.0, 3.0, 0.0)
        tentWithPoles.position.x = -1
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
        let tree1 = LargeGreenOak()
        tree1.scale.y = 2
        tree1.position.z = -5
        tree1.position.x = -2
        addChild(tree1)
    }

}
