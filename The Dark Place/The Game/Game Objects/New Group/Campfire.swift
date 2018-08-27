import MetalKit

class Campfire: LampModelObject {
    
    init() {
        super.init(.Campfire)
        self.color = float3(0.9,0.15,0)
        self.brightness = 2
        self.light.moveY(0.2)
        self.attenuation = float3(0.050600007, 0.185, 0.60199964);
        self.light.setPosition(float3(0.4339335, 0.28500003, -0.51466686))
        self.setScale(float3(1.3))
    }
    
    var time: Float = 0.0
    override func update(deltaTime: Float) {
        time += deltaTime
        self.brightness = (((cos(time) / 6) * (sin(time) / 8) + 6) * Float.random(min: 0.35, max: 0.5))

        self.lightPosition = self.getPosition() + light.position
        super.update(deltaTime: deltaTime)
    }
    
}
