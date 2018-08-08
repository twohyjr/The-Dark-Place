import MetalKit

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
