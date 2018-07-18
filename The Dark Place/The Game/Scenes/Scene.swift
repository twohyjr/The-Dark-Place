import MetalKit

class Scene: Node {
    
    var sceneConstants = SceneConstants()
    var lights: [Light] = []
    private var cameraManager = CameraManager()

    override init(){
        super.init()
        setupCameras()
        buildScene()
        var light = Light()
        light.position = float3(1,0,0)
        lights.append(light)
    }
    
    func buildScene() { }
    
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
    }
    
    override func update(deltaTime: Float) {
        setSceneConstants()
        super.update(deltaTime: deltaTime)
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: SceneConstants.stride, index: 1)
        renderCommandEncoder.setFragmentBytes(lights, length: Light.stride(lights.count), index: 2)
        super.render(renderCommandEncoder: renderCommandEncoder)
    }
    
}
