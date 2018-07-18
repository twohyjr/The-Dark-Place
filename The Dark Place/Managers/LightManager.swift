import MetalKit

class LightManager {
    
    private var _lights: [String: Light] = [:]
    
    var lightCount: Int {
        return max(1, _lights.count)
    }
    
    func addLight(lightName: String, light: Light){
        _lights.updateValue(light, forKey: lightName)
    }
    
    func getAllLightData()->[LightData]{
        if(_lights.count == 0){
            let emptyLight = EmptyLight()
            _lights.updateValue(emptyLight, forKey: "No Light")
        }
        var result: [LightData] = []
        for light in _lights.values {
            result.append(light.lightData)
        }
        
        return result
    }
    
    func updateLights(deltaTime: Float){
        for light in _lights.values {
            light.update(deltaTime: deltaTime)
        }
    }
    
}

protocol Light {
    var lightData: LightData! { get set }
    func update(deltaTime: Float)
}

private class EmptyLight: Light{
    var lightData: LightData! = LightData()
    
    func update(deltaTime: Float) {
        
    }
}

public class Sun: Light {
    var lightData: LightData! = LightData()
    init(){
        lightData.position.y = 10
    }
    func update(deltaTime: Float) {
        
    }
}


