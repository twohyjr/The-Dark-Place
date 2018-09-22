import MetalKit

enum LanternColors{
    case Red
    case Green
}

class Lantern: LampModelObject {
    
    init(_ lanternColor: LanternColors) {
        var result: ModelMeshTypes
        var name: String = String.Empty
        var color: float3!
        switch lanternColor {
        case .Red:
            result = ModelMeshTypes.StreetLanternRed
            color = float3(1,0,0)
            name = "Red Lantern"
        case .Green:
            result = ModelMeshTypes.StreetLanternGreen
            color = float3(0,1,0)
            name = "Green Lantern"
        }
        super.init(result, name: name)
        self.setScale(0.4)
        self.color = color
        light.setPosition(float3(0.3, 4.366668, 1.3))
        
    }
    
    override func update(deltaTime: Float) {
        super.update(deltaTime: deltaTime)
    }
}
