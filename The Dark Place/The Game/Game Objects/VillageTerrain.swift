import MetalKit

class VillageTerrain: GameObject {
    
    var terrain: Terrain!
    override init(){
        super.init(meshType: .Cube_Custom)
        terrain = Terrain(gridSize: 10, cellsWide: 50, cellsBack: 50)
        terrain.position.y = 0.2503
        terrain.position.x = -5
        terrain.position.z = -5
        addChild(terrain)
        self.scale = float3(1,0.05,1) * 5
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setTriangleFillMode(.fill)
        super.render(renderCommandEncoder: renderCommandEncoder)
    }
}
