import MetalKit

class Terrain: GameObject {
    private var texture: MTLTexture!

    init(gridSize: Int, terrainData: TerrainData, textureType: TextureTypes){
        super.init()
        self.texture = TextureLibrary.Texture(textureType)
        self.mesh = TerrainMeshGenerator.GenerateTerrainMesh(gridSize: gridSize,
                                                              terrainData: terrainData)
        self.moveX(-(Float(gridSize) / 2.0))
        self.moveZ(-(Float(gridSize) / 2.0))
    }

    override func render(renderCommandEncoder: MTLRenderCommandEncoder, lights: inout [LightData]) {
        renderCommandEncoder.pushDebugGroup("Terrain Render Call")
        
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.VillageTerrain))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Basic))
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.setFragmentSamplerState(SamplerStateLibrary.SamplerState(.Basic), index: 0)
        renderCommandEncoder.setFragmentTexture(texture, index: 0)
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

