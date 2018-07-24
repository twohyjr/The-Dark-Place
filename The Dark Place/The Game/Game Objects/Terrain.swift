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
        self.material.diffuse = float3(0.7, 0.7, 0.7)
    }

    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.VillageTerrain))
        renderCommandEncoder.setFragmentBytes(&material, length: Material.stride, index: 1)
        renderCommandEncoder.setTriangleFillMode(fillMode)
        renderCommandEncoder.setFragmentTexture(texture, index: 0)
        renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        mesh.drawPrimitives(renderCommandEncoder: renderCommandEncoder)
    }
}
