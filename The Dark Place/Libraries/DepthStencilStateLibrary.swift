import MetalKit

enum DepthStencilStateTypes {
    case Basic
    case LessNoDepth
}

class DepthStencilStateLibrary {
    
    private static var _depthStencilStates: [DepthStencilStateTypes: DepthStencilState] = [:]
    
    public static func Initialize(){
        createDefaultDepthStencilStates()
    }
    
    private static func createDefaultDepthStencilStates(){
        _depthStencilStates.updateValue(BasicDepthStencilState(), forKey: .Basic)
        _depthStencilStates.updateValue(LessNoDepthStencilState(), forKey: .LessNoDepth)
    }
    
    public static func DepthStencilState(_ depthStencilStateType: DepthStencilStateTypes)->MTLDepthStencilState{
        return (_depthStencilStates[depthStencilStateType]?.depthStencilState)!
    }
    
}

protocol DepthStencilState {
    var depthStencilState: MTLDepthStencilState { get }
}

class BasicDepthStencilState: DepthStencilState {
    var depthStencilState: MTLDepthStencilState
    
    init() {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilState = Engine.Device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
    }
}

class LessNoDepthStencilState: DepthStencilState {
    var depthStencilState: MTLDepthStencilState
    
    init() {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = false
        depthStencilDescriptor.depthCompareFunction = .less
        depthStencilState = Engine.Device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
    }
}
