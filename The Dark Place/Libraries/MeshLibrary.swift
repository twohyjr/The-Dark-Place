import MetalKit

enum MeshTypes {
    case Triangle_Custom
    case Quad_Custom
    case Cube_Custom
    case Skybox_Custom
}

class MeshLibrary {
    
    private static var meshes: [MeshTypes:Mesh] = [:]
    
    public static func Initialize(){
        createDefaultMeshes()
    }
    
    private static func createDefaultMeshes(){
        meshes.updateValue(Triangle_CustomMesh(), forKey: .Triangle_Custom)
        meshes.updateValue(Quad_CustomMesh(), forKey: .Quad_Custom)
        meshes.updateValue(Cube_CustomMesh(), forKey: .Cube_Custom)
        meshes.updateValue(Skybox_CustomMesh(), forKey: .Skybox_Custom)
    }
    
    public static func Mesh(_ meshType: MeshTypes)->Mesh{
        return meshes[meshType]!
    }
    
}

protocol Mesh {
    var vertexBuffer: MTLBuffer! { get }
    var indexBuffer: MTLBuffer! { get }
    var vertexCount: Int! { get }
    var indexCount: Int! { get }
    
    var primitiveType: MTLPrimitiveType! { get }
    func drawPrimitives(renderCommandEncoder: MTLRenderCommandEncoder)
}

class CustomMesh: Mesh {
    var vertices: [Vertex] = []
    var indices: [UInt16] = []
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    var primitiveType: MTLPrimitiveType!
    var indexType: MTLIndexType!
    var vertexCount: Int! {
        return vertices.count
    }
    var indexCount: Int! {
        return indices.count
    }
    
    init() {
        setPrimitiveType()
        setIndexType()
        createVertices()
        createIndices()
        createBuffers()
    }
    
    internal func addVertex(position: float3,
                            color: float4 = float4(0.25, 0.25, 0.25, 1.0),
                            normal: float3 = float3(0,1,0),
                            textureCoordinate: float2 = float2(0,0)){
        vertices.append(Vertex(position: position, color: color, normal: normal, textureCoordinate: textureCoordinate))
    }
    
    func createVertices(){ }
    
    func createIndices(){ }
    
    //If you want to set the mesh to a different primitive type you can override this function
    func setPrimitiveType(){
        primitiveType = MTLPrimitiveType.triangle
    }
    
    func setIndexType(){
        indexType = MTLIndexType.uint16
    }
    
    func createBuffers(){
        if(vertexCount > 0){
            vertexBuffer = Engine.Device.makeBuffer(bytes: vertices, length: Vertex.stride(vertices.count), options: [])
        }
        if(indexCount > 0){
            indexBuffer = Engine.Device.makeBuffer(bytes: indices, length: UInt16.stride(indexCount), options: [])
        }
    }
    
    func drawPrimitives(renderCommandEncoder: MTLRenderCommandEncoder){
        if(indexCount == 0){
            renderCommandEncoder.drawPrimitives(type: primitiveType, vertexStart: 0, vertexCount: vertexCount)
        }else{
            renderCommandEncoder.drawIndexedPrimitives(type: primitiveType,
                                                       indexCount: indexCount,
                                                       indexType: indexType,
                                                       indexBuffer: indexBuffer,
                                                       indexBufferOffset: 0)
        }
    }
}

class Triangle_CustomMesh: CustomMesh {
    override func createVertices() {
        addVertex(position: float3( 0, 1,0), color: float4(1,0,0,1))
        addVertex(position: float3(-1,-1,0), color: float4(0,1,0,1))
        addVertex(position: float3( 1,-1,0), color: float4(0,0,1,1))
    }
}


//Origin: Bottom Left
class Quad_CustomMesh: CustomMesh {
    override func createVertices() {
        //Top Right
        addVertex(position: float3( 1, 1,0), color: float4(1,0,0,1), normal: float3( 0.0, 0.0, -1.0), textureCoordinate: float2(1,0))
        
        //Top Left
        addVertex(position: float3(-1, 1,0), color: float4(0,1,0,1), normal: float3( 0.0, 0.0, -1.0), textureCoordinate: float2(0,0))
        
        //Bottom Left
        addVertex(position: float3(-1,-1,0), color: float4(0,0,1,1), normal: float3( 0.0, 0.0, -1.0), textureCoordinate: float2(0,1))
        
        //Top Right
        addVertex(position: float3( 1, 1,0), color: float4(1,0,0,1), normal: float3( 0.0, 0.0, -1.0), textureCoordinate: float2(1,0))
        
        //Bottom Left
        addVertex(position: float3(-1,-1,0), color: float4(0,0,1,1), normal: float3( 0.0, 0.0, -1.0), textureCoordinate: float2(0,1))
        
        //Bottom Right
        addVertex(position: float3( 1,-1,0), color: float4(1,0,1,1), normal: float3( 0.0, 0.0, -1.0), textureCoordinate: float2(1,1))
    }
}

class Cube_CustomMesh: CustomMesh {
    override func createVertices() {
        //Left
        addVertex(position: float3(-1.0,-1.0,-1.0), color: float4(1,0,0,1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0,-1.0, 1.0), color: float4(1,0,0,1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0, 1.0, 1.0), color: float4(1,0,0,1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0,-1.0,-1.0), color: float4(1,0,0,1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0, 1.0, 1.0), color: float4(1,0,0,1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0, 1.0,-1.0), color: float4(1,0,0,1), normal: float3(-1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        
        //RIGHT
        addVertex(position: float3( 1.0, 1.0, 1.0), color: float4(0,1,0,1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0,-1.0,-1.0), color: float4(0,1,0,1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0, 1.0,-1.0), color: float4(0,1,0,1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0,-1.0,-1.0), color: float4(0,1,0,1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0, 1.0, 1.0), color: float4(0,1,0,1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0,-1.0, 1.0), color: float4(0,1,0,1), normal: float3( 1.0, 0.0, 0.0), textureCoordinate: float2(0,1))
        
        //TOP
        addVertex(position: float3( 1.0, 1.0, 1.0), color: float4(1,0,1,1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0, 1.0,-1.0), color: float4(1,0,1,1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0, 1.0,-1.0), color: float4(1,0,1,1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0, 1.0, 1.0), color: float4(1,0,1,1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0, 1.0,-1.0), color: float4(1,0,1,1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0, 1.0, 1.0), color: float4(1,0,1,1), normal: float3(0.0, 1.0, 0.0), textureCoordinate: float2(0,1))
        
        //BOTTOM
        addVertex(position: float3( 1.0,-1.0, 1.0), color: float4(1,1,0,1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0,-1.0,-1.0), color: float4(1,1,0,1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0,-1.0,-1.0), color: float4(1,1,0,1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0,-1.0, 1.0), color: float4(1,1,0,1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0,-1.0, 1.0), color: float4(1,1,0,1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0,-1.0,-1.0), color: float4(1,1,0,1), normal: float3(0.0,-1.0, 0.0), textureCoordinate: float2(0,1))
        
        //BACK
        addVertex(position: float3( 1.0, 1.0,-1.0), color: float4(0,1,0,1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0,-1.0,-1.0), color: float4(0,1,0,1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0, 1.0,-1.0), color: float4(0,1,0,1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0, 1.0,-1.0), color: float4(0,1,0,1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0,-1.0,-1.0), color: float4(0,1,0,1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0,-1.0,-1.0), color: float4(0,1,0,1), normal: float3(0.0, 0.0,-1.0), textureCoordinate: float2(0,1))
        
        //FRONT
        addVertex(position: float3(-1.0, 1.0, 1.0), color: float4(0,0,1,1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0,-1.0, 1.0), color: float4(0,0,1,1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0,-1.0, 1.0), color: float4(0,0,1,1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0, 1.0, 1.0), color: float4(0,0,1,1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3(-1.0, 1.0, 1.0), color: float4(0,0,1,1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
        addVertex(position: float3( 1.0,-1.0, 1.0), color: float4(0,0,1,1), normal: float3(0.0, 0.0, 1.0), textureCoordinate: float2(0,1))
    }
}

class Skybox_CustomMesh: CustomMesh {
    override func createVertices() {
        // +Y
        addVertex(position: float3(-0.5,  0.5,  0.5), normal: float3(0.0, -1.0,  0.0))
        addVertex(position: float3( 0.5,  0.5,  0.5), normal: float3(0.0, -1.0,  0.0))
        addVertex(position: float3( 0.5,  0.5, -0.5), normal: float3(0.0, -1.0,  0.0))
        addVertex(position: float3(-0.5,  0.5, -0.5), normal: float3(0.0, -1.0,  0.0))
        // -Y
        addVertex(position: float3(-0.5, -0.5, -0.5), normal: float3(0.0,  1.0,  0.0))
        addVertex(position: float3( 0.5, -0.5, -0.5), normal: float3(0.0,  1.0,  0.0))
        addVertex(position: float3( 0.5, -0.5,  0.5), normal: float3(0.0,  1.0,  0.0))
        addVertex(position: float3(-0.5, -0.5,  0.5), normal: float3(0.0,  1.0,  0.0))
        // +Z
        addVertex(position: float3(-0.5, -0.5,  0.5), normal: float3(0.0,  0.0, -1.0))
        addVertex(position: float3( 0.5, -0.5,  0.5), normal: float3(0.0,  0.0, -1.0))
        addVertex(position: float3( 0.5,  0.5,  0.5), normal: float3(0.0,  0.0, -1.0))
        addVertex(position: float3(-0.5,  0.5,  0.5), normal: float3(0.0,  0.0, -1.0))
        // -Z
        addVertex(position: float3( 0.5, -0.5, -0.5), normal: float3(0.0,  0.0,  1.0))
        addVertex(position: float3(-0.5, -0.5, -0.5), normal: float3(0.0,  0.0,  1.0))
        addVertex(position: float3(-0.5,  0.5, -0.5), normal: float3(0.0,  0.0,  1.0))
        addVertex(position: float3( 0.5,  0.5, -0.5), normal: float3(0.0,  0.0,  1.0))
        // -X
        addVertex(position: float3(-0.5, -0.5, -0.5), normal: float3(1.0,  0.0,  0.0))
        addVertex(position: float3(-0.5, -0.5,  0.5), normal: float3(1.0,  0.0,  0.0))
        addVertex(position: float3(-0.5,  0.5,  0.5), normal: float3(1.0,  0.0,  0.0))
        addVertex(position: float3(-0.5,  0.5, -0.5), normal: float3(1.0,  0.0,  0.0))
        // +X
        addVertex(position: float3( 0.5, -0.5,  0.5), normal: float3(1.0,  0.0,  0.0))
        addVertex(position: float3( 0.5, -0.5, -0.5), normal: float3(1.0,  0.0,  0.0))
        addVertex(position: float3( 0.5,  0.5, -0.5), normal: float3(1.0,  0.0,  0.0))
        addVertex(position: float3( 0.5,  0.5,  0.5), normal: float3(1.0,  0.0,  0.0))
    }
    
    override func createIndices() {
        indices = [
            0,  3,  2,  2,  1,  0,
            4,  7,  6,  6,  5,  4,
            8, 11, 10, 10,  9,  8,
            12, 15, 14, 14, 13, 12,
            16, 19, 18, 18, 17, 16,
            20, 23, 22, 22, 21, 20
        ]
    }
}
