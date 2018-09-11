import MetalKit

class AnimatedGameObject: Node {
    
    private var mesh: RiggedModelMesh!

    var modelConstants = ModelConstants()
    var material = Material()
    
    private var fillMode: MTLTriangleFillMode = .fill
    
    init(_ riggedMeshType: RiggedMeshTypes){
        super.init()
        
        self.mesh = RiggedMeshLibrary.Mesh(riggedMeshType)
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

extension AnimatedGameObject: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder, lights: inout [LightData]) {
        renderCommandEncoder.pushDebugGroup("Animated Game Object Render Call")
        
        renderCommandEncoder.setTriangleFillMode(fillMode)
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Rigged))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Basic))
        renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)

        renderCommandEncoder.setFragmentBytes(&material, length: Material.stride, index: 1)
        renderCommandEncoder.setFragmentBytes(lights,
                                              length: LightData.stride(lights.count),
                                              index: 2)
        
        var lightCount = lights.count
        renderCommandEncoder.setFragmentBytes(&lightCount, length: Int.stride, index: 3)

        mesh.drawPrimitives(renderCommandEncoder: renderCommandEncoder)

        renderCommandEncoder.popDebugGroup()
    }
}
