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
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    
    /// Random float between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random float point number between 0 and n max
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}
