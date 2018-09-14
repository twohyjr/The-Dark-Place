import MetalKit

class Terrain: Node {
    private var texture: MTLTexture!
    private var mesh: CustomMesh!
    var material = Material()

    init(gridSize: Int, terrainData: TerrainData, textureType: TextureTypes, name: String = String.Empty){
        super.init()
        self.name = name
        self.texture = TextureLibrary.Texture(textureType)
        self.mesh = TerrainMeshGenerator.GenerateTerrainMesh(gridSize: gridSize,
                                                              terrainData: terrainData)
        self.moveX(-(Float(gridSize) / 2.0))
        self.moveZ(-(Float(gridSize) / 2.0))
    }
}

extension Terrain: Renderable{
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.VillageTerrain))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Basic))
        
        renderCommandEncoder.setFragmentSamplerState(SamplerStateLibrary.SamplerState(.Basic), index: 0)
        renderCommandEncoder.setFragmentTexture(texture, index: 0)
        renderCommandEncoder.setFragmentBytes(&material, length: Material.stride, index: 1)
        
        mesh.drawPrimitives(renderCommandEncoder: renderCommandEncoder)
    }
}

