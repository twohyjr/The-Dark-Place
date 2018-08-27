import MetalKit

enum LanternColors{
    case Red
    case Green
}

class Lantern: LampModelObject {
    

    init(_ lanternColor: LanternColors) {
        var result: ModelMeshTypes
        switch lanternColor {
        case .Red:
            result = ModelMeshTypes.StreetLanternRed
        case .Green:
            result = ModelMeshTypes.StreetLanternGreen
        }
        super.init(result)
        self.setScale(0.4)
        light.setPosition(float3(0.3, 4.366668, 1.3))
    }

}
