import MetalKit

class GameObject: Node {
    
    var modelConstants = ModelConstants()
    var renderPipelineState: MTLRenderPipelineState!
    var mesh: MyMesh!
    var useLines: Bool = false
    
    init(meshType: MeshTypes) {
        super.init()
        mesh = MeshLibrary.Mesh(meshType)
        
        setRenderPipelineState()
    }
    
    override init(){
        super.init()
        setRenderPipelineState()
    }
    
    override func update(deltaTime: Float){
        updateModelConstants()
        super.update(deltaTime: deltaTime)
    }
    
    private func updateModelConstants(){
        modelConstants.modelMatrix = self.modelMatrix
    }
    
    internal func setRenderPipelineState(){
        renderPipelineState = RenderPipelineStateLibrary.PipelineState(.Basic)
    }
    
}

extension GameObject: Renderable{
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Basic))
        
        renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        
        mesh.drawPrimitives(renderCommandEncoder: renderCommandEncoder, lineMode: useLines)
    }
}
