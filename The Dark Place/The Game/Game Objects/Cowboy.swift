
import MetalKit

class Cowboy: AnimatedGameObject {
    
    init() {
        super.init(riggedMeshType: .Cowboy, textureType: .Cowboy, name: "Cowboy")
        self.setScale(0.7)
    }
    
    override func update(deltaTime: Float) {
        self.rotateY(deltaTime)
        super.update(deltaTime: deltaTime)
    }
}
