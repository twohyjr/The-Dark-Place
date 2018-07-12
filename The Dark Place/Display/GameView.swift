import MetalKit

class GameView: MTKView {
    
    var renderer: Renderer!
    required init(coder: NSCoder) {
        super.init(coder: coder)
        
        self.device = MTLCreateSystemDefaultDevice()
        
        self.renderer = Renderer(self)
        
        Engine.Initialize(device!)
        
        self.delegate = renderer
    }
    
}
