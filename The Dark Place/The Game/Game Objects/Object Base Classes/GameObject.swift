import MetalKit

class GameObject: Node {
    var mesh: CustomMesh!
    var material = Material()
    
    init(meshType: CustomMeshTypes) {
        super.init()
        mesh = MeshLibrary.Mesh(meshType)
    }
    
    override init(){
        super.init()
    }
}

extension GameObject: Renderable{
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.pushDebugGroup("Game Object Render Call")
        
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Basic))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Basic))
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        
        renderCommandEncoder.setFragmentBytes(&material, length: Material.stride, index: 1)

        mesh.drawPrimitives(renderCommandEncoder: renderCommandEncoder)
        
        renderCommandEncoder.popDebugGroup()
    }
}

//Material Getters / Setters
extension GameObject {
    func setColor(_ colorValue: float4){ self.material.color = colorValue }
    func getColor()->float4{ return self.material.color }
    
    func setAmbient(_ ambientValue: float3){ self.material.ambient = ambientValue }
    func getAmbient()->float3 { return self.material.ambient }
    
    func setDiffuse(_ diffuseValue: float3){ self.material.diffuse = diffuseValue }
    func getDiffuse()->float3 { return self.material.diffuse }

    func setShininess(_ shininessValue: Float){  self.material.shininess = shininessValue }
    func getShininess()->Float { return self.material.shininess }

    func setSpecular(_ specularValue: float3){ self.material.specular = specularValue }
    func getSpecular()->float3{ return self.material.specular }
}
