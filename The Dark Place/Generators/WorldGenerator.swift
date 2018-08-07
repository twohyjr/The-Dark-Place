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
                    let object = getObjectNode(color)
                    
                    let posX: Float =  Float(x) - (9 / 2) - 0.25
                    let posZ: Float = Float(z) - (9 / 2) + 0.25
                    let posY = terrainData != nil ? terrainData?.getHeightAt(x: x, z: z) : 0
                    if(object != nil){
                        object?.position.x = posX
                        object?.position.z = posZ
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

class TerrainGenerator {
    private var _terrainHeightMap: String = ""
    private var _maxHeight: Float = 1.0
    private var _cellsWide: Int = 1
    private var _cellsDeep: Int = 1
    
    public func withHeightMap(_ heightMap: String)->TerrainGenerator{
        self._terrainHeightMap = heightMap
        return self
    }
    
    public func withMaxTerrainHeight(_ maxHeight: Float)->TerrainGenerator{
        self._maxHeight = maxHeight
        return self
    }
    
    public func withTerrainSize(_ cellsWide: Int, _ cellsDeep: Int)->TerrainGenerator{
        self._cellsWide = cellsWide
        self._cellsDeep = cellsDeep
        return self
    }
    
    public func generateTerrainData()->TerrainData{
        var result: TerrainData!
        if _terrainHeightMap != "" {
            let bmp = NSImage.getBitmapFromResource(resourceName: _terrainHeightMap)
            let width = bmp.pixelsWide - 1
            let depth = bmp.pixelsHigh - 1
            result = TerrainData(width: width, depth: depth)
            for z in 0..<depth + 1 {
                for x in 0..<width + 1 {
                    var pixel: Int = 0
                    bmp.getPixel(&pixel, atX: x, y: z)
                    var height: Float = Float(pixel) //255 = white
                    height /= Float(255)
                    height *= _maxHeight
                    result.addHeight(x: x, z: z, value: height)
                }
            }
        }else{
            result = TerrainData(width: _cellsWide, depth: _cellsDeep)
        }
        return result
    }
}


    








