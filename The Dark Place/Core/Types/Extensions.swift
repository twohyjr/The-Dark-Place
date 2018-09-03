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

extension float3 {
    
    var toSimpleString: String {
        let x: String = self.x.toString2d
        let y: String = self.y.toString2d
        let z: String = self.z.toString2d
        return "( x:\(x), y:\(y), z:\(z))"
    }
    
}

extension Int {
    static postfix func ++(_ left: inout Int)->Int{
        left += 1
        return left - 1
    }
    
    static postfix func --(_ left: inout Int)->Int{
        left -= 1
        return left + 1
    }
}

extension Float {
    
    var toString2d: String {
        return String(format: "%.2f", self)
    }
    
    static postfix func ++(_ left: inout Float)->Float{
        left += 1.0
        return left - 1.0
    }
    
    static postfix func --(_ left: inout Float)->Float{
        left -= 1.0
        return left + 1.0
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
