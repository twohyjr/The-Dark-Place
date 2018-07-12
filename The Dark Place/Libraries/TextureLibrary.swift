import MetalKit

enum TextureTypes {
    case MainFrameBuffer
}

class TextureLibrary {
    
    private static var _textures: [TextureTypes : Texture] = [:]
    
    public static func Initialize(){
        createDefaults()
    }
    
    private static func createDefaults(){
        _textures.updateValue(MainFrameBufferTexture(width: View.ScreenWidth,
                                                     height: View.ScreenHeight),
                              forKey: .MainFrameBuffer)
    }
    
    public static func Texture(_ textureType: TextureTypes)->MTLTexture{
        return _textures[textureType]!.texture
    }
    
    public static func UpdateMainFrameBufferTexture(size: Size){
        _textures.updateValue(MainFrameBufferTexture(width: size.getWidth(),
                                                     height: size.getHeight()),
                              forKey: .MainFrameBuffer)
    }
    
}

protocol Texture {
    var texture: MTLTexture { get }
}

class MainFrameBufferTexture: Texture {
    var texture: MTLTexture
    
    init(width: Float, height: Float) {
        let texDesc = MTLTextureDescriptor()
        texDesc.width =  Int(width)
        texDesc.height =  Int(height)
        texDesc.depth = 1
        texDesc.textureType = MTLTextureType.type2D
        
        texDesc.usage = [MTLTextureUsage.renderTarget, MTLTextureUsage.shaderRead]
        texDesc.storageMode = .private
        texDesc.pixelFormat = .bgra8Unorm
        texture = Engine.Device.makeTexture(descriptor: texDesc)!
    }
}
