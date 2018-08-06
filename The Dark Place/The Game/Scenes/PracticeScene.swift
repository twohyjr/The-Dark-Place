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
        let itemGenerator = WorldItemsGenerator()
            .withItemPlacementMap("VillageSceneItemMap")
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
        light.brightness = 2.0
        addChild(light)
    }

}
