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
    
    //Value Slider Inputs
    @IBOutlet weak var txtValue1: NSTextField!
    @IBOutlet weak var txtValue2: NSTextField!
    @IBOutlet weak var txtValue3: NSTextField!
    @IBOutlet weak var txtValue4: NSTextField!
    @IBOutlet weak var txtValue5: NSTextField!
    @IBOutlet weak var txtValue6: NSTextField!
    @IBOutlet weak var sldValue1: NSSlider!
    @IBOutlet weak var sldValue2: NSSlider!
    @IBOutlet weak var sldValue3: NSSlider!
    @IBOutlet weak var sldValue4: NSSlider!
    @IBOutlet weak var sldValue5: NSSlider!
    @IBOutlet weak var sldValue6: NSSlider!

    
    @IBOutlet weak var mtkGameView: GameView!
    var debugCameraValues = DebugCameraValues()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mtkGameView.setControllers(debugViewController: self)
        DebugSettings.value1 = sldValue1.floatValue
        DebugSettings.value2 = sldValue2.floatValue
        DebugSettings.value3 = sldValue3.floatValue
        DebugSettings.value4 = sldValue4.floatValue
        DebugSettings.value5 = sldValue5.floatValue
        DebugSettings.value6 = sldValue6.floatValue
        txtValue1.stringValue = String(format: "%.2f", DebugSettings.value1)
        txtValue2.stringValue = String(format: "%.2f", DebugSettings.value2)
        txtValue3.stringValue = String(format: "%.2f", DebugSettings.value3)
        txtValue4.stringValue = String(format: "%.2f", DebugSettings.value4)
        txtValue5.stringValue = String(format: "%.2f", DebugSettings.value5)
        txtValue6.stringValue = String(format: "%.2f", DebugSettings.value6)
        sldValue1.floatValue = DebugSettings.value1
        sldValue2.floatValue = DebugSettings.value2
        sldValue3.floatValue = DebugSettings.value3
        sldValue4.floatValue = DebugSettings.value4
        sldValue5.floatValue = DebugSettings.value5
        sldValue6.floatValue = DebugSettings.value6
        
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
    
    
    @IBAction func sldValue1_Changed(_ sender: NSSlider) {
        let value: Float = sender.floatValue
        txtValue1.stringValue =  String(format: "%.2f", value)
        DebugSettings.value1 = value
    }
    
    @IBAction func sldValue2_Changed(_ sender: NSSlider) {
        let value: Float = sender.floatValue
        txtValue2.stringValue =  String(format: "%.2f", value)
        DebugSettings.value2 = value
    }
    
    @IBAction func sldValue3_Changed(_ sender: NSSlider) {
        let value: Float = sender.floatValue
        txtValue3.stringValue =  String(format: "%.2f", value)
        DebugSettings.value3 = value
    }
    
    @IBAction func sldValue4_Changed(_ sender: NSSlider) {
        let value: Float = sender.floatValue
        txtValue4.stringValue =  String(format: "%.2f", value)
        DebugSettings.value4 = value
    }
    
    @IBAction func sldValue5_Changed(_ sender: NSSlider) {
        let value: Float = sender.floatValue
        txtValue5.stringValue =  String(format: "%.2f", value)
        DebugSettings.value5 = value
    }
    
    @IBAction func sldValue6_Changed(_ sender: NSSlider) {
        let value: Float = sender.floatValue
        txtValue6.stringValue =  String(format: "%.2f", value)
        DebugSettings.value6 = value
    }
    
    @IBAction func btnPrintValues(_ sender: NSButton) {
        DebugSettings.printValues()
    }
}
