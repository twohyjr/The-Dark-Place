import MetalKit

class Scene: Node {
    
    var sceneConstants = SceneConstants()
    private var cameraManager = CameraManager()
    var light = Light()

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
    
    override func update(deltaTime: Float) {
        setSceneConstants()
        
        super.update(deltaTime: deltaTime)
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setTriangleFillMode(.lines)
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: SceneConstants.stride, index: 1)
        renderCommandEncoder.setFragmentBytes(&light, length: Light.stride, index: 2)
        super.render(renderCommandEncoder: renderCommandEncoder)
    }
    
}
