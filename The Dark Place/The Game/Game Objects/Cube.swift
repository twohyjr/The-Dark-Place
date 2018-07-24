
import MetalKit

class Cube: GameObject {
    
    override init() {
        super.init(meshType: .Cube_Custom)
        self.material.diffuse = float3(0.5)
    }

}
