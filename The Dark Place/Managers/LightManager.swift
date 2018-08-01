
class LightManager {
    
    private static var _lights: [String:Light] = [:]
    
    public static var LightData: [LightData] {
        var result: [LightData] = []
        for light in _lights {
            result.append(light.value.lightData)
        }
        return result
    }
    
    public static func AddLight(lightName: String, light: Light){
        _lights.updateValue(light, forKey: lightName)
    }
    
    ///Returns the lightname generated by the newly added light
    public static func AddLightAndGetName()->String{
        let lightName: String = String(randomBounded(lowerBound: 0, upperBound: 100000))
        AddLight(lightName: lightName, light: Light())
        return lightName
    }
    
    public static func GetLight(_ lightName: String )->Light{
        return _lights[lightName]!
    }
    
    public static func UpdateLights(deltaTime: Float){
        for light in _lights.values{
            light.update(deltaTime: deltaTime)
        }
    }
    
}