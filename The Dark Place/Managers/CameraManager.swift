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
    var pitch: Float = 0
    var yaw: Float = 0
    var roll: Float = 0
    
    init(_ cameraType: CameraTypes){
        self.cameraType = cameraType
    }
    
    var projectionMatrix: matrix_float4x4 {
        return matrix_identity_float4x4
    }
    
    var viewMatrix: matrix_float4x4 {
        var viewMatrix = matrix_identity_float4x4
        
        viewMatrix.rotate(angle: self.pitch, axis: X_AXIS)
        viewMatrix.rotate(angle: self.yaw, axis: Y_AXIS)
        viewMatrix.rotate(angle: self.roll, axis: Z_AXIS)
        viewMatrix.translate(direction: -self.getPosition())
        
        return viewMatrix
    }
}

class DebugCamera: Camera {
    
    var zoom: Float = 45
    var speed: Float = 1
    
    private var _projectionMatrix = matrix_identity_float4x4
    override var projectionMatrix: matrix_float4x4 {
        if(View.ShouldUpdateViewValues){
            _projectionMatrix = matrix_float4x4.perspective(degreesFov: zoom,
                                                            aspectRatio: View.AspectRatio,
                                                            near: 0.1,
                                                            far: 1000)
        }
        return _projectionMatrix
    }
    
    init(){
        super.init(.Debug)
    }
    
    override func update(deltaTime: Float) {
//        if(Keyboard.IsKeyPressed(.upArrow)){
//            self.moveZ(-(deltaTime * speed))
//        }
//
//        if(Keyboard.IsKeyPressed(.downArrow)){
//            self.moveZ(deltaTime * speed)
//        }
//
//        if(Keyboard.IsKeyPressed(.rightArrow)){
//            self.moveX(deltaTime * speed)
//        }
//
//        if(Keyboard.IsKeyPressed(.leftArrow)){
//            self.moveX(-(deltaTime * speed))
//        }
//
//        if(Keyboard.IsKeyPressed(.s)){
//            self.moveY(-(deltaTime * speed))
//        }
//
//        if(Keyboard.IsKeyPressed(.w)){
//            self.moveY(deltaTime * speed)
//        }

        if(Mouse.IsMouseButtonPressed(button: .left)){
            self.pitch += Mouse.GetDY() * 0.002
            self.yaw += Mouse.GetDX() * 0.002
        }
        
        let dWheel = Mouse.GetDWheel() * 0.5
        if(self.zoom + dWheel < 47 && self.zoom + dWheel > 10) {
            self.zoom += dWheel
        }
        
        super.update(deltaTime: deltaTime)
    }
    
}
