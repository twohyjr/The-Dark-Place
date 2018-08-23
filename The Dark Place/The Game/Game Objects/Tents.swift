
import MetalKit

class Tent: ModelGameObject {
    
    init() {
        super.init(.Tent)
    }

}

class TentWithPoles: ModelGameObject {
    
    init() {
        super.init(.TentWithPoles)
        addBoundingRegion(BoundingBoxObject())
    }
    
}
