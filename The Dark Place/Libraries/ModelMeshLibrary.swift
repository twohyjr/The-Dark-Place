import MetalKit

enum ModelMeshTypes {
    case Tent
    case TentWithPoles
    case Campfire
    case RedMushroom
    case LargeGreenOak
    case StreetLanternRed
    case StreetLanternGreen
    case Cowboy
}

enum FileTypes {
    case OBJ
    case DAE
}

class ModelMeshLibrary {
    
    private static var _meshes: [ModelMeshTypes:Mesh] = [:]
    
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
        
        //DAE FILES
        addModel_DAE("Cowboy", .Cowboy)
    }
    
    private static func addModel_OBJ(_ modelName: String, _ modelMeshType: ModelMeshTypes){
        _meshes.updateValue(ModelMesh(modelName, .OBJ), forKey: modelMeshType)
    }
    
    private static func addModel_DAE(_ modelName: String, _ modelMeshType: ModelMeshTypes){
        _meshes.updateValue(ModelMesh(modelName, .DAE), forKey: modelMeshType)
    }
    
    public static func Mesh(_ meshType: ModelMeshTypes)->Mesh{
        return _meshes[meshType]!
    }
}

protocol Mesh {
    var meshes: [MDLMesh] { get }
}

public class ModelMesh: Mesh {
    var meshes: [MDLMesh] = []
    
    init(_ modelName: String, _ fileType: FileTypes) {
        switch fileType {
        case .OBJ:
            meshes = ModelLoader.CreateMtkMeshArrayFromWavefront(modelName)
        case .DAE:
            //meshes = ModelLoader.CreateMeshFromDAEFile(modelName)
            print("NOT A VALID FILE YET")
        }
    }
}











