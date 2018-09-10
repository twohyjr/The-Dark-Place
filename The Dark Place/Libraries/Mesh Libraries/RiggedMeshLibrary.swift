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

class RiggedMesh{
    var vertices: [RiggedVertex] = []
    var indices: [UInt16] = []
    private var _vertexBuffer: MTLBuffer!
    var vertexBuffer: MTLBuffer! {
        if(_vertexBuffer == nil){
            _vertexBuffer = Engine.Device.makeBuffer(bytes: vertices,
                                                     length: Vertex.stride(vertices.count),
                                                     options: [])
        }
        return _vertexBuffer
    }
    private var _indexBUffer: MTLBuffer!
    var indexBuffer: MTLBuffer! {
        if(_indexBUffer == nil && indices.count > 0){
            _indexBUffer = Engine.Device.makeBuffer(bytes: indices,
                                                     length: UInt16.stride(indices.count),
                                                     options: [])
        }
        return _indexBUffer
    }
    var vertexCount: Int {
        return vertices.count
    }
    var indexCount: Int {
        return indices.count
    }
    var primitiveType: MTLPrimitiveType! = MTLPrimitiveType.triangle
    var indexType: MTLIndexType! = MTLIndexType.uint16
}

class RiggedModelMesh {
    var mesh: RiggedMesh!
    var vertexBuffer: MTLBuffer!
    
    init(_ fileName: String){
        mesh = ModelLoader.CreateMeshFromCollada(fileName)
    }
    
    func drawPrimitives(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer,
                                             offset: 0,
                                             index: 0)
        if(mesh.indexCount == 0){
            renderCommandEncoder.drawPrimitives(type: mesh.primitiveType,
                                                vertexStart: 0,
                                                vertexCount: mesh.vertexCount)
        }else{
            renderCommandEncoder.drawIndexedPrimitives(type: mesh.primitiveType,
                                                       indexCount: mesh.indexCount,
                                                       indexType: mesh.indexType,
                                                       indexBuffer: mesh.indexBuffer,
                                                       indexBufferOffset: 0)
        }
    }
}





