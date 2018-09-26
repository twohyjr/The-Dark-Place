import MetalKit

class Renderer: NSObject {
    
    public static var ClearColor: MTLClearColor {
        return MTLClearColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    }
    
    public static var SkyColor: float3 {
        return float3(Float(ClearColor.red),
                      Float(ClearColor.green),
                      Float(ClearColor.blue))
    }
    
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
