import MetalKit

class ModelGameObject: Node {
    private var _modelMesh: ModelMesh!
    private var _materials: [Material] = [Material]()

    var fillMode: MTLTriangleFillMode = .fill
    
    init(_ modelMeshType: ModelMeshTypes, name: String = String.Empty){
        super.init()
        self.name = name
        _modelMesh = ModelMeshLibrary.Mesh(modelMeshType)
        generateMaterial()
    }
    
    private func generateMaterial(){
        for i in 0..<_modelMesh.meshes.count {
            var mdlMesh: MDLMesh! = nil
            var mtkMesh: MTKMesh! = nil
            do{
                mtkMesh = try MTKMesh.init(mesh: _modelMesh.meshes[i], device: Engine.Device)
                mdlMesh = _modelMesh.meshes[i]
            }catch{
                print(error)
            }

            for j in 0..<mtkMesh.submeshes.count{
                let mdlSubmeshes = mdlMesh.submeshes as? [MDLSubmesh]
                let ambient = float3(0)
                let diffuse = mdlSubmeshes![j].material?.properties(with: MDLMaterialSemantic.baseColor).first?.float3Value
                let specular = mdlSubmeshes![j].material?.properties(with: MDLMaterialSemantic.specular).first?.float3Value
                var material = Material()
                material.ambient = ambient
                material.diffuse =  diffuse!
                material.specular = specular!
                _materials.append(material)
            }
        }
    }
}

extension ModelGameObject: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Basic))

        for i in 0..<_modelMesh.meshes.count {
            var mtkMesh: MTKMesh! = nil
            do{
                mtkMesh = try MTKMesh.init(mesh: _modelMesh.meshes[i], device: Engine.Device)
            }catch{
                print(error)
            }
            let vertexBuffer: MTKMeshBuffer = mtkMesh.vertexBuffers.first!
            renderCommandEncoder.setVertexBuffer(vertexBuffer.buffer, offset: 0, index: 0)
            
            for j in 0..<mtkMesh.submeshes.count{
                let mtkSubmesh = mtkMesh.submeshes[j]
                renderCommandEncoder.setFragmentBytes(&_materials[j], length: Material.stride, index: 1)
                renderCommandEncoder.drawIndexedPrimitives(type: mtkSubmesh.primitiveType,
                                                           indexCount: mtkSubmesh.indexCount,
                                                           indexType: mtkSubmesh.indexType,
                                                           indexBuffer: mtkSubmesh.indexBuffer.buffer,
                                                           indexBufferOffset: mtkSubmesh.indexBuffer.offset)
            }
        }
    }
}
