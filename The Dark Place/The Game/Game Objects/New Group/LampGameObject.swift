
import MetalKit

class LampGameObject: GameObject {
    
    var light = Light(lightName: "")
    var lightName: String!
    private var showObject: Bool = true
    
    var brightness: Float = 1
    private var _attenuation = float3(1,0,0)
    
    init(_ meshType: CustomMeshTypes, name: String = String.Empty) {
        super.init(meshType: meshType)
        self.name = name
        self.setScale(float3(0.1))
        self.material.isLit = false
        lightName = LightManager.AddLightAndGetName()
    }
    
    override init() {
        super.init(meshType: .Cube_Custom)
        self.setScale(float3(0.1))
        self.material.isLit = false
        self.showObject = false
        lightName = LightManager.AddLightAndGetName()
    }
    
    func setAttenuation(_ attenuation: Float){
        self._attenuation = float3(attenuation)
    }
    
    func setAttenuation(_ attenuation: float3){
        self._attenuation = attenuation
    }
    
    func getAttenuation()->float3{
        return _attenuation
    }
    
    func hideGameModel(){
        self.showObject = false
    }
    
    func showGameModel(){
        self.showObject = true
    }
    
    override func update(deltaTime: Float) {
        self.setAttenuation(float3(DebugSettings.value1, DebugSettings.value2, DebugSettings.value3))
        LightManager.GetLight(lightName).setPosition(self.getPosition() + light.getPosition())
        LightManager.GetLight(lightName).setBrightness(self.brightness)
        LightManager.GetLight(lightName).setColor(self.getColor().xyz)
        LightManager.GetLight(lightName).setAttenuation(self.getAttenuation())
        self.material.color = self.getColor()
        
        super.update(deltaTime: deltaTime)
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        if(showObject){
            super.render(renderCommandEncoder: renderCommandEncoder)
        }
    }
}

extension LampGameObject: Lightable { }
