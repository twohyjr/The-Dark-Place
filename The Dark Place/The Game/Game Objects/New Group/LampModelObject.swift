
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
        LightManager.GetLight(lightName).position = self.getPosition() + lightPosition + float3(0.5,0,-0.5)
        LightManager.GetLight(lightName).brightness = self.brightness
        LightManager.GetLight(lightName).attenuation = self.attenuation
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

extension LampModelObject: Lightable { }

