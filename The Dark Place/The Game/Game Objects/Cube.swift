
import MetalKit

class Cube: GameObject {
    
    override init() {
        super.init(meshType: .Cube_Custom)
    }
    
    override func update(deltaTime: Float) {
        print(self.mesh.boundingBox.mins.x)
        super.update(deltaTime: deltaTime)
    }
    
}
