import MetalKit

class Node {
    
    private var _position: float3 = float3(0)
    private var _scale: float3 = float3(1)
    private var _rotation: float3 = float3(0)
    
    public func setPosition(_ position: float3){
        self._position = position
    }
    
    public func setPositionX(_ xPosition: Float){
        self._position.x = xPosition
    }
    
    public func setPositionY(_ yPosition: Float){
        self._position.y = yPosition
    }
    
    public func setPositionZ(_ zPosition: Float){
        self._position.z = zPosition
    }
    
    
    public func setRotation(_ rotation: float3){
        self._rotation = rotation
    }
    
    //Scaling
    public func setScale(_ scale: float3){
        self._scale = scale
    }

    public func getScale()->float3{
        return self._scale
    }
    
    public func setScale(_ value: Float){
        self._scale = float3(value)
    }
    
    public func scaleX(_ value: Float){
        self._scale.x += value
    }
    
    public func scaleY(_ value: Float){
        self._scale.y += value
    }
    
    public func scaleZ(_ value: Float){
        self._scale.z += value
    }
    
    //Rotation
    public func getRotation()->float3{
        return self._rotation
    }
    
    //Positioning
    public func getPosition()->float3{
        return self._position
    }
    
    public func moveX(_ value: Float){
        self._position.x += value
    }
    
    public func moveY(_ value: Float){
        self._position.y += value
    }
    
    public func moveZ(_ value: Float){
        self._position.z += value
    }
    
    var modelMatrix: matrix_float4x4{
        var modelMatrix = matrix_identity_float4x4
        modelMatrix.translate(direction: _position)
        modelMatrix.rotate(angle: _rotation.x, axis: X_AXIS)
        modelMatrix.rotate(angle: _rotation.y, axis: Y_AXIS)
        modelMatrix.rotate(angle: _rotation.z, axis: Z_AXIS)
        modelMatrix.scale(axis: _scale)
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
