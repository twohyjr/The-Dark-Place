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
    
    public func doRotationX(_ rotationX: Float){
        self._rotation.x += rotationX
    }
    
    public func doRotationY(_ rotationY: Float){
        self._rotation.y += rotationY
    }
    
    public func doRotationZ(_ rotationZ: Float){
        self._rotation.z += rotationZ
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

    func addChild(_ child: Node){
        children.append(child)
    }
    
    func update(deltaTime: Float){
        for child in children{
            child.update(deltaTime: deltaTime)
        }
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder, lights: inout [LightData]){
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder, lights: &lights)
        }

        if let renderable = self as? Renderable {
            renderable.doRender(renderCommandEncoder, lights: &lights)
        }
    }
    
}
