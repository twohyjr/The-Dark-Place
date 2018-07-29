import MetalKit

class ModelGameObject: Node {
    var modelConstants = ModelConstants()
    var modelMesh: Mesh!
    private var fillMode: MTLTriangleFillMode = .fill
    
    init(_ modelMeshType: ModelMeshTypes){
        super.init()
        modelMesh = ModelMeshLibrary.Mesh(modelMeshType)
    }
    
    public func lineModeOn(_ isOn: Bool){
        self.fillMode = isOn ? MTLTriangleFillMode.lines : MTLTriangleFillMode.fill
    }
    
    override func update(deltaTime: Float){
        updateModelConstants()
        super.update(deltaTime: deltaTime)
    }
    
    private func updateModelConstants(){
        modelConstants.modelMatrix = self.modelMatrix
        modelConstants.normalMatrix = self.modelMatrix.upperLeftMatrix
    }
}

extension ModelGameObject: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder, light: inout Light) {
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        renderCommandEncoder.setTriangleFillMode(fillMode)
        renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Basic))
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
                let mtkSubmesh = mtkMesh.submeshes[j]
                let mdlSubmeshes = mdlMesh.submeshes as? [MDLSubmesh]
                let ambient = float3(0)
                let diffuse = mdlSubmeshes![j].material?.properties(with: MDLMaterialSemantic.baseColor).first?.float3Value
                let specular = mdlSubmeshes![j].material?.properties(with: MDLMaterialSemantic.specular).first?.float3Value
                var material = Material()
                material.ambient = ambient
                material.diffuse = diffuse!
                material.specular = specular!
                renderCommandEncoder.setFragmentBytes(&material, length: Material.stride, index: 1)
                renderCommandEncoder.drawIndexedPrimitives(type: mtkSubmesh.primitiveType,
                                                           indexCount: mtkSubmesh.indexCount,
                                                           indexType: mtkSubmesh.indexType,
                                                           indexBuffer: mtkSubmesh.indexBuffer.buffer,
                                                           indexBufferOffset: mtkSubmesh.indexBuffer.offset)
            }
        }
    }
}
