import MetalKit

struct WorldData {
    var worldWidth: Int = 0
    var worldHeight: Int = 0
    var objects: [Node] = []
}

class WorldGenerator {
    
    var terrainMesh: CustomMesh!
    
    public static func getWorldData(itemPlacementMapName: String = "")->WorldData {
        var worldData = WorldData()
        if(itemPlacementMapName != ""){
            let url: URL = Bundle.main.url(forResource: "\(itemPlacementMapName).png", withExtension: nil)!
            let image = NSImage(contentsOf: url)
            let bmp = image?.representations[0] as! NSBitmapImageRep
            let imageHeight = Int(bmp.pixelsHigh)
            let imageWidth = Int(bmp.pixelsWide)
            worldData.worldWidth = imageWidth
            worldData.worldHeight = imageHeight
            for z in 0..<imageHeight{
                for x in 0..<imageWidth {
                    var trueX = x
                    var trueZ = z
                    if(trueX >= imageHeight){
                        trueX = imageHeight - 1
                    }
                    if(trueZ >= imageHeight){
                        trueZ = imageHeight - 1
                    }
                    let color = float4(Float((bmp.colorAt(x: x, y: z)?.redComponent)!),
                                       Float((bmp.colorAt(x: x, y: z)?.greenComponent)!),
                                       Float((bmp.colorAt(x: x, y: z)?.blueComponent)!),
                                       Float((bmp.colorAt(x: x, y: z)?.alphaComponent)!))
                    let posX =  Float((imageWidth / 2) + x) - Float(imageWidth)
                    let posZ = Float((imageHeight / 2) + z) - Float(imageHeight)
                    
                    let object = getObjectNode(color)
                    if(object != nil){
                        object?.position.x = posX
                        object?.position.z = posZ
                        worldData.objects.append(object!)
                    }
                }
            }
        }

        return worldData
    }
    
    private static func getObjectNode(_ color: float4)->Node?{
        let fullColor = color * 255
        var result: Node! = nil
        
        if(fullColor == ObjectValues.Mushroom){
            result = RedMushroom()
        }
        
        if(fullColor == ObjectValues.LargeGreenOak){
            result = LargeGreenOak()
        }
        
        return result
    }
}

struct ObjectValues {
    static let Mushroom = float4(255,0,0,255)
    static let LargeGreenOak = float4(0,255,0,255)
}

enum ObjectTypes {
    case None
    case Mushroom
    case LargeGreenOak
}
