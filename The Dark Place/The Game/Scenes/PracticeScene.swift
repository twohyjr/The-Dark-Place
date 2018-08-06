import MetalKit

class PracticeScene: Scene {
    
    var gridSize: Int = 15
    var terrain: Terrain!
    var light = LampGameObject()

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
        light.position = float3(-1000, 0, 0)
        addChild(light)
    }
    
    private func addTerrain(){
        let worldData = WorldGenerator.GetWorldData(itemMapName: "PracticeSceneItemMap", terrainHeightMap: "PracticeSceneHeightMap", maxTerrainHeight: 10)
        
        let itemData = worldData.itemData
        let terrainData = worldData.terrainData
        
        for item in (itemData?.worldItems)!{
            addChild(item)
        }
        terrain = Terrain(gridSize: worldData.itemData.width,
                          terrainData: terrainData!,
                          textureType: .CartoonGrass)
        terrain.diffuse = 2
        addChild(terrain)
    }
    
}
