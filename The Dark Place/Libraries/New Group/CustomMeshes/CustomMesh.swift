import MetalKit

class CustomModelMesh: CustomMesh {
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
    var boundingBoxes: [BoundingBox]! = []
    init() {
        setPrimitiveType(MTLPrimitiveType.triangle)
        setIndexType()
        createVertices()
        createIndices()
        createBuffers()
        addBoundingBoxes()
    }
    
    private func addBoundingBoxes(){
        self.boundingBoxes.append(BoundingBox(mins: minPositions, maxs: maxPositions))
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
