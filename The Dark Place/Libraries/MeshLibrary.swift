import MetalKit

enum MeshTypes {
    case Triangle_Custom
    case Quad_Custom
    case Cube_Custom
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
    func drawPrimitives(renderCommandEncoder: MTLRenderCommandEncoder, lineMode: Bool)
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
    private var minPositions = float3(0)
    private var maxPositions = float3(0)
    
    init(createBoundingBox: Bool = true) {
        setPrimitiveType(MTLPrimitiveType.triangle)
        setIndexType()
        createVertices()
        createIndices()
        createBuffers()
    }
    
    internal func addVertex(position: float3,
                            color: float4 = float4(0.25, 0.25, 0.25, 1.0),
                            normal: float3 = float3(0,1,0),
                            textureCoordinate: float2 = float2(0,0)){
        updateMinsAndMaxes(position)
        vertices.append(Vertex(position: position, color: color, normal: normal, textureCoordinate: textureCoordinate))
    }
    
    func updateMinsAndMaxes(_ position: float3){
        if(position.x > self.maxPositions.x){ maxPositions.x = position.x }
        if(position.y > self.maxPositions.y){ maxPositions.y = position.y }
        if(position.z > self.maxPositions.z){ maxPositions.z = position.z }
        
        if(position.x < self.minPositions.x){ self.minPositions.x = position.x }
        if(position.y < self.minPositions.y){ self.minPositions.y = position.y }
        if(position.z < self.minPositions.z){ self.minPositions.z = position.z }
    }
    
    func createVertices(){ }
    
    func createIndices(){ }
    
    //If you want to set the mesh to a different primitive type you can override this function
    func setPrimitiveType(_ primitiveType: MTLPrimitiveType){
        self.primitiveType = primitiveType
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
    
    func drawPrimitives(renderCommandEncoder: MTLRenderCommandEncoder, lineMode: Bool = false){
        if(lineMode){
            renderCommandEncoder.setTriangleFillMode(.lines)
        }else{
            renderCommandEncoder.setTriangleFillMode(.fill)
        }
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
