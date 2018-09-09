
import MetalKit

class Cowboy: AnimatedGameObject {
    
    init() {
        super.init(.Cowboy)
        self.setDiffuse(float3(1))
        self.setShininess(5)
        self.setSpecular(float3(7))
        self.doRotationX(4.7)
        self.setScale(0.7)
    }
    
    override func update(deltaTime: Float) {
        self.doRotationZ(deltaTime)
        super.update(deltaTime: deltaTime)
    }
}
