import MetalKit

enum CameraTypes {
    case Debug
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

public class Debug_Camera: Camera {
    var position: float3 = float3(3.75, 3.5, 10.06)
    var pitch: Float = 0.34
    var yaw: Float = -0.46
    var roll: Float = 0
    
    var speed: Float = 5
    var cameraType: CameraTypes = CameraTypes.Debug
    
    private var _projectionMatrix = matrix_identity_float4x4
    var projectionMatrix: matrix_float4x4 {
        if(View.ShouldUpdateViewValues){
            _projectionMatrix = matrix_float4x4.init(perspectiveDegreesFov: 45,
                                                     aspectRatio: View.AspectRatio,
                                                     nearZ: 0.1,
                                                     farZ: 1000)
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
            self.pitch += Mouse.GetDY() * 0.02
            self.yaw += Mouse.GetDX() * 0.02
        }
    }
}


