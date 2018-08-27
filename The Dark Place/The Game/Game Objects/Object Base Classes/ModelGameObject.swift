import MetalKit

class ModelGameObject: Node {
    private var _modelConstants = ModelConstants()
    private var _modelMesh: Mesh!
    private var _material = Material()
    
    private var _contrastDelta = float3(0)
    var getContrastDelta: float3 {
        return _contrastDelta
    }
    func setContrastDelta(_ value: float3){
        self._contrastDelta = value
    }
    func setContrastDelta(_ value: Float){
        self._contrastDelta = float3(value)
    }
    
    var fillMode: MTLTriangleFillMode = .fill
    
    init(_ modelMeshType: ModelMeshTypes){
        super.init()
        _modelMesh = ModelMeshLibrary.Mesh(modelMeshType)
    }
    
    public func lineModeOn(_ isOn: Bool){
        self.fillMode = isOn ? MTLTriangleFillMode.lines : MTLTriangleFillMode.fill
    }
    
    override func update(deltaTime: Float){
        updateModelConstants()
        super.update(deltaTime: deltaTime)
    }
    
    private func updateModelConstants(){
        _modelConstants.modelMatrix = self.modelMatrix
        _modelConstants.normalMatrix = self.modelMatrix.upperLeftMatrix
        _material.contrastDelta = self._contrastDelta
    }
}

extension ModelGameObject: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder, lights: inout [LightData]) {
        renderCommandEncoder.pushDebugGroup("Model Game Object Render Call")

        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Basic))
        renderCommandEncoder.setTriangleFillMode(fillMode)
        renderCommandEncoder.setVertexBytes(&_modelConstants, length: ModelConstants.stride, index: 2)
        renderCommandEncoder.setFragmentBytes(lights,
                                              length: LightData.stride(lights.count),
                                              index: 2)
        
        var lightCount = lights.count
        renderCommandEncoder.setFragmentBytes(&lightCount, length: Int.stride, index: 3)
        
        for i in 0..<_modelMesh.meshes.count {
            var mdlMesh: MDLMesh! = nil
            var mtkMesh: MTKMesh! = nil
            do{
                mtkMesh = try MTKMesh.init(mesh: _modelMesh.meshes[i], device: Engine.Device)
                mdlMesh = _modelMesh.meshes[i]
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
                _material.color = float4(diffuse!.x, diffuse!.y, diffuse!.z, 1.0)
                _material.ambient = ambient
                _material.diffuse = float3(0.2)
                _material.specular = specular!
                renderCommandEncoder.setFragmentBytes(&_material, length: Material.stride, index: 1)
                renderCommandEncoder.drawIndexedPrimitives(type: mtkSubmesh.primitiveType,
                                                           indexCount: mtkSubmesh.indexCount,
                                                           indexType: mtkSubmesh.indexType,
                                                           indexBuffer: mtkSubmesh.indexBuffer.buffer,
                                                           indexBufferOffset: mtkSubmesh.indexBuffer.offset)
            }
            renderCommandEncoder.popDebugGroup()
        }
    }
}
