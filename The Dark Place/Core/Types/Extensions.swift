import MetalKit

extension float4 {
    var r: Float {
        return self.x
    }
    
    var g: Float {
        return self.y
    }
    
    var b: Float {
        return self.z
    }
    
    var a: Float {
        return self.w
    }

}

extension NSImage {
    public static func getBitmapFromResource(resourceName: String, ext: String = "png")->NSBitmapImageRep{
        let url: URL = Bundle.main.url(forResource: "\(resourceName)", withExtension: ext)!
        let image = NSImage(contentsOf: url)
        let bmp = image?.representations[0] as! NSBitmapImageRep
        return bmp
    }
}
