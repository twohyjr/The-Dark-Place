import MetalKit

enum ModelMeshTypes {
    case Tent
}

class ModelMeshLibrary {
    
    private static var meshes: [ModelMeshTypes:Mesh] = [:]
    
    public static func Initialize(){
        createDefaultMeshes()
    }
    
    private static func createDefaultMeshes(){
        meshes.updateValue(ModelMesh("Tent_01"), forKey: .Tent)
    }
    
    public static func Mesh(_ meshType: ModelMeshTypes)->Mesh{
        return meshes[meshType]!
    }
    
}

protocol Mesh {
    var meshes: [MDLMesh] { get }
}

public class ModelMesh: Mesh {
    var meshes: [MDLMesh] = []
    
    init(_ modelName: String) {
        meshes = ModelLoader.CreateMtkMeshArrayFromWavefront(modelName)
    }
}










