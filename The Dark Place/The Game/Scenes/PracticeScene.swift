import MetalKit

class PracticeScene: Scene {
    
    var gridSize: Int = 15
    var terrain: Terrain!
    var sun = Cube()
    override func buildScene() {
        setCameras()
        
        addSun()
        
        addTerrain()

        addTrees()
    }
    
    private func setCameras(){
        let debugCamera = Debug_Camera()
        debugCamera.position = float3(-1.4901161e-08, 10.499996, 16.08331)
        debugCamera.pitch = 0.5
        addCamera(camera: debugCamera)
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
