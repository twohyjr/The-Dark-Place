import MetalKit

class Node {
    public var name: String = ""
    
    private var _position: float3 = float3(0)
    private var _scale: float3 = float3(1)
    private var _rotation: float3 = float3(0)

    var modelConstants = ModelConstants()
    
    private var fillMode: MTLTriangleFillMode = .fill
    public var parentModelMatrix = matrix_identity_float4x4
    
    var modelMatrix: matrix_float4x4{
        var modelMatrix = matrix_identity_float4x4
        modelMatrix.translate(direction: _position)
        modelMatrix.quaternionRotate(rotation: _rotation)
        modelMatrix.scale(axis: _scale)
        return matrix_multiply(parentModelMatrix, modelMatrix)
    }
    
    var children: [Node] = []

    func addChild(_ child: Node){
        children.append(child)
    }
    
    func lineModeOn(_ isOn: Bool){
        self.fillMode = isOn ? MTLTriangleFillMode.lines : MTLTriangleFillMode.fill
    }
    
    private func updateModelConstants(){
        modelConstants.modelMatrix = self.modelMatrix
        modelConstants.normalMatrix = self.modelMatrix.upperLeftMatrix
    }
    
    func update(deltaTime: Float){
        for child in children{
            child.parentModelMatrix = self.modelMatrix
            child.update(deltaTime: deltaTime)
        }
        
        updateModelConstants()
    }
    
    func render(renderCommandEncoder: MTLRenderCommandEncoder){
        if(name != String.Empty){
            renderCommandEncoder.pushDebugGroup("Rendering \(name)")
        }
        
        for child in children{
            child.render(renderCommandEncoder: renderCommandEncoder)
        }

        if let renderable = self as? Renderable {
            renderCommandEncoder.setTriangleFillMode(fillMode)
            renderCommandEncoder.setVertexBytes(&modelConstants, length: ModelConstants.stride, index: 2)
            renderable.doRender(renderCommandEncoder)
        }
        
        if(name != String.Empty){
            renderCommandEncoder.popDebugGroup()
        }
        
    }
    
}

extension Node {
    //Positioning and Movement
    func setPosition(_ position: float3){ self._position = position }
    func setPositionX(_ xPosition: Float) { self._position.x = xPosition }
    func setPositionY(_ yPosition: Float) { self._position.y = yPosition }
    func setPositionZ(_ zPosition: Float) { self._position.z = zPosition }
    func getPosition()->float3 { return self._position }
    func getPositionX()->Float { return self._position.x }
    func getPositionY()->Float { return self._position.y }
    func getPositionZ()->Float { return self._position.z }
    func moveX(_ delta: Float){ self._position.x += delta }
    func moveY(_ delta: Float){ self._position.y += delta }
    func moveZ(_ delta: Float){ self._position.z += delta }
    
    //Rotating
    func setRotation(_ rotation: float3) { self._rotation = rotation }
    func setRotationX(_ xRotation: Float) { self._rotation.x = xRotation }
    func setRotationY(_ yRotation: Float) { self._rotation.y = yRotation }
    func setRotationZ(_ zRotation: Float) { self._rotation.z = zRotation }
    func getRotation()->float3 { return self._rotation }
    func getRotationX()->Float { return self._rotation.x }
    func getRotationY()->Float { return self._rotation.y }
    func getRotationZ()->Float { return self._rotation.z }
    func rotateX(_ delta: Float){ self._rotation.x += delta }
    func rotateY(_ delta: Float){ self._rotation.y += delta }
    func rotateZ(_ delta: Float){ self._rotation.z += delta }
    
    //Scaling
    func setScale(_ scale: float3){ self._scale = scale }
    func setScale(_ scale: Float){setScale(float3(scale))}
    func setScaleX(_ scaleX: Float){ self._scale.x = scaleX }
    func setScaleY(_ scaleY: Float){ self._scale.y = scaleY }
    func setScaleZ(_ scaleZ: Float){ self._scale.z = scaleZ }
    func getScale()->float3 { return self._scale }
    func getScaleX()->Float { return self._scale.x }
    func getScaleY()->Float { return self._scale.y }
    func getScaleZ()->Float { return self._scale.z }
    func scaleX(_ delta: Float){ self._scale.x += delta }
    func scaleY(_ delta: Float){ self._scale.y += delta }
    func scaleZ(_ delta: Float){ self._scale.z += delta }
}
