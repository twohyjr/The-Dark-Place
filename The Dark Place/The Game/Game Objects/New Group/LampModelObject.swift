
import MetalKit

class LampModelObject: ModelGameObject {
    
    var light = Light()
    var lightName: String!
    var showObject: Bool = true
    
    var brightness: Float = 1
    var attenuation = float3(1,0,0)
    var color = float3(1)
    var lightPosition = float3(0)
    
    
    override init(_ meshType: ModelMeshTypes) {
        super.init(meshType)
        lightName = LightManager.AddLightAndGetName()
        
    }
    
    override func update(deltaTime: Float) {
        
        LightManager.GetLight(lightName).setPosition(self.getPosition() + light.getPosition())
        LightManager.GetLight(lightName).setBrightness(self.brightness)
        LightManager.GetLight(lightName).setAttenuation(self.attenuation)
        LightManager.GetLight(lightName).setColor(self.color)
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

extension LampModelObject: Lightable { }

