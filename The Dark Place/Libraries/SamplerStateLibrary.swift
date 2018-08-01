import MetalKit

enum SamplerTypes {
    case Basic
}

class SamplerStateLibrary {
    
    private static var _samplerStates: [SamplerTypes: SamplerState] = [:]
    
    public static func Initialize(){
        createDefaultSamplerStates()
    }
    
    private static func createDefaultSamplerStates(){
        _samplerStates.updateValue(BasicSamplerState(), forKey: .Basic)
    }
    
    public static func SamplerState(_ samplerType: SamplerTypes)->MTLSamplerState{
        return (_samplerStates[samplerType]?.samplerState)!
    }
    
}

protocol SamplerState {
    var samplerState: MTLSamplerState { get }
}

class BasicSamplerState: SamplerState {
    var samplerState: MTLSamplerState
    
    init() {
        let samplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor.compareFunction = .less
        samplerDescriptor.minFilter = .linear
        samplerDescriptor.magFilter = .linear
        samplerDescriptor.rAddressMode = .clampToZero
        samplerDescriptor.sAddressMode = .clampToZero
        samplerDescriptor.tAddressMode = .clampToZero
        samplerState = Engine.Device.makeSamplerState(descriptor: samplerDescriptor)!
    }
}
