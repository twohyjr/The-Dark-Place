import MetalKit

class Engine {
    
    private static var _commandQueue: MTLCommandQueue!
    public static var CommandQueue: MTLCommandQueue { return _commandQueue }
    
    private static var _device: MTLDevice!
    public static var Device: MTLDevice { return _device }
    
    public static func Initialize(_ device: MTLDevice){
        self._device = device
        self._commandQueue = device.makeCommandQueue()
        
        self.initializeLibraries()
        self.initializeManagers()
    }
    
    private static func initializeLibraries(){
        
        ShaderLibrary.Initialize()
        
        VertexDescriptorLibrary.Intialize()

        RenderPipelineStateLibrary.Initialize()
        
        MeshLibrary.Initialize()
        
    }
    
    private static func initializeManagers(){
        SceneManager.Initialize(.VillageScene)
    }
    
}
