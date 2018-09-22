import MetalKit

class Light: Node {

    internal var lightData = LightData()

    private var _lightName: String = ""
    private var _color: float3!
    private var _brightness: Float!
    private var _attenuation: float3!
    private var _ambientIntensity: Float!
    
    public func getBrightness()->Float {return _brightness}
    public func setBrightness(_ value: Float){self._brightness = value}

    public func getColor()->float3 {return _color}
    public func setColor(_ value: float3){self._color = value}

    public func getAttenuation()->float3 {return _attenuation}
    public func setAttenuation(_ value: float3){self._attenuation = value}
    
    public func getAmbientIntensity()->Float {return _ambientIntensity}
    public func setAmbientIntensity(_ value: Float){self._ambientIntensity = value}
    
    init(lightName: String = ""){
        super.init()
        self._lightName = lightName
        self._color = lightData.color
        self._brightness = lightData.brightness
        self._attenuation = lightData.attenuation
        self._ambientIntensity = lightData.ambientIntensity
        self._lightName = String(randomBounded(lowerBound: 0, upperBound: 1000))
        LightManager.AddLight(lightName: _lightName, light: self)
    }
 
    public override func update(deltaTime: Float){
        if(Keyboard.IsKeyPressed(.w)){
            self.moveY(deltaTime)
        }
        
        if(Keyboard.IsKeyPressed(.s)){
            self.moveY(-deltaTime)
        }
        
        if(Keyboard.IsKeyPressed(.d)){
            self.moveX(deltaTime)
        }
        
        if(Keyboard.IsKeyPressed(.a)){
            self.moveX(-deltaTime)
        }
        
        
        lightData.position = getPosition()
        lightData.brightness = _brightness
        lightData.color = _color
        lightData.attenuation = _attenuation
        lightData.ambientIntensity = _ambientIntensity
        super.update(deltaTime: deltaTime)
    }
}

