import simd

struct DebugSettings {
    public static var lightValue1: Float = 0
    public static var lightValue2: Float = 0
    public static var lightValue3: Float = 0
    
    public static func printLightValues(){
        print("""
        value 1: \(lightValue1)
        value 2: \(lightValue2)
        value 3: \(lightValue3)
        """)
    }
}
