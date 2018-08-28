import MetalKit

enum ModelMeshTypes {
    case Tent
    case TentWithPoles
    case Campfire
    case RedMushroom
    case LargeGreenOak
    case StreetLanternRed
    case StreetLanternGreen
}

class ModelMeshLibrary {
    
    private static var _meshes: [ModelMeshTypes:BasicMesh] = [:]
    
    public static func Initialize(){
        createDefaultMeshes()
    }
    
    private static func createDefaultMeshes(){
        //OBJ FILES
        addModel_OBJ("Tent_01", .Tent)
        addModel_OBJ("Tent_Poles_01", .TentWithPoles)
        addModel_OBJ("Campfire_01", .Campfire)
        addModel_OBJ("Mushroom_Red_01", .RedMushroom)
        addModel_OBJ("Large_Oak_Green_01", .LargeGreenOak)
        addModel_OBJ("LanternRed", .StreetLanternRed)
        addModel_OBJ("LanternGreen", .StreetLanternGreen)
    }
    
    private static func addModel_OBJ(_ modelName: String, _ modelMeshType: ModelMeshTypes){
        _meshes.updateValue(ModelMesh(modelName), forKey: modelMeshType)
    }

    public static func Mesh(_ meshType: ModelMeshTypes)->BasicMesh{
        return _meshes[meshType]!
    }
}

protocol BasicMesh {
    var meshes: [MDLMesh] { get }
}

public class ModelMesh: BasicMesh {
    var meshes: [MDLMesh] = []
    
    init(_ modelName: String) {
        meshes = ModelLoader.CreateMtkMeshArrayFromWavefront(modelName)
    }
}











