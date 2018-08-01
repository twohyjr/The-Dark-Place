import MetalKit

class Light {

    var lightData = LightData()
    var position = float3(0)
    
    func update(deltaTime: Float){
        lightData.position = position
    }
    
}
