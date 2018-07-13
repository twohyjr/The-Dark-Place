import MetalKit

class Renderer: NSObject {
    
    init(_ view: MTKView) {
       View.setScreenSize(view.bounds.size)
    }
    
}

extension Renderer: MTKViewDelegate {
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        View.setScreenSize(size)
    }
    
    func draw(in view: MTKView) {
        GameManager.Tick(view: view)
    }
    
}
