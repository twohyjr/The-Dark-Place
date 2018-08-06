import MetalKit

struct WorldData {
    var worldWidth: Int = 0
    var worldDepth: Int = 0
    var worldItems: [Node] = []
}

struct WorldItemValues {
    static let Mushroom = float4(1,0,0,1)
    static let LargeGreenOak = float4(0,1,0,1)
}

class WorldGenerator {

    public static func GetWorldData(itemMapName: String, terrainHeightMap: String)->WorldData {
        var worldData = WorldData()
        let bmp = NSImage.getBitmapFromResource(resourceName: itemMapName)
        worldData.worldWidth = bmp.pixelsWide
        worldData.worldDepth = bmp.pixelsHigh
        for z in 0..<worldData.worldDepth{
            for x in 0..<worldData.worldWidth {
                let color = float4(Float((bmp.colorAt(x: x, y: z)?.redComponent)!),
                                   Float((bmp.colorAt(x: x, y: z)?.greenComponent)!),
                                   Float((bmp.colorAt(x: x, y: z)?.blueComponent)!),
                                   Float((bmp.colorAt(x: x, y: z)?.alphaComponent)!))
                let posX =  Float((worldData.worldWidth / 2) + x) - Float(worldData.worldWidth)
                let posZ = Float((worldData.worldDepth / 2) + z) - Float(worldData.worldDepth)
                let object = getObjectNode(color)
                if(object != nil){
                    object?.position.x = posX
                    object?.position.z = posZ
                    worldData.worldItems.append(object!)
                }
            }
        }
        return worldData
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


