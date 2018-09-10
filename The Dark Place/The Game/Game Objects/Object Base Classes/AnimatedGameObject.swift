import MetalKit

class AnimatedGameObject: Node {
    
    private var mesh: RiggedModelMesh!

    var modelConstants = ModelConstants()
    internal var material = Material()
    
    private var _color: float4 = float4(1)
    public func setColor(_ value: float4){
        self._color = value
    }
    public func getColor()->float4{
        return self._color
    }
    
    private var _ambient = float3(1.0)
    public func getAmbient()->float3 {
        return _ambient
    }
    public func setAmbient(_ value: float3){
        self._ambient = value
    }
    
    private var _diffuse = float3(0.2)
    public func getDiffuse()->float3 {
        return _diffuse
    }
    public func setDiffuse(_ value: float3){
        self._diffuse = value
    }
    
    private var _shininess: Float = 0.1
    public func getShininess()->Float {
        return _shininess
    }
    public func setShininess(_ value: Float){
        self._shininess = value
    }
    
    private var _specular = float3(0.1)
    public func getSpecular()->float3{
        return _specular
    }
    public func setSpecular(_ value: float3){
        self._specular = value
    }
    
    private var fillMode: MTLTriangleFillMode = .fill
    
    init(_ riggedMeshType: RiggedMeshTypes){
        super.init()
        
        self.mesh = RiggedMeshLibrary.Mesh(riggedMeshType)
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
    }
    
}

extension AnimatedGameObject: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder, lights: inout [LightData]) {
        renderCommandEncoder.pushDebugGroup("Animated Game Object Render Call")
        
        renderCommandEncoder.setTriangleFillMode(fillMode)
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Rigged))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Basic))
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
