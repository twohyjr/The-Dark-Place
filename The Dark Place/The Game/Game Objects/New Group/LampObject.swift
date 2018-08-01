
import MetalKit

class LampObject: GameObject {
    
    var light = Light()
    var lightName: String!
    var showObject: Bool = true
    
    var brightness: Float = 1
    
    override init() {
        super.init(meshType: .Cube_Custom)
        self.scale = float3(0.1)
        lightName = LightManager.AddLightAndGetName()
    }
    
    override func update(deltaTime: Float) {
        LightManager.GetLight(lightName).position = self.position
        LightManager.GetLight(lightName).brightness = self.brightness
        LightManager.GetLight(lightName).color = self.color
        
        super.update(deltaTime: deltaTime)
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder, lights: inout [LightData]) {
        if(showObject){
            renderCommandEncoder.pushDebugGroup("Light Render Call")

            super.render(renderCommandEncoder: renderCommandEncoder, lights: &lights)
            
            renderCommandEncoder.popDebugGroup()
        }
    }
}

extension LampObject: Lightable { }