import MetalKit

class BoundingBox: Node {
    var boundingBox: Mesh!
    var center: float3!
    init(mins: float3, maxs: float3){
        boundingBox = BoundingBoxMesh(mins: mins, maxs: maxs)
    }
    
    override func render(renderCommandEncoder: MTLRenderCommandEncoder) {
        
        super.render(renderCommandEncoder: renderCommandEncoder)
    }

}
