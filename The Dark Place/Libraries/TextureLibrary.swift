import MetalKit

enum TextureTypes {
    case None
    case CartoonGrass
    case CartoonSand
    case Cowboy
}

class TextureLibrary {
    
    private static var meshes: [TextureTypes:Texture] = [:]
    
    public static func Initialize(){
        createDefaultTextures()
    }
    
    private static func createDefaultTextures(){
        meshes.updateValue(FileTexture("cartoon_grass.png"), forKey: .CartoonGrass)
        meshes.updateValue(FileTexture("cartoon_sand.png"), forKey: .CartoonSand)
        meshes.updateValue(FileTexture("cowboy.png"), forKey: .Cowboy)
    }
    
    public static func Texture(_ textureType: TextureTypes)->MTLTexture{
        return meshes[textureType]!.mtlTexture
    }
}

protocol Texture {
    var mtlTexture: MTLTexture! { get }
}

struct FileTexture: Texture {
    var mtlTexture: MTLTexture!
    
    init(_ imageName: String){
        self.mtlTexture = TextureLoader.Load(imageName: imageName)
    }
}

class TextureLoader{
    
    public static func Load(imageName: String)->MTLTexture!{
        var texture: MTLTexture! = nil
        if(imageName != ""){
            let textureLoader = MTKTextureLoader(device: Engine.Device)
            let url = Bundle.main.url(forResource: imageName, withExtension: nil)
            
            //Put options on the image here
            let originOption = [MTKTextureLoader.Option.origin:MTKTextureLoader.Origin.bottomLeft]
            
            do{
                texture = try textureLoader.newTexture(URL: url!, options: originOption)
            }catch let textureLoadError as NSError{
                print("ERROR::TEXTURE_LOADING::\(textureLoadError)")
            }
        }
        return texture
    }
    
}








