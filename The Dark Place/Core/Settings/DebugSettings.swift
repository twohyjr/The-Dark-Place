import simd

struct DebugSettings {
    public static var value1: Float = 0
    public static var value2: Float = 0
    public static var value3: Float = 0
    public static var value4: Float = 0
    public static var value5: Float = 0
    public static var value6: Float = 0
    
    public static var nameValue1: String = "No Name"
    public static var nameValue2: String = "No Name"
    public static var nameValue3: String = "No Name"
    public static var nameValue4: String = "No Name"
    public static var nameValue5: String = "No Name"
    public static var nameValue6: String = "No Name"
    
    public static func printValues(){
        print("""
        \(nameValue1): \(value1)
        \(nameValue2): \(value2)
        \(nameValue3): \(value3)
        \(nameValue4): \(value4)
        \(nameValue5): \(value5)
        \(nameValue6): \(value6)
        """)
    }
}
