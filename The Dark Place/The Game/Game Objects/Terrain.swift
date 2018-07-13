import MetalKit

class Terrain: GameObject {
    
    init(gridSize: Int, cellsWide: Int, cellsBack: Int){
        super.init()
        self.mesh = TerrainMeshGenerator.GenerateTerrainMesh(gridSize: gridSize,
                                                             cellsWide: cellsWide,
                                                             cellsBack: cellsBack)
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setTriangleFillMode(.lines)
        super.render(renderCommandEncoder: renderCommandEncoder)
    }
    
}
