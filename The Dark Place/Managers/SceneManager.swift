import MetalKit

enum SceneTypes{
    case VillageScene
}

class SceneManager{
    
    private static var _currentScene: Scene!
    public static var CurrentScene: Scene {
        return _currentScene
    }
    
    public static func Initialize(_ sceneType: SceneTypes){
        SetScene(sceneType)
    }
    
    public static func SetScene(_ sceneType: SceneTypes){
        switch sceneType {
        case .VillageScene:
            _currentScene = VillageScene()
        }
    }
    
    private static func updateScene(deltaTime: Float){
        _currentScene.update(deltaTime: deltaTime)
    }
    
    private static func renderScene(renderCommandEncoder: MTLRenderCommandEncoder){
        _currentScene.render(renderCommandEncoder: renderCommandEncoder)
    }
    
    public static func TickScene(renderCommandEncoder: MTLRenderCommandEncoder, deltaTime: Float){
        updateScene(deltaTime: deltaTime)
        
        renderScene(renderCommandEncoder: renderCommandEncoder)
    }
    
    
}
