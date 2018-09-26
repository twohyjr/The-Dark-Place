import MetalKit

class DebugCamera: Camera {
    
    var zoom: Float = 45
    var speed: Float = 1
    var near: Float = 0.1
    var far: Float = 1000.0
    
    internal var _debugCameraValues = DebugCameraValues()
    
    private var aspectRatio: Float { return View.AspectRatio }
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
    
    //Debug
    public var debugCameraValues: DebugCameraValues {
        return self._debugCameraValues
    }
    
    func updateDebugCameraValues() {
        self._debugCameraValues.fov = zoom
        self._debugCameraValues.near = near
        self._debugCameraValues.far = far
        self._debugCameraValues.aspectRatio = self.aspectRatio
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
        
        if(Keyboard.IsKeyPressed(.upArrow)){
            self.moveZ(-0.05)
        }
        if(Keyboard.IsKeyPressed(.downArrow)){
            self.moveZ(0.05)
        }
        if(Keyboard.IsKeyPressed(.leftArrow)){
            self.moveX(-0.05)
        }
        if(Keyboard.IsKeyPressed(.rightArrow)){
            self.moveX(0.05)
        }
        
        updateDebugCameraValues()
        super.update(deltaTime: deltaTime)
    }
    
}
