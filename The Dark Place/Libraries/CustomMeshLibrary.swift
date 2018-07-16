import MetalKit

enum CustomMeshTypes {
    case Triangle_Custom
    case Quad_Custom
    case Cube_Custom
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
    }
    
    public static func Mesh(_ meshType: CustomMeshTypes)->CustomMesh{
        return meshes[meshType]!
    }
}

protocol CustomMesh {
    var vertexBuffer: MTLBuffer! { get }
    var indexBuffer: MTLBuffer! { get }
    var vertexCount: Int! { get }
    var indexCount: Int! { get }
    
    var primitiveType: MTLPrimitiveType! { get }
    var boundingBoxes: [BoundingBox]! { get }
    func drawPrimitives(renderCommandEncoder: MTLRenderCommandEncoder)
}








