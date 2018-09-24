import simd

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
