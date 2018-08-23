import MetalKit

class BoundingBoxObject: GameObject {
    
    override init(){
        super.init(meshType: .Cube_Custom)
    }
    
}

extension BoundingBoxObject: BoundingRegion {
    func update() {
        
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        
    }
}
