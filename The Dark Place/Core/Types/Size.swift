import MetalKit

struct Size {
    private var _width: Float = 0.0
    private var _height: Float = 0.0
    
    mutating func setSize(_ size: CGSize){
        self._width = Float(size.width)
        self._height = Float(size.height)
    }
    
    public func getWidth()->Float {
        return _width
    }
    
    public func getHeight()->Float {
        return _height
    }
}
