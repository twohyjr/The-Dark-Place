import MetalKit

class Light {

    var lightData = LightData()
    var position = float3(0)
    var brightness: Float = 1
    var color = float3(1)
    
    func update(deltaTime: Float){
        lightData.position = position
        lightData.brightness = brightness
        lightData.color = color
    }
    
}

