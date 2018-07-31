import MetalKit

class GameObject: Node {
    
    var modelConstants = ModelConstants()
    var renderPipelineState: MTLRenderPipelineState!
    var mesh: CustomMesh!
    var material = Material()
    var color: float3 = float3(1)
    var specularity: float3 = float3(0.1)
    var shininess: Float = 0.5
    private var fillMode: MTLTriangleFillMode = .fill
    
    init(meshType: CustomMeshTypes) {
        super.init()
        mesh = MeshLibrary.Mesh(meshType)
        setRenderPipelineState()
    }
    
    override init(){
        super.init()
        setRenderPipelineState()
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
        material.diffuse = color
        material.specular = specularity
        material.shininess = shininess
    }
    
    internal func setRenderPipelineState(){
        renderPipelineState = RenderPipelineStateLibrary.PipelineState(.Basic)
    }
}

extension GameObject: Renderable{
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder, light: inout Light) {
        
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)
        renderCommandEncoder.setTriangleFillMode(fillMode)
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Basic))
        renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)
        renderCommandEncoder.setFragmentBytes(&material, length: Material.stride, index: 1)
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        
        mesh.drawPrimitives(renderCommandEncoder: renderCommandEncoder)
    }
}
