import MetalKit

class GameObject: Node {
    var mesh: CustomMesh!
    var modelConstants = ModelConstants()
    var material = Material()

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

//Material Getters / Setters
extension GameObject {
    func setColor(_ colorValue: float4){ self.material.color = colorValue }
    func getColor()->float4{ return self.material.color }
    
    func setAmbient(_ ambientValue: float3){ self.material.ambient = ambientValue }
    func getAmbient()->float3 { return self.material.ambient }
    
    func setDiffuse(_ diffuseValue: float3){ self.material.diffuse = diffuseValue }
    func getDiffuse()->float3 { return self.material.diffuse }

    func setShininess(_ shininessValue: Float){  self.material.shininess = shininessValue }
    func getShininess()->Float { return self.material.shininess }

    func setSpecular(_ specularValue: float3){ self.material.specular = specularValue }
    func getSpecular()->float3{ return self.material.specular }
}
