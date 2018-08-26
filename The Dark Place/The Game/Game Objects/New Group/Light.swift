import MetalKit

class Light {

    internal var lightData = LightData()
    
    private var _position = float3(0)
    var position: float3 {
        return _position
    }
    
    func setPosition(_ value: float3){
        self._position = value
    }
    
    private var _brightness: Float = 1
    var brightness: Float {
        return _brightness
    }
    
    func setBrightness(_ value: Float){
        self._brightness = value
    }
    
    private var _color = float3(1)
    var color: float3 {
        return _color
    }
    
    func setColor(_ value: float3){
        self._color = value
    }

    private var _attenuation = float3(1)
    var attenuation: float3 {
        return _attenuation
    }
    
    func setAttenuation(_ value: float3){
        self._attenuation = value
    }
 
    func update(deltaTime: Float){
        lightData.position = position
        lightData.brightness = brightness
        lightData.color = color
        lightData.attenuation = attenuation
    }
    
    
    
}

