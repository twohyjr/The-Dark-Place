import Cocoa
import simd

struct DebugCameraValues {
    var position = float3(0)
    var pitch: Float = 0.0
    var yaw: Float = 0.0
    var roll: Float = 0.0
    var aspectRatio: Float = 0.0
    var fov: Float = 0.0
    var near: Float = 0.0
    var far: Float = 0.0
}

class ViewController: NSViewController {

    @IBOutlet weak var txtCameraPosition: NSTextField!
    @IBOutlet weak var txtCameraPitch: NSTextField!
    @IBOutlet weak var txtCameraYaw: NSTextField!
    @IBOutlet weak var txtCameraRoll: NSTextField!
    @IBOutlet weak var txtCameraAspectRatio: NSTextField!
    @IBOutlet weak var txtCameraZoom: NSTextField!
    @IBOutlet weak var txtCameraNear: NSTextField!
    @IBOutlet weak var txtCameraFar: NSTextField!
    
    //Light Inputs
    @IBOutlet weak var sldLightValue1: NSSlider!
    @IBOutlet weak var sldLightValue2: NSSlider!
    @IBOutlet weak var sldLightValue3: NSSlider!
    @IBOutlet weak var txtLightValue1: NSTextField!
    @IBOutlet weak var txtLightValue2: NSTextField!
    @IBOutlet weak var txtLightValue3: NSTextField!
    
    @IBOutlet weak var mtkGameView: GameView!
    var debugCameraValues = DebugCameraValues()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mtkGameView.setControllers(debugViewController: self)
        DebugSettings.lightValue1 = sldLightValue1.floatValue
        DebugSettings.lightValue2 = sldLightValue2.floatValue
        DebugSettings.lightValue3 = sldLightValue3.floatValue
        txtLightValue1.stringValue = String(format: "%.2f", DebugSettings.lightValue1)
        txtLightValue2.stringValue = String(format: "%.2f", DebugSettings.lightValue2)
        txtLightValue3.stringValue = String(format: "%.2f", DebugSettings.lightValue3)
        sldLightValue1.floatValue = DebugSettings.lightValue1
        sldLightValue2.floatValue = DebugSettings.lightValue2
        sldLightValue3.floatValue = DebugSettings.lightValue3
        
    }
    
    public func updateDebugCameraValues(_ debugCameraValues: DebugCameraValues){
        self.debugCameraValues = debugCameraValues
        txtCameraPosition.stringValue = debugCameraValues.position.toSimpleString
        txtCameraPitch.stringValue = debugCameraValues.pitch.toString2d
        txtCameraYaw.stringValue = debugCameraValues.yaw.toString2d
        txtCameraRoll.stringValue = debugCameraValues.roll.toString2d
        txtCameraAspectRatio.stringValue = debugCameraValues.aspectRatio.toString2d
        txtCameraZoom.stringValue = debugCameraValues.fov.toString2d
        txtCameraNear.stringValue = debugCameraValues.near.toString2d
        txtCameraFar.stringValue = debugCameraValues.far.toString2d
        
    }
    
    var currentCameraValue: Int = 0
    @IBAction func btnPrintCameraPressed(_ sender: NSButton) {
        print("")
        print("//------Start Camera (\(currentCameraValue)) Values------\\")
        print("position: \(debugCameraValues.position.toSimpleString)")
        print("pitch: \(debugCameraValues.pitch.toString2d)")
        print("yaw: \(debugCameraValues.yaw.toString2d)")
        print("roll: \(debugCameraValues.roll.toString2d)")
        print("aspect ratio: \(debugCameraValues.aspectRatio.toString2d)")
        print("fov: \(debugCameraValues.fov.toString2d)")
        print("near: \(debugCameraValues.near.toString2d)")
        print("far: \(debugCameraValues.far.toString2d)")
        print("\\------End Camera (\(currentCameraValue++)) Values------//")
    }
    
    
    @IBAction func sldLightValue1_Changed(_ sender: NSSlider) {
        let value: Float = sender.floatValue
        txtLightValue1.stringValue =  String(format: "%.2f", value)
        DebugSettings.lightValue1 = value
    }
    
    @IBAction func sldLightValue2_Changed(_ sender: NSSlider) {
        let value: Float = sender.floatValue
        txtLightValue2.stringValue =  String(format: "%.2f", value)
        DebugSettings.lightValue2 = value
    }
    
    @IBAction func sldLightValue3_Changed(_ sender: NSSlider) {
        let value: Float = sender.floatValue
        txtLightValue3.stringValue =  String(format: "%.2f", value)
        DebugSettings.lightValue3 = value
    }
    
    @IBAction func btnPrintLightValues(_ sender: NSButton) {
        DebugSettings.printLightValues()
    }
}
