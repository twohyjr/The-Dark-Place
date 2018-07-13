import MetalKit

class GameObject: Node {
    var renderPipelineState: MTLRenderPipelineState!
    var mesh: Mesh!
    
    init(meshType: MeshTypes) {
        super.init()
        mesh = MeshLibrary.Mesh(meshType)
        
        setRenderPipelineState()
    }
    
    override init(){
        super.init()
        setRenderPipelineState()
    }
    
    internal func setRenderPipelineState(){
        renderPipelineState = RenderPipelineStateLibrary.PipelineState(.Basic)
    }
    
}

extension GameObject: Renderable{
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        mesh.drawPrimitives(renderCommandEncoder: renderCommandEncoder)
    }
}
