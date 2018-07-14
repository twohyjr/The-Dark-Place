import MetalKit

class VillageTerrain: GameObject {
    
    var terrain: Terrain!
    override init(){
        super.init(meshType: .Cube_Custom)
        terrain = Terrain(gridSize: 10, cellsWide: 50, cellsBack: 50)
        addChild(terrain)
    }
    

    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setTriangleFillMode(.lines)
        super.render(renderCommandEncoder: renderCommandEncoder)
    }
}
