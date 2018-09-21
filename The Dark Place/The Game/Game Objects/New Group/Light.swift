import MetalKit

class Light: Node {

    internal var lightData = LightData()

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
    
    override init(){
        super.init()
        _color = lightData.color
        _brightness = lightData.brightness
        _attenuation = lightData.attenuation
        _ambientIntensity = lightData.ambientIntensity
    }
 
    public override func update(deltaTime: Float){
        lightData.position = getPosition()
        lightData.brightness = _brightness
        lightData.color = _color
        lightData.attenuation = _attenuation
        lightData.ambientIntensity = _ambientIntensity
    }
    
    
    
}

