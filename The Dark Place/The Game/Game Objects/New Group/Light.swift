import MetalKit

class Light {

    internal var lightData = LightData()
    
    private var _position = float3(0)
    public func getPosition()->float3 {
        return _position
    }
    public func setPosition(_ value: float3){
        self._position = value
    }
    public func moveX(_ value: Float){
        self._position.x += value
    }
    public func moveY(_ value: Float){
        self._position.y += value
    }
    public func moveZ(_ value: Float){
        self._position.z += value
    }
    
    private var _brightness: Float = 1
    public func getBrightness()->Float {
        return _brightness
    }
    public func setBrightness(_ value: Float){
        self._brightness = value
    }
    
    private var _color = float3(1)
    public func getColor()->float3 {
        return _color
    }
    public func setColor(_ value: float3){
        self._color = value
    }

    private var _attenuation = float3(0)
    public func getAttenuation()->float3 {
        return _attenuation
    }
    public func setAttenuation(_ value: float3){
        self._attenuation = value
    }
    public func setAttenuationX(_ value: Float){
        self._attenuation.x = value
    }
    public func setAttenuationY(_ value: Float){
        self._attenuation.y = value
    }
    public func setAttenuationZ(_ value: Float){
        self._attenuation.z = value
    }
 
    public func update(deltaTime: Float){
        lightData.position = _position
        lightData.brightness = _brightness
        lightData.color = _color
        lightData.attenuation = _attenuation
    }
    
    
    
}

