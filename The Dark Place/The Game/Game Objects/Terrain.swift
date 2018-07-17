import MetalKit

class Terrain: GameObject {
    
    init(gridSize: Int, cellsWide: Int, cellsBack: Int){
        super.init()
        self.mesh = TerrainMeshGenerator.GenerateTerrainMesh(gridSize: gridSize,
                                                             cellsWide: cellsWide,
                                                             cellsBack: cellsBack)
        self.position.x -= Float(gridSize / 2)
        self.position.z -= Float(gridSize / 2)
        self.material.color = float4(0.7, 0.7, 0.7, 1.0)
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.VillageTerrain))
        renderCommandEncoder.setFragmentTexture(TextureLibrary.Texture(.CartoonGrass), index: 0)
        renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)
        renderCommandEncoder.setVertexBuffer(mesh.vertexBuffer, offset: 0, index: 0)
        mesh.drawPrimitives(renderCommandEncoder: renderCommandEncoder)
    }
}
