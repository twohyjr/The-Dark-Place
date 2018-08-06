import MetalKit

class PracticeScene: Scene {
    
    var gridSize: Int = 15
    var terrain: Terrain!
    var sunBackLeft = LampGameObject()

    override func buildScene() {
        setCameras()
        
        addTerrain()
        
        addLights()
    }
    
    private func setCameras(){
        let debugCamera = Debug_Camera()
        debugCamera.position = float3(-1.4901161e-08, 10.499996, 16.08331)
        debugCamera.pitch = 0.5
        addCamera(camera: debugCamera)
    }
    
    private func addLights(){
        sunBackLeft.position = float3(-1000, 300, 1000)
        sunBackLeft.brightness = 2
        addChild(sunBackLeft)
    }
    
    private func addTerrain(){
        let worldData = WorldGenerator.GetWorldData(itemMapName: "PracticeSceneItemMap", terrainHeightMap: "PracticeSceneHeightMap")
        for item in worldData.itemData.worldItems{
            addChild(item)
        }
        terrain = Terrain(gridSize: worldData.itemData.width, cellsWide: 100, cellsBack: 100, textureType: .CartoonGrass)
        terrain.diffuse = 1.5
        addChild(terrain)
    }
    
}
