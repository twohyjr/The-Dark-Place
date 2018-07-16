import MetalKit

enum MeshTypes {
    case Triangle_Custom
    case Quad_Custom
    case Cube_Custom
}

class MeshLibrary {
    
    private static var meshes: [MeshTypes:MyMesh] = [:]
    
    public static func Initialize(){
        createDefaultMeshes()
    }
    
    private static func createDefaultMeshes(){
        meshes.updateValue(Triangle_CustomMesh(), forKey: .Triangle_Custom)
        meshes.updateValue(Quad_CustomMesh(), forKey: .Quad_Custom)
        meshes.updateValue(Cube_CustomMesh(), forKey: .Cube_Custom)
    }
    
    public static func Mesh(_ meshType: MeshTypes)->MyMesh{
        return meshes[meshType]!
    }
    
}

protocol MyMesh {
    var vertexBuffer: MTLBuffer! { get }
    var indexBuffer: MTLBuffer! { get }
    var vertexCount: Int! { get }
    var indexCount: Int! { get }
    
    var primitiveType: MTLPrimitiveType! { get }
    func drawPrimitives(renderCommandEncoder: MTLRenderCommandEncoder, lineMode: Bool)
}








