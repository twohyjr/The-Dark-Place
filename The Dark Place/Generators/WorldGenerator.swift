import MetalKit

struct WorldData {
    var terrainData: TerrainData!
}

struct WorldItemData{
    var worldItems: [Node] = []
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
        var trueX = max(x,0)
        var trueZ = max(z,0)
        if(x > width){
            trueX = width
        }
        if(z > depth){
            trueZ = depth
        }
        return terrainHeights[trueZ][trueX]
    }
    
}

struct WorldItemValues {
    static let Mushroom = float4(1,0,0,1)
    static let LargeGreenOak = float4(0,1,0,1)
}

class TerrainBuilder {
    private var _terrainHeightMap: String = ""
    private var _terrainMaxHeight: Float = 0.0
    private var _terrainGridDimensions = int2(1)
    private var _baseTextureType: TextureTypes! = nil
}

class WorldItemsGenerator {
    
    private var _itemPlacementMap: String = ""
    private var _terrainData: TerrainData!
    
    public func withItemPlacementMap(_ itemPlacementMap: String)->WorldItemsGenerator{
        self._itemPlacementMap = itemPlacementMap
        return self
    }
    
    public func withTerrainData(_ terrainData: TerrainData)->WorldItemsGenerator{
        self._terrainData = terrainData
        return self
    }
    
    public func generateWorldItemData()->WorldItemData{
        return getWorldItems(itemMapName: _itemPlacementMap, terrainData: _terrainData)
    }
    
    private func getWorldItems(itemMapName: String, terrainData: TerrainData?)->WorldItemData{
        var result = WorldItemData()
        if(itemMapName != ""){
            let bmp = NSImage.getBitmapFromResource(resourceName: itemMapName)
            let wide = bmp.pixelsWide
            let depth = bmp.pixelsHigh
            for z in 0..<depth{
                for x in 0..<wide {
                    let color = getColor(bmp: bmp, x: x, y: z)
                    let posX =  Float((wide / 2) + x) - Float(wide)
                    let posZ = Float((depth  / 2) + z) - Float(depth)
                    let posY = terrainData != nil ? terrainData?.getHeightAt(x: x - 1, z: z + 1) : 0
                    let object = getObjectNode(color)
                    if(object != nil){
                        object?.position.x = posX - 1
                        object?.position.z = posZ + 1
                        object?.position.y = posY!
                        result.worldItems.append(object!)
                    }
                }
            }
        }
        return result
    }
    
    private func getColor(bmp: NSBitmapImageRep, x: Int, y: Int)->float4{
        return float4(Float((bmp.colorAt(x: x, y: y)?.redComponent)!),
                      Float((bmp.colorAt(x: x, y: y)?.greenComponent)!),
                      Float((bmp.colorAt(x: x, y: y)?.blueComponent)!),
                      Float((bmp.colorAt(x: x, y: y)?.alphaComponent)!))
    }
    
    private func getObjectNode(_ color: float4)->Node?{
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
//    func generateScene()->WorldData {
//        var worldData = WorldData()
//
//        worldData.terrainData = getTerrainData(terrainHeightMap: _terrainHeightMap, maxHeight: _terrainMaxHeight)
//
//        return worldData
//    }
    
//    private func getTerrainData(terrainHeightMap: String, maxHeight: Float)->TerrainData{
//        var result: TerrainData!
//        if terrainHeightMap != "" {
//            let bmp = NSImage.getBitmapFromResource(resourceName: terrainHeightMap)
//            let width = bmp.pixelsWide
//            let depth = bmp.pixelsHigh
//            result = TerrainData(width: width, depth: depth)
//            for z in 0..<depth {
//                for x in 0..<width {
//                    var pixel: Int = 0
//                    bmp.getPixel(&pixel, atX: x, y: z)
//                    var height: Float = Float(pixel) //255 = white
//                    height /= Float(255)
//                    height *= maxHeight
//                    result.addHeight(x: x, z: z, value: height)
//                }
//            }
//        }else{
//            result = TerrainData(width: Int(_terrainGridDimensions.x), depth: Int(_terrainGridDimensions.y))
//        }
//
//        return result
//    }







