import simd

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
    
    var xyz: float3 {
        return float3(self.x , self.y, self.z)
    }
}
