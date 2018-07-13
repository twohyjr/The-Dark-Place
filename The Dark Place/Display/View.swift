import MetalKit

class View {
    private static var _screenSize: Size = Size()
    public static var ScreenSize: Size {
        return _screenSize
    }
    
    public static var ShouldUpdateViewValues: Bool = true
    
    public static var AspectRatio: Float {
        return self.ScreenWidth / self.ScreenHeight
    }
    
    public static var ScreenWidth: Float {
        return _screenSize.getWidth()
    }
    
    public static var ScreenHeight: Float {
        return _screenSize.getHeight()
    }
    
    public static func setScreenSize(_ size: CGSize){
        self._screenSize.setSize(size)
    }

}
