import MetalKit

enum CameraTypes {
    case Debug
    case Drag
}

class CameraManager {
    
    private var _cameras: [CameraTypes: Camera] = [:]
    private var _currentCamera: Camera!
    
    public var CurrentCamera: Camera! {
        if (_currentCamera != nil) {
            return _currentCamera
        }
        return nil
    }
    
    public func setCamera(_ cameraType: CameraTypes){
        _currentCamera = _cameras[cameraType]
    }
    
    func registerCamera(_ camera: Camera){
        _cameras.updateValue(camera, forKey: camera.cameraType)
    }
    
    func updateCameras(deltaTime: Float){
        for camera in _cameras.values {
            camera.update(deltaTime: deltaTime)
        }
    }
    
}

class Camera: Node {
    var cameraType: CameraTypes
    internal var _debugCameraValues = DebugCameraValues()
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
    public func setPitch(_ value: Float){
        self._pitch = value
    }
    
    public func getPitch()->Float{
        return _pitch
    }
    
    public func doPitch(_ delta: Float){
        self._pitch += delta
    }
    
    //Yaw
    public func setYaw(_ value: Float){
        self._yaw = value
    }
    
    public func getYaw()->Float{
        return _yaw
    }
    
    public func doYaw(_ delta: Float){
        self._yaw += delta
    }
    
    //Roll
    public func setRoll(_ value: Float){
        self._roll = value
    }
    
    public func getRoll()->Float{
        return self._roll
    }
    
    public func doRoll(_ delta: Float){
        self._roll += delta
    }
    
    override func update(deltaTime: Float) {
        
        self.updateDebugCameraValues()
        
        super.update(deltaTime: deltaTime)
    }
    
    //Debug
    public var debugCameraValues: DebugCameraValues {
        return self._debugCameraValues
    }
    
    public func updateDebugCameraValues(){
        self._debugCameraValues.position = self.getPosition()
        self._debugCameraValues.pitch = self.getPitch()
        self._debugCameraValues.roll = self.getRoll()
        self._debugCameraValues.yaw = self.getYaw()
    }
}

class DebugCamera: Camera {
    
    var zoom: Float = 45
    var speed: Float = 1
    var near: Float = 0.1
    var far: Float = 1000.0
    
    private var aspectRatio: Float {
        return View.AspectRatio
    }
    
    private var _projectionMatrix = matrix_identity_float4x4
    override var projectionMatrix: matrix_float4x4 {
        if(View.ShouldUpdateViewValues){
            _projectionMatrix = matrix_float4x4.perspective(degreesFov: self.zoom,
                                                            aspectRatio: self.aspectRatio,
                                                            near: self.near,
                                                            far: self.far)
        }
        return _projectionMatrix
    }
    
    init(){
        super.init(.Debug)
    }
    
    override func updateDebugCameraValues() {
        self._debugCameraValues.fov = zoom
        self._debugCameraValues.near = near
        self._debugCameraValues.far = far
        self._debugCameraValues.aspectRatio = self.aspectRatio
        super.updateDebugCameraValues()
    }
    
    override func update(deltaTime: Float) {
        if(Mouse.IsMouseButtonPressed(button: .left)){
            self.doPitch(Mouse.GetDY() * 0.002)
            self.doYaw(Mouse.GetDX() * 0.002)
        }
        
        let dWheel = Mouse.GetDWheel() * 0.5
        if(self.zoom + dWheel < 47 && self.zoom + dWheel > 10) {
            self.zoom += dWheel
        }

        super.update(deltaTime: deltaTime)
    }
    
}
