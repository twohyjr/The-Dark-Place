import MetalKit

class ModelGameObject: Node {
    var modelConstants = ModelConstants()
    var renderPipelineState: MTLRenderPipelineState!
    var modelMesh: Mesh!
    var useLines: Bool = false
    
    init(_ modelMeshType: ModelMeshTypes){
        super.init()
        modelMesh = ModelMeshLibrary.Mesh(modelMeshType)
        setRenderPipelineState()
    }
    
    override func update(deltaTime: Float){
        updateModelConstants()
        super.update(deltaTime: deltaTime)
    }
    
    private func updateModelConstants(){
        modelConstants.modelMatrix = self.modelMatrix
    }
    
    internal func setRenderPipelineState(){
        renderPipelineState = RenderPipelineStateLibrary.PipelineState(.Basic)
    }
}

extension ModelGameObject: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)
        for i in 0..<modelMesh.meshes.count {
            var mdlMesh: MDLMesh! = nil
            var mtkMesh: MTKMesh! = nil
            do{
                mtkMesh = try MTKMesh.init(mesh: modelMesh.meshes[i], device: Engine.Device)
                mdlMesh = modelMesh.meshes[i]
            }catch{
                print(error)
            }
            
            let vertexBuffer: MTKMeshBuffer = mtkMesh.vertexBuffers.first!
            renderCommandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: 0, index: 0)
            for j in 0..<mtkMesh.submeshes.count{
                let submesh = mtkMesh.submeshes[j]
                renderCommandEncoder.drawIndexedPrimitives(type: submesh.primitiveType,
                                                           indexCount: submesh.indexCount,
                                                           indexType: submesh.indexType,
                                                           indexBuffer: submesh.indexBuffer.buffer,
                                                           indexBufferOffset: submesh.indexBuffer.offset)
            }
//            print((mdlMesh.submeshes as! [MDLSubmesh]).first?.material?.properties(with: MDLMaterialSemantic.baseColor).first?.float4Value)
        }
//        for _ in modelMesh.meshes {
//            var mdlMesh: MDLMesh! = nil
//            var mtkMesh: MTKMesh! = nil
//            do{
//                mtkMesh = try MTKMesh.init(mesh: meshes.first!, device: Engine.Device)
//                mdlMesh = meshes.first
//            }catch{
//                print(error)
//            }

//        mtkMesh.vertexBuffers.first?.buffer
//        mtkMesh.submeshes.first?.indexBuffer
//        (mdlMesh.submeshes as! [MDLSubmesh]).first?.material?.properties(with: MDLMaterialSemantic.baseColor).first?.color
//        }
    }
}
