import MetalKit

class GameView: MTKView {
    
    var renderer: Renderer!
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        
        Engine.Initialize(device!)
        
        self.renderer = Renderer()
        
        self.delegate = renderer
    }
    
}
