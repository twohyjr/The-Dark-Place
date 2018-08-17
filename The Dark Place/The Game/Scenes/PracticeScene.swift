import MetalKit

class PracticeScene: Scene {
    
    var gridSize: Int = 15
    var light = LampGameObject()

    override func buildScene() {
        createScene()
        
        setCameras()
        
        addLights()
    }
    
    private func createScene(){

        let terrainGenerator = TerrainGenerator()
            .withHeightMap("PracticeSceneHeightMap")
            .withMaxTerrainHeight(5)
        
        let terrainData = terrainGenerator.generateTerrainData()
        let terrain = Terrain(gridSize: terrainData.width, terrainData: terrainData, textureType: .CartoonGrass)
        addChild(terrain)
        
        let itemGenerator = WorldItemsGenerator()
            .withItemPlacementMap("PracticeSceneItemMap")
            .withTerrainData(terrainData)
        
        addWorldItems(itemGenerator)
        
    }
    
    private func setCameras(){
        let debugCamera = Debug_Camera()
        debugCamera.position = float3(-1.4901161e-08, 10.499996, 16.08331)
        debugCamera.pitch = 0.5
        addCamera(camera: debugCamera)
    }
    
    private func addLights(){
        light.position = float3(0, 100, 200)
        addChild(light)
    }

}
