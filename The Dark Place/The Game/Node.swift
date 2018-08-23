import MetalKit

class Node {
    
    var position: float3 = float3(0)
    var scale: float3 = float3(1)
    var rotation: float3 = float3(0)
    
    var modelMatrix: matrix_float4x4{
        var modelMatrix = matrix_identity_float4x4
        modelMatrix.translate(direction: position)
        modelMatrix.rotate(angle: rotation.x, axis: X_AXIS)
        modelMatrix.rotate(angle: rotation.y, axis: Y_AXIS)
        modelMatrix.rotate(angle: rotation.z, axis: Z_AXIS)
        modelMatrix.scale(axis: scale)
        return modelMatrix
    }
    
    var children: [Node] = []
    private var boundingRegions: [BoundingRegion] = []
    
    func addChild(_ child: Node){
        children.append(child)
    }
    
    func addBoundingRegion(_ boundingRegion: BoundingRegion){
        boundingRegions.append(boundingRegion)
    }
    
    func update(deltaTime: Float){
        for child in children{
            child.update(deltaTime: deltaTime)
        }
        
        for boundingRegion in boundingRegions {
            boundingRegion.update()
        }
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder, lights: inout [LightData]){
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder, lights: &lights)
        }
        
        for boundingRegion in boundingRegions {
            boundingRegion.render(renderCommandEncoder: renderCommandEncoder)
        }
        
        if let renderable = self as? Renderable {
            renderable.doRender(renderCommandEncoder, lights: &lights)
        }
    }
    
}
