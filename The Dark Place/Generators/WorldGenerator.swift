import MetalKit

struct WorldData {
    var itemData: ItemData!
}

struct ItemData{
    var worldItems: [Node] = []
    var width: Int = 0
    var depth: Int = 0
}

struct WorldItemValues {
    static let Mushroom = float4(1,0,0,1)
    static let LargeGreenOak = float4(0,1,0,1)
}

class WorldGenerator {

    public static func GetWorldData(itemMapName: String, terrainHeightMap: String)->WorldData {
        var worldData = WorldData()
        
        worldData.itemData = getWorldItems(itemMapName)
        
        return worldData
    }
    
    private static func getWorldItems(_ itemMapName: String)->ItemData{
        var result = ItemData()
        let bmp = NSImage.getBitmapFromResource(resourceName: itemMapName)
        let wide = bmp.pixelsWide
        let depth = bmp.pixelsHigh
        result.width = wide
        result.depth = depth
        for z in 0..<depth{
            for x in 0..<wide {
                let color = float4(Float((bmp.colorAt(x: x, y: z)?.redComponent)!),
                                   Float((bmp.colorAt(x: x, y: z)?.greenComponent)!),
                                   Float((bmp.colorAt(x: x, y: z)?.blueComponent)!),
                                   Float((bmp.colorAt(x: x, y: z)?.alphaComponent)!))
                let posX =  Float((wide / 2) + x) - Float(wide)
                let posZ = Float((depth  / 2) + z) - Float(depth)
                let object = getObjectNode(color)
                if(object != nil){
                    object?.position.x = posX
                    object?.position.z = posZ
                    result.worldItems.append(object!)
                }
            }
        }
        return result
    }
    
    private static func getObjectNode(_ color: float4)->Node?{
        var result: Node! = nil
        if(color == WorldItemValues.Mushroom){
            result = RedMushroom()
        }
        
        if(color == WorldItemValues.LargeGreenOak){
            result = LargeGreenOak()
        }
        
        return result
    }
}


