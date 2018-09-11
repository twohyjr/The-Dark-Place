import MetalKit

class AnimatedGameObject: Node {
    
    private var mesh: RiggedModelMesh!

    var modelConstants = ModelConstants()
    var material = Material()
    
    var texture: MTLTexture!
    
    private var fillMode: MTLTriangleFillMode = .fill
    
    init(riggedMeshType: RiggedMeshTypes,  textureType: TextureTypes = TextureTypes.None){
        super.init()
        
        self.mesh = RiggedMeshLibrary.Mesh(riggedMeshType)
        if(textureType != TextureTypes.None) {
            texture = TextureLibrary.Texture(textureType)
            material.useTexture = true
        }
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
        
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Rigged))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Basic))
        renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)

        renderCommandEncoder.setFragmentBytes(&material, length: Material.stride, index: 1)
        renderCommandEncoder.setFragmentBytes(lights,
                                              length: LightData.stride(lights.count),
                                              index: 2)
        if(material.useTexture){
            renderCommandEncoder.setFragmentSamplerState(SamplerStateLibrary.SamplerState(.Basic), index: 0)
            renderCommandEncoder.setFragmentTexture(texture, index: 0)
        }
        
        var lightCount = lights.count
        renderCommandEncoder.setFragmentBytes(&lightCount, length: Int.stride, index: 3)

        renderCommandEncoder.setTriangleFillMode(fillMode)
        mesh.drawPrimitives(renderCommandEncoder: renderCommandEncoder)

        renderCommandEncoder.popDebugGroup()
    }
}
