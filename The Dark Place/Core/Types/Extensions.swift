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

extension NSView {
    var backgroundColor: NSColor? {
        get {
            guard let color = layer?.backgroundColor else { return nil }
            return NSColor(cgColor: color)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }
}

extension String {
    
    func toFloat2Array()->[float2]{
        var result = [float2]()
        
        let pointArray: [Float] = self.split(separator: Character(" ")).map { Float($0) ?? 0.0 }
        var offset: Int = 0
        while(offset < pointArray.count) {
            result.append(float2(pointArray[offset], pointArray[offset + 1]))
            offset += 2
        }
        
        return result
    }
    
    func toFloat3Array()->[float3]{
        var result = [float3]()
        
        let pointArray: [Float] = self.split(separator: Character(" ")).map { Float($0) ?? 0.0 }
        var offset: Int = 0
        while(offset < pointArray.count) {
            result.append(float3(pointArray[offset], pointArray[offset + 1], pointArray[offset + 2]))
            offset += 3
        }

        return result
    }
    
    func toFloat4Array()->[float4]{
        var result = [float4]()
        
        let pointArray: [Float] = self.split(separator: Character(" ")).map { Float($0) ?? 0.0 }
        var offset: Int = 0
        while(offset < pointArray.count) {
            result.append(float4(pointArray[offset], pointArray[offset + 1], pointArray[offset + 2], pointArray[offset + 3]))
            offset += 4
        }
        
        return result
    }
    
    func toFloat4ArrayFromStride3()->[float4]{
        var result = [float4]()
        
        let pointArray: [Float] = self.split(separator: Character(" ")).map { Float($0) ?? 0.0 }
        var offset: Int = 0
        while(offset < pointArray.count) {
            result.append(float4(pointArray[offset], pointArray[offset + 1], pointArray[offset + 2], 1.0))
            offset += 3
        }
        
        return result
    }
    
    func toIntArray()->[Int]{
        var result = [Int]()
        
        let pointArray: [Int] = self.split(separator: Character(" ")).map { Int($0) ?? 0 }
        for var i in 0..<pointArray.count {
            result.append(Int(pointArray[i++]))
        }
        
        return result

    }
    
    func toFloatArray()->[Float]{
        var result = [Float]()
        
        let pointArray: [Float] = self.split(separator: Character(" ")).map { Float($0)! }
        for var i in 0..<pointArray.count {
            result.append(Float(pointArray[i++]))
        }
        
        return result
        
    }
    
    var dropHash: String {
        return self.replacingOccurrences(of: "#", with: "")
    }
    
}
