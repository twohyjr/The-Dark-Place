import MetalKit

class GameObject: Node {
    
    var modelConstants = ModelConstants()
    var renderPipelineState: MTLRenderPipelineState!
    var mesh: CustomMesh!
    var material = Material()
    internal var fillMode: MTLTriangleFillMode = .fill
    
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
    }
}

extension GameObject: Renderable{
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        renderCommandEncoder.setTriangleFillMode(fillMode)
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Basic))
        renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)
        renderCommandEncoder.setFragmentBytes(&material, length: Material.stride, index: 1)
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        
        mesh.drawPrimitives(renderCommandEncoder: renderCommandEncoder)
    }
}
