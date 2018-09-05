
import MetalKit

class Cowboy: AnimatedGameObject {
    
    init() {
        super.init(.Cowboy)
        self.setDiffuse(float3(1))
        self.setShininess(5)
        self.setSpecular(float3(7))
    }
    
    override func update(deltaTime: Float) {
        self.doRotationY(deltaTime)
      
        super.update(deltaTime: deltaTime)
    }
}
