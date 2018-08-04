import MetalKit

class Campfire: LampModelObject {
    
    init() {
        super.init(.Campfire)
        self.color = float3(0.9,0.15,0)
        self.brightness = 2
        self.attenuation = float3(0.0006, 0.045, 0.002);
        self.lightPosition.y = 0.1
        self.scale = float3(1.3)
    }
    
    var time: Float = 0.0
    override func update(deltaTime: Float) {
        time += deltaTime
        
        self.brightness = ((cos(time) / 2) * (sin(time) / 2) + 1.5) * Float.random(min: 0.4, max: 0.5)
        
        super.update(deltaTime: deltaTime)
    }
    
}
