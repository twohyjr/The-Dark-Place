
import MetalKit

class QuadPyramid: GameObject {
    
    override init() {
        super.init(meshType: .QuadPyramid_Custom)
        self.color = float3(0.1,0.3,0.4)
    }
    
}
