import MetalKit

class GameObject: Node {
    var mesh: CustomMesh!
    var modelConstants = ModelConstants()
    
    internal var material = Material()
    var color: float3 = float3(1)
    var specularity: float3 = float3(0.1)
    var shininess: Float = 0.5
    
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
        material.diffuse = color
        material.specular = specularity
        material.shininess = shininess
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
