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
    
    func registerCamera(camera: Camera){
        _cameras.updateValue(camera, forKey: camera.cameraType)
    }
    
    func updateCameras(deltaTime: Float){
        for camera in _cameras.values {
            camera.update(deltaTime: deltaTime)
        }
    }
    
}

protocol Camera {
    var position: float3 { get set }
    var pitch: Float { get set }
    var yaw: Float { get set }
    var roll: Float { get set }
    var cameraType: CameraTypes { get }
    var projectionMatrix: matrix_float4x4 { get }
    func update(deltaTime: Float)
}
extension Camera {
    var viewMatrix: matrix_float4x4 {
        var viewMatrix = matrix_identity_float4x4
        
        viewMatrix.rotate(angle: self.pitch, axis: X_AXIS)
        viewMatrix.rotate(angle: self.yaw, axis: Y_AXIS)
        viewMatrix.rotate(angle: self.roll, axis: Z_AXIS)
        viewMatrix.translate(direction: -self.position)
        
        return viewMatrix
    }
}

public class Drag_Camera: Camera {
    var position: float3 = float3(0)
    
    var pitch: Float = 0
    
    var yaw: Float = 0
    
    var roll: Float = 0
    
    var cameraType: CameraTypes = CameraTypes.Drag
    var zoom: Float = 45
    var movementSpeed: Float = 4
    
    private var _projectionMatrix = matrix_identity_float4x4
    var projectionMatrix: matrix_float4x4 {
        if(View.ShouldUpdateViewValues){
            _projectionMatrix = matrix_float4x4.perspective(degreesFov: zoom,
                                                            aspectRatio: View.AspectRatio,
                                                            near: 0.1,
                                                            far: 1000)
        }
        return _projectionMatrix
    }
    
    func update(deltaTime: Float) {
        
        //Dragging
        if(Mouse.IsMouseButtonPressed(button: .left)){
            self.position.x -= deltaTime * Mouse.GetDX() * 0.5
            self.position.y += deltaTime * Mouse.GetDY() * 0.5
        }
        
        //Zooming
        self.zoom += deltaTime * Mouse.GetDWheel() * 20
        
        //Rotation
        if(Mouse.IsMouseButtonPressed(button: .center)){
            self.yaw += Mouse.GetDX() * deltaTime * 0.6
            self.pitch += Mouse.GetDY() * deltaTime * 0.6
        }
        
        if(Keyboard.IsKeyPressed(.w)){
            self.position.z -= deltaTime * movementSpeed
        }
        
        if(Keyboard.IsKeyPressed(.s)){
            self.position.z += deltaTime * movementSpeed
        }
        
        if(Keyboard.IsKeyPressed(.a)){
            self.position.x += deltaTime * movementSpeed
        }
        
        if(Keyboard.IsKeyPressed(.d)){
            self.position.x -= deltaTime * movementSpeed
        }
    }
    
    
}

public class Debug_Camera: Camera {
    var position: float3 = float3(0)
    var pitch: Float = 0.48
    var yaw: Float = 0
    var roll: Float = 0
    
    var speed: Float = 20
    var cameraType: CameraTypes = CameraTypes.Debug
    var zoom: Float = 45
    
    private var _projectionMatrix = matrix_identity_float4x4
    var projectionMatrix: matrix_float4x4 {
        if(View.ShouldUpdateViewValues){
            _projectionMatrix = matrix_float4x4.perspective(degreesFov: zoom,
                                                            aspectRatio: View.AspectRatio,
                                                            near: 0.1,
                                                            far: 1000)
        }
        return _projectionMatrix
    }
    
    func update(deltaTime: Float) {
        if(Keyboard.IsKeyPressed(.upArrow)){
            self.position.z -= deltaTime * speed
        }
        
        if(Keyboard.IsKeyPressed(.downArrow)){
            self.position.z += deltaTime * speed
        }
        
        if(Keyboard.IsKeyPressed(.rightArrow)){
            self.position.x += deltaTime * speed
        }
        
        if(Keyboard.IsKeyPressed(.leftArrow)){
            self.position.x -= deltaTime * speed
        }
        
        if(Keyboard.IsKeyPressed(.s)){
            self.position.y -= deltaTime * speed
        }
        
        if(Keyboard.IsKeyPressed(.w)){
            self.position.y += deltaTime * speed
        }
        
        if(Mouse.IsMouseButtonPressed(button: .left)){
            self.pitch += Mouse.GetDY() * 0.002
            self.yaw += Mouse.GetDX() * 0.002
        }
        
        let dWheel = Mouse.GetDWheel() * 0.5
        if(self.zoom + dWheel < 47 && self.zoom + dWheel > 10) {
            self.zoom += dWheel
        }
    }
}


