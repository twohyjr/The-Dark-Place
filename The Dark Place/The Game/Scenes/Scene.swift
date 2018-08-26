import MetalKit

class LightCollection {
    
}

class Scene: Node {
    
    var sceneConstants = SceneConstants()
    private var cameraManager = CameraManager()

    private var lightDatas: [LightData] {
        get{ return LightManager.LightData }
        set{ }  // Do nothing here.  Need to be able to pass a non read only property to the render command encoder
    }
    var fog = Fog()

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
    
    func updateLights(deltaTime: Float){
        LightManager.UpdateLights(deltaTime: deltaTime)
    }
    
    func setSceneConstants(){
        sceneConstants.viewMatrix = cameraManager.CurrentCamera.viewMatrix
        sceneConstants.projectionMatrix = cameraManager.CurrentCamera.projectionMatrix
        sceneConstants.inverseViewMatrix = cameraManager.CurrentCamera.viewMatrix.inverse
        sceneConstants.eyePosition = cameraManager.CurrentCamera.position
        sceneConstants.fog.density = fog.density
        sceneConstants.fog.gradient = fog.gradient
    }
    
    func addWorldItems(_ worldItemsGenerator: WorldItemsGenerator){
        let worldItemData = worldItemsGenerator.generateWorldItemData()
        for item in worldItemData.worldItems {
            addChild(item)
        }
    }
    
    override func update(deltaTime: Float) {
        setSceneConstants()
        
        super.update(deltaTime: deltaTime)
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.pushDebugGroup("Scene Render Call")
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: SceneConstants.stride, index: 1)
        renderCommandEncoder.setFragmentBytes(lightDatas, length: LightData.stride(lightDatas.count), index: 2)
        super.render(renderCommandEncoder: renderCommandEncoder, lights: &lightDatas)
        renderCommandEncoder.popDebugGroup()
    }
    
}
