import MetalKit

class Camera: Node {
    var cameraType: CameraTypes
    private var _pitch: Float = 0
    private var _yaw: Float = 0
    private var _roll: Float = 0
    
    init(_ cameraType: CameraTypes){
        self.cameraType = cameraType
    }
    
    var projectionMatrix: matrix_float4x4 {
        return matrix_identity_float4x4
    }
    
    var viewMatrix: matrix_float4x4 {
        var viewMatrix = matrix_identity_float4x4
        
        viewMatrix.rotate(angle: self._pitch, axis: X_AXIS)
        viewMatrix.rotate(angle: self._yaw, axis: Y_AXIS)
        viewMatrix.rotate(angle: self._roll, axis: Z_AXIS)
        viewMatrix.translate(direction: -self.getPosition())
        
        return viewMatrix
    }
    
    //Pitch
    public func setPitch(_ value: Float){ self._pitch = value }
    public func getPitch()->Float{ return _pitch }
    public func doPitch(_ delta: Float){ self._pitch += delta }
    
    //Yaw
    public func setYaw(_ value: Float){ self._yaw = value }
    public func getYaw()->Float{ return _yaw }
    public func doYaw(_ delta: Float){ self._yaw += delta }
    
    //Roll
    public func setRoll(_ value: Float){ self._roll = value }
    public func getRoll()->Float{ return self._roll }
    public func doRoll(_ delta: Float){ self._roll += delta }
}
