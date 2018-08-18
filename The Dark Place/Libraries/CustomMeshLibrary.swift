import MetalKit

enum CustomMeshTypes {
    case Triangle_Custom
    case Quad_Custom
    case Cube_Custom
    case QuadPyramid_Custom
}

class MeshLibrary {
    
    private static var meshes: [CustomMeshTypes:CustomMesh] = [:]
    
    public static func Initialize(){
        createDefaultMeshes()
    }
    
    private static func createDefaultMeshes(){
        meshes.updateValue(Triangle_CustomMesh(), forKey: .Triangle_Custom)
        meshes.updateValue(Quad_CustomMesh(), forKey: .Quad_Custom)
        meshes.updateValue(Cube_CustomMesh(), forKey: .Cube_Custom)
        meshes.updateValue(QuadPyramid_CustomMesh(), forKey: .QuadPyramid_Custom)
    }
    
    public static func Mesh(_ meshType: CustomMeshTypes)->CustomMesh{
        return meshes[meshType]!
    }
}








