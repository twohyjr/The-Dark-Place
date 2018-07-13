import MetalKit

class Node {
    
    var children: [Node] = []
    
    public func addChild(_ child: Node){
        children.append(child)
    }
    
    public func update(_ deltaTime: Float){
        for child in children{
            child.update(deltaTime)
        }
    }
    
    public func render(renderCommandEncoder: MTLRenderCommandEncoder){
        for child in children {
            child.render(renderCommandEncoder: renderCommandEncoder)
        }
        
        if let renderable = self as? Renderable {
            renderable.doRender(renderCommandEncoder)
        }
    }
    
    
}
