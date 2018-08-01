
import MetalKit

class LampObject: GameObject {
    
    var light = Light()
    var lightName: String!
    var showObject: Bool = false
    
    var brightness: Float = 1
    
    override init() {
        super.init(meshType: .Cube_Custom)
        self.scale = float3(0.1)
        lightName = LightManager.AddLightAndGetName()
    }
    
    override func update(deltaTime: Float) {
        LightManager.GetLight(lightName).position = self.position
        LightManager.GetLight(lightName).brightness = self.brightness
        
        super.update(deltaTime: deltaTime)
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder, lights: inout [LightData]) {
        if(showObject){
            super.render(renderCommandEncoder: renderCommandEncoder, lights: &lights)
        }
    }
    
    
    
}
