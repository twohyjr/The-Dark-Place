import MetalKit

struct WorldData {
    var itemData: ItemData!
    var terrainData: TerrainData!
}

struct ItemData{
    var worldItems: [Node] = []
    var width: Int = 0
    var depth: Int = 0
}

struct TerrainData{
    private var terrainHeights: [[Float]]!
    private var _width: Int = 0
    private var _depth: Int = 0
    public var width: Int {
        return _width
    }
    public var depth: Int {
        return _depth
    }
    
    init(width: Int, depth: Int){
        self._width = width
        self._depth = depth
        terrainHeights = Array(repeating: Array(repeating: 0, count: width + 1), count: depth + 1)
    }
    mutating public func addHeight(x: Int, z: Int, value: Float){
        terrainHeights[z][x] = value
    }
    public func getHeightAt(x: Int, z: Int)->Float{
        return terrainHeights[z][x]
    }

}

struct WorldItemValues {
    static let Mushroom = float4(1,0,0,1)
    static let LargeGreenOak = float4(0,1,0,1)
}

class WorldGenerator {

    public static func GetWorldData(itemMapName: String, terrainHeightMap: String, maxTerrainHeight: Float)->WorldData {
        var worldData = WorldData()
        
        worldData.terrainData = getTerrainData(terrainHeightMap: terrainHeightMap, maxHeight: maxTerrainHeight)
        worldData.itemData = getWorldItems(itemMapName: itemMapName, terrainData: worldData.terrainData)
        
        return worldData
    }
    
    private static func getWorldItems(itemMapName: String, terrainData: TerrainData)->ItemData{
        var result = ItemData()
        let bmp = NSImage.getBitmapFromResource(resourceName: itemMapName)
        let wide = bmp.pixelsWide
        let depth = bmp.pixelsHigh
        result.width = wide
        result.depth = depth
        for z in 0..<depth{
            for x in 0..<wide {
                let color = getColor(bmp: bmp, x: x, y: z)
                let posX =  Float((wide / 2) + x) - Float(wide)
                let posZ = Float((depth  / 2) + z) - Float(depth)
                let posY = terrainData.getHeightAt(x: x, z: z)
                let object = getObjectNode(color)
                if(object != nil){
                    object?.position.x = posX
                    object?.position.z = posZ
                    object?.position.y = posY
                    result.worldItems.append(object!)
                }
            }
        }
        return result
    }

    
    private static func getTerrainData(terrainHeightMap: String, maxHeight: Float)->TerrainData{
        let bmp = NSImage.getBitmapFromResource(resourceName: terrainHeightMap)
        let width = bmp.pixelsWide
        let depth = bmp.pixelsHigh
        var result = TerrainData(width: width, depth: depth)
        for z in 0..<depth {
            for x in 0..<width {
                var pixel: Int = 0
                bmp.getPixel(&pixel, atX: x, y: z)
                var height: Float = Float(pixel) //255 = white
                height /= Float(255)
                height *= maxHeight
                result.addHeight(x: x, z: z, value: height)
            }
        }
        return result
    }
    
    private static func getColor(bmp: NSBitmapImageRep, x: Int, y: Int)->float4{
        return float4(Float((bmp.colorAt(x: x, y: y)?.redComponent)!),
                      Float((bmp.colorAt(x: x, y: y)?.greenComponent)!),
                      Float((bmp.colorAt(x: x, y: y)?.blueComponent)!),
                      Float((bmp.colorAt(x: x, y: y)?.alphaComponent)!))
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


