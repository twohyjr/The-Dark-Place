
import MetalKit

class Tent: ModelGameObject {
    
    init() {
        super.init(.Tent)
        self.setContrastDelta(0.3)
    }

}

class TentWithPoles: ModelGameObject {
    
    init() {
        super.init(.TentWithPoles)
        self.setContrastDelta(0.3)
    }
    
}
