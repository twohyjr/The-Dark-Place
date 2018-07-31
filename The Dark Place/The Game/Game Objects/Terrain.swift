import MetalKit

class Terrain: GameObject {
    private var texture: MTLTexture!
    
    init(gridSize: Int, cellsWide: Int, cellsBack: Int, textureType: TextureTypes){
        super.init()
        self.texture = TextureLibrary.Texture(textureType)
        self.mesh = TerrainMeshGenerator.GenerateTerrainMesh(gridSize: gridSize,
                                                             cellsWide: cellsWide,
                                                             cellsBack: cellsBack)
        self.position.x -= Float(gridSize) / 2.0
        self.position.z -= Float(gridSize) / 2.0
        self.color = float3(0.7, 0.7, 0.7)
        self.material.shininess = 30
    }
    
    override func setRenderPipelineState() {
        renderPipelineState = RenderPipelineStateLibrary.PipelineState(.VillageTerrain)
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder, light: inout Light) {
        renderCommandEncoder.pushDebugGroup("Terrain Render Call")
        renderCommandEncoder.setRenderPipelineState(renderPipelineState)
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)
        renderCommandEncoder.setFragmentTexture(texture, index: 0)
        renderCommandEncoder.setFragmentBytes(&material, length: Material.stride, index: 1)
        renderCommandEncoder.setFragmentBytes(&light, length: Light.stride, index: 2)
        mesh.drawPrimitives(renderCommandEncoder: renderCommandEncoder)
        
        renderCommandEncoder.popDebugGroup()
    }
}
