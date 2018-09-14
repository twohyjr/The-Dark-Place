import MetalKit

enum LanternColors{
    case Red
    case Green
}

class Lantern: LampModelObject {
    

    init(_ lanternColor: LanternColors) {
        var result: ModelMeshTypes
        var name: String = String.Empty
        switch lanternColor {
        case .Red:
            result = ModelMeshTypes.StreetLanternRed
            name = "Red Lantern"
        case .Green:
            result = ModelMeshTypes.StreetLanternGreen
            name = "Green Lantern"
        }
        super.init(result, name: name)
        self.setScale(0.4)
        light.setPosition(float3(0.3, 4.366668, 1.3))
    }  
}
