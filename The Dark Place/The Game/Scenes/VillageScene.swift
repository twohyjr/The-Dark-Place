import MetalKit

class VillageScene: Scene {
    
    var gridSize: Int = 25
    var terrain: Terrain!
    
    override func buildScene() {
        setCameras()
        
        addTerrain()
        
        addCubes()
    }
    
    private func setCameras(){
        let debugCamera = Debug_Camera()
        addCamera(camera: debugCamera)
    }
    
    private func addTerrain(){
        terrain = Terrain(gridSize: gridSize, cellsWide: 50, cellsBack: 50)
        addChild(terrain)
    }
    
    //Temp function
    private func addCubes(){
        let cube1 = Cube()
        cube1.position.x -= 3
        addChild(cube1)
        
        let cube2 = Cube()
        addChild(cube2)
        
        let cube3 = Cube()
        cube3.position.x += 3
        addChild(cube3)
        
        
        
    
    }

    
}
