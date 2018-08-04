import MetalKit

class WorldGenerator {
    
    var terrainMesh: CustomMesh!
    var placementMap: String = "ItemPlacementMap.png"
    
    
    
    
    func getObjects()->[ModelGameObject] {
        var modelGameObjects: [ModelGameObject] = []
        let url: URL = Bundle.main.url(forResource: placementMap, withExtension: nil)!
        let image = NSImage(contentsOf: url)
        let bmp = image?.representations[0] as! NSBitmapImageRep
        let imageHeight = bmp.pixelsHigh
        
        for z in 0..<Int(bmp.size.height){
            for x in 0..<Int(bmp.size.width) {
                var trueX = x
                var trueZ = z
                if(trueX >= imageHeight){
                    trueX = imageHeight - 1
                }
                if(trueZ >= imageHeight){
                    trueZ = imageHeight - 1
                }
                var pixel: Int = 0
                bmp.getPixel(&pixel, atX: trueX, y: trueZ)
                let pixelValue = Float(pixel)
                if(pixelValue == 255.0){
                    let mushroom = RedMushroom()
                    mushroom.position.x = Float(trueX)
                    mushroom.position.z = Float(trueZ)
                    modelGameObjects.append(mushroom)
                }
            }
        }
        return modelGameObjects
    }
    
//    private func getItem(bmp: NSBitmapImageRep, x: Int, z: Int)->Float{
//        let imageHeight = bmp.pixelsHigh
//
//        let maxHeight: Float = 20.0
//        var pixel: Int = 0
//        bmp.getPixel(&pixel, atX: trueX, y: trueZ)
//        var height: Float = Float(pixel)
//        height += Float(255)
//        height /= Float(255 / 2)
//        height *= maxHeight
//
//        return height
//    }
//
}
