import MetalKit

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


    








