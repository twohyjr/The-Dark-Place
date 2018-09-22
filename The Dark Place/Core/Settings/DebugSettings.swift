import simd

struct DebugSettings {
    public static var value1: Float = 0
    public static var value2: Float = 0
    public static var value3: Float = 0
    public static var value4: Float = 0
    public static var value5: Float = 0
    public static var value6: Float = 0
    
    public static func printValues(){
        print("""
        value 1: \(value1)
        value 2: \(value2)
        value 3: \(value3)
        value 1: \(value4)
        value 2: \(value5)
        value 3: \(value6)
        """)
    }
}
