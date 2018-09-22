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
    
    //Mesh
    var vertices: [RiggedVertex] = []
    var indices: [UInt16] = []
    private var _vertexBuffer: MTLBuffer!
    
    //Skeleton
    var rootJoint: Joint!
    var jointCount: Int!
    
    
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
    var riggedMesh: RiggedMesh!
    
    init(_ modelName: String){
        riggedMesh = ModelLoader.CreateMeshFromCollada(modelName)
    }
    
    func drawPrimitives(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBuffer(riggedMesh.vertexBuffer,
                                             offset: 0,
                                             index: 0)
        if(riggedMesh.indexCount == 0){
            renderCommandEncoder.drawPrimitives(type: riggedMesh.primitiveType,
                                                vertexStart: 0,
                                                vertexCount: riggedMesh.vertexCount)
        }else{
            renderCommandEncoder.drawIndexedPrimitives(type: riggedMesh.primitiveType,
                                                       indexCount: riggedMesh.indexCount,
                                                       indexType: riggedMesh.indexType,
                                                       indexBuffer: riggedMesh.indexBuffer,
                                                       indexBufferOffset: 0)
        }
    }
}





