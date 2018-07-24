import MetalKit

protocol sizeable{ }
extension sizeable{
    static var size: Int{
        return MemoryLayout<Self>.size
    }
    
    static var stride: Int{
        return MemoryLayout<Self>.stride
    }
    
    static func size(_ count: Int)->Int{
        return MemoryLayout<Self>.size * count
    }
    
    static func stride(_ count: Int)->Int{
        return MemoryLayout<Self>.stride * count
    }
}

extension Float: sizeable { }
extension float2: sizeable { }
extension float3: sizeable { }
extension float4: sizeable { }
extension UInt16: sizeable { }

struct Vertex: sizeable{
    var position: float3
    var color: float4
    var normal: float3
    var textureCoordinate: float2
}

struct ModelConstants: sizeable{
    var modelMatrix = matrix_identity_float4x4
    var normalMatrix = matrix_identity_float3x3
}

struct SceneConstants: sizeable {
    var viewMatrix = matrix_identity_float4x4
    var projectionMatrix = matrix_identity_float4x4
    var eyePosition: float3 = float3(0)
    var inverseViewMatrix = matrix_identity_float4x4
}

struct Material: sizeable {
    var shininess: Float = 0.1
    var ambient = float3(1) //Ka
    var diffuse = float3(0) //Kd
    var specular = float3(3) //Ks
}

struct Light{
    var position = float3(0,0,0)
    var ambientIntensity: Float = 1.0
}

struct LightData: sizeable {
    var lightCount: Int {
        return lights.count
    }
    var lights: [Light] = []
}
