import Foundation
import simd

extension String {
    
    static var Empty: String {
        return ""
    }
    
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
    
    func toStringArray()->[String]{
        return self.split(separator: Character(" ")).map { String($0) }
        
    }
    
    var dropHash: String {
        return self.replacingOccurrences(of: "#", with: "")
    }
    
}
