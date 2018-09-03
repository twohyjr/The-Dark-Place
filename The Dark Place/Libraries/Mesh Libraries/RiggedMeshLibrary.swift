import MetalKit

enum RiggedMeshTypes {
    case Cowboy
}

class RiggedMeshLibrary {
    
    private static var _meshes: [RiggedMeshTypes:RiggedModelMesh] = [:]
    
    public static func Initialize(){
        createDefaultMeshes()
    }
    
    private static func createDefaultMeshes(){
        //DAE FILES
        addModel_DAE("Cowboy", .Cowboy)
    }
    
    private static func addModel_DAE(_ modelName: String, _ modelMeshType: RiggedMeshTypes){
        _meshes.updateValue(RiggedModelMesh(modelName), forKey: modelMeshType)
    }
    
    public static func Mesh(_ meshType: RiggedMeshTypes)->RiggedModelMesh{
        return _meshes[meshType]!
    }
}

struct RiggedMesh {
    
}

class RiggedModelMesh {
    var mesh: RiggedMesh!
    
    init(_ fileName: String){
        mesh = ModelLoader.CreateMeshFromColladaFile(fileName)
    }
}





