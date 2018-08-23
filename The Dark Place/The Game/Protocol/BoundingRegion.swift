import MetalKit

protocol BoundingRegion {
    
    func update()
    
}

extension BoundingRegion {
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder){
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.BoundingRegion))
        renderCommandEncoder.setTriangleFillMode(.lines)
    }
    
}

