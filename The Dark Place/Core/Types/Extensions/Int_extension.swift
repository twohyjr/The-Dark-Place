
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
