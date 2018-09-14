import MetalKit

class LightCollection {
    
}

class Scene: Node {
    
    var sceneConstants = SceneConstants()
    var cameraManager = CameraManager()
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
        cameraManager.registerCamera(camera)
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
        if let camera = cameraManager.CurrentCamera {
            sceneConstants.viewMatrix = camera.viewMatrix
            sceneConstants.projectionMatrix = camera.projectionMatrix
            sceneConstants.inverseViewMatrix = camera.viewMatrix.inverse
            sceneConstants.eyePosition = camera.getPosition()
        }
        
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
        generateDefaultItemsIfNessesary()
        
        setSceneConstants()
        
        super.update(deltaTime: deltaTime)
    }
    
    private func generateDefaultItemsIfNessesary(){
        if(lightDatas.count == 0){
            let light = LampGameObject()
            addChild(light)
        }
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.pushDebugGroup("Scene Render")
        
        renderCommandEncoder.setVertexBytes(&sceneConstants, length: SceneConstants.stride, index: 1)
        renderCommandEncoder.setFragmentBytes(lightDatas, length: LightData.stride(lightDatas.count), index: 2)
        
        var lightCount = lightDatas.count
        renderCommandEncoder.setFragmentBytes(&lightCount, length: Int.stride, index: 3)

        super.render(renderCommandEncoder: renderCommandEncoder)
        
        renderCommandEncoder.popDebugGroup()
    }
    
}
