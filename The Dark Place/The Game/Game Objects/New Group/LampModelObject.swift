
import MetalKit

class LampModelObject: ModelGameObject {
    
    var light = Light()
    var lightName: String!
    var showObject: Bool = true
    
    var brightness: Float = 1
    var attenuation = float3(1,0,0)
    var color = float3(1)
    var lightPosition = float3(0)
    
    
    override init(_ meshType: ModelMeshTypes, name: String = String.Empty) {
        super.init(meshType)
        self.name = name
        lightName = LightManager.AddLightAndGetName()
        
    }
    
    override func update(deltaTime: Float) {
        
        LightManager.GetLight(lightName).setPosition(self.getPosition() + light.getPosition())
        LightManager.GetLight(lightName).setBrightness(self.brightness)
        LightManager.GetLight(lightName).setAttenuation(self.attenuation)
        LightManager.GetLight(lightName).setColor(self.color)
        if(Keyboard.IsKeyPressed(.downArrow)){
            self.moveZ(deltaTime)
        }
        super.update(deltaTime: deltaTime)
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        if(showObject){
            super.render(renderCommandEncoder: renderCommandEncoder)
        }
    }
}

extension LampModelObject: Lightable { }

