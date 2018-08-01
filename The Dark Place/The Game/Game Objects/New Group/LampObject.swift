
import MetalKit

class LampObject: GameObject {
    
    var light = Light()
    var lightName: String!
    
    override init() {
        super.init(meshType: .Cube_Custom)
        self.scale = float3(0.1)
        lightName = LightManager.AddLightAndGetName()
    }
    
    override func update(deltaTime: Float) {
        LightManager.GetLight(lightName).position = self.position
        
        super.update(deltaTime: deltaTime)
    }
    
}
