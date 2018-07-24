import MetalKit

class Scene: Node {
    
    var sceneConstants = SceneConstants()
    private var cameraManager = CameraManager()
    var lights: [Light] = []

    override init(){
        super.init()
        setupCameras()
        buildScene()
    }
    
    func buildScene() { }
    
    //Camera Stuff
    func setupCameras() { }
    func addCamera(camera: Camera, setAsCurrent: Bool = true){
        cameraManager.registerCamera(camera: camera)
        if(setAsCurrent){
            cameraManager.setCamera(camera.cameraType)
        }
    }
    func updateCameras(deltaTime: Float){
        cameraManager.updateCameras(deltaTime: deltaTime)
    }
    
    func setSceneConstants(){
        sceneConstants.viewMatrix = cameraManager.CurrentCamera.viewMatrix
        sceneConstants.projectionMatrix = cameraManager.CurrentCamera.projectionMatrix
        sceneConstants.inverseViewMatrix = cameraManager.CurrentCamera.viewMatrix.inverse
        sceneConstants.eyePosition = cameraManager.CurrentCamera.position
    }
    
    func addLight(_ light: Light){
        lights.append(light)
    }
    
    override func update(deltaTime: Float) {
        if(lights.count == 0){
            addLight(Light())
        }
        
        setSceneConstants()
        
        super.update(deltaTime: deltaTime)
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        var lightCount: Int = lights.count
        renderCommandEncoder.setTriangleFillMode(.lines)
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: SceneConstants.stride, index: 1)
        renderCommandEncoder.setFragmentBytes(lights, length: Light.stride(lights.count), index: 2)
        renderCommandEncoder.setFragmentBytes(&lightCount, length: Int.stride, index: 3)
        super.render(renderCommandEncoder: renderCommandEncoder)
    }
    
}
