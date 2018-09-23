import MetalKit

class AnimatedGameObject: Node {
    
    private var mesh: RiggedModelMesh!

    //Skin
    var material = Material()
    var texture: MTLTexture!
    


    
    init(riggedMeshType: RiggedMeshTypes,  textureType: TextureTypes = TextureTypes.None, name: String = String.Empty){
        super.init()
        self.name = name
        self.mesh = RiggedMeshLibrary.Mesh(riggedMeshType)
        if(textureType != TextureTypes.None) {
            texture = TextureLibrary.Texture(textureType)
            material.useTexture = true
        }
    }
    
    func getRootJoint()->Joint{
        return mesh.riggedMesh.rootJoint
    }

}

extension AnimatedGameObject: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Rigged))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Basic))
        renderCommandEncoder.setFragmentBytes(&material, length: Material.stride, index: 1)
        
        if(material.useTexture){
            renderCommandEncoder.setFragmentSamplerState(SamplerStateLibrary.SamplerState(.Basic), index: 0)
            renderCommandEncoder.setFragmentTexture(texture, index: 0)
        }
        
        mesh.drawPrimitives(renderCommandEncoder: renderCommandEncoder)
    }
}
