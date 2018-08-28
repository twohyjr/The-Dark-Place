import MetalKit

class GameObject: Node {
    var mesh: CustomMesh!
    var modelConstants = ModelConstants()
    internal var material = Material()
    
    private var _color: float4 = float4(1)
    func setColor(_ value: float4){
        self._color = value
    }
    func getColor()->float4{
        return self._color
    }
    
    private var _ambient = float3(1.0)
    var getAmbient: float3 {
        return _ambient
    }
    func setAmbient(_ value: float3){
        self._ambient = value
    }
    
    private var _diffuse = float3(0.2)
    var getDiffuse: float3 {
        return _diffuse
    }
    func setDiffuse(_ value: float3){
        self._diffuse = value
    }
    
    private var _shininess: Float = 0.1
    var getShininess: Float {
        return _shininess
    }
    func setShininess(_ value: Float){
        self._shininess = value
    }
    
    private var _specular = float3(0.1)
    var getSpecular: float3 {
        return _specular
    }
    func setSpecular(_ value: float3){
        self._specular = value
    }
    
    private var _contrastDelta = float3(0)
    var getContrastDelta: float3 {
        return _contrastDelta
    }
    func setContrastDelta(_ value: float3){
        self._contrastDelta = value
    }
    func setContrastDelta(_ value: Float){
        self._contrastDelta = float3(value)
    }
    
    private var fillMode: MTLTriangleFillMode = .fill
    
    init(meshType: CustomMeshTypes) {
        super.init()
        mesh = MeshLibrary.Mesh(meshType)
    }
    
    override init(){
        super.init()
    }
    
    public func lineModeOn(_ isOn: Bool){
        self.fillMode = isOn ? MTLTriangleFillMode.lines : MTLTriangleFillMode.fill
    }
    
    override func update(deltaTime: Float){
        updateModelConstants()
        super.update(deltaTime: deltaTime)
    }
    
    private func updateModelConstants(){
        modelConstants.modelMatrix = self.modelMatrix
        modelConstants.normalMatrix = self.modelMatrix.upperLeftMatrix
        material.color = _color
        material.diffuse = _diffuse
        material.ambient = _ambient
        material.specular = _specular
        material.shininess = _shininess
        material.contrastDelta = _contrastDelta
    }
}

extension GameObject: Renderable{
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder, lights: inout [LightData]) {
        renderCommandEncoder.pushDebugGroup("Game Object Render Call")
        
        renderCommandEncoder.setTriangleFillMode(fillMode)
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Basic))
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)
        
        renderCommandEncoder.setFragmentBytes(&material, length: Material.stride, index: 1)
        renderCommandEncoder.setFragmentBytes(lights,
                                              length: LightData.stride(lights.count),
                                              index: 2)
        var lightCount = lights.count
        renderCommandEncoder.setFragmentBytes(&lightCount, length: Int.stride, index: 3)

        mesh.drawPrimitives(renderCommandEncoder: renderCommandEncoder)
        
        renderCommandEncoder.popDebugGroup()
    }
}
