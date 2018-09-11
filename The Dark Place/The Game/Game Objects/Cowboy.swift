
import MetalKit

class Cowboy: AnimatedGameObject {
    
    init() {
        super.init(riggedMeshType: .Cowboy, textureType: .Cowboy)
        self.rotateX(4.7)
        self.setScale(0.7)
    }
    
    override func update(deltaTime: Float) {
        self.rotateZ(deltaTime)
        super.update(deltaTime: deltaTime)
    }
}
