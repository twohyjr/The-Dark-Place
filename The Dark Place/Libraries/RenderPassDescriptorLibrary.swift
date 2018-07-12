import MetalKit

enum RenderPassDescriptorTypes {
    case Main
}

class RenderPassDescriptorLibrary{
    
    private static var _renderPassDescriptors: [RenderPassDescriptorTypes : RenderPassDescriptor] = [:]
    
    public static func Initialize(){
        createDefaultRPDs()
    }
    
    private static func createDefaultRPDs(){
        _renderPassDescriptors.updateValue(MainRenderPassDescriptor(), forKey: .Main)
    }
    
    public static func RenderPassDescriptor(_ renderPassDescriptorType: RenderPassDescriptorTypes)->MTLRenderPassDescriptor{
        return (_renderPassDescriptors[renderPassDescriptorType]?.renderPassDescriptor)!
    }
    
    public static func UpdateViewSize(_ size: Size){
        TextureLibrary.UpdateMainFrameBufferTexture(size: size)
        _renderPassDescriptors.updateValue(MainRenderPassDescriptor(), forKey: .Main)
    }
}

protocol RenderPassDescriptor {
    var renderPassDescriptor: MTLRenderPassDescriptor! { get }
}

class MainRenderPassDescriptor: RenderPassDescriptor {
    var renderPassDescriptor: MTLRenderPassDescriptor!
    
    init() {
        self.renderPassDescriptor = MTLRenderPassDescriptor()
        self.renderPassDescriptor.colorAttachments[0].texture = TextureLibrary.Texture(.MainFrameBuffer)
    }
}
