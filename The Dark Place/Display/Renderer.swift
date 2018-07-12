import MetalKit

class Renderer: NSObject {
    
    
    init(_ view: MTKView) {
       View.setScreenSize(view.bounds.size)
    }
    
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        View.setScreenSize(size)
        RenderPassDescriptorLibrary.UpdateViewSize(View.ScreenSize)
    }
    
    func draw(in view: MTKView) {
        guard
            let drawable = view.currentDrawable
        else { return }
        
        let commandBuffer = Engine.CommandQueue.makeCommandBuffer()
        let mainRenderPassDescriptor = RenderPassDescriptorLibrary.RenderPassDescriptor(.Main)
        let renderCommandEncoder = commandBuffer?.makeRenderCommandEncoder(descriptor: mainRenderPassDescriptor)
        
        renderCommandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
    }
    
}
