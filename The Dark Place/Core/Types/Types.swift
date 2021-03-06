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
extension int3: sizeable { }
extension Int32: sizeable { }
extension UInt16: sizeable { }
extension matrix_float4x4: sizeable { }

struct Vertex: sizeable{
    var position: float3
    var color: float4
    var normal: float3
    var textureCoordinate: float2
}

struct RiggedVertex: sizeable{
    var position: float3
    var color: float4
    var normal: float3
    var jointIDs: int3
    var weights: float3
    var textureCoordinate: float2
}

struct ModelConstants: sizeable{
    var modelMatrix = matrix_identity_float4x4
    var normalMatrix = matrix_identity_float3x3
}

struct Fog {
    var gradient: Float = 20
    var density: Float = 0.001
}

struct SceneConstants: sizeable {
    var skyColor = Renderer.SkyColor
    var viewMatrix = matrix_identity_float4x4
    var projectionMatrix = matrix_identity_float4x4
    var eyePosition: float3 = float3(0)
    var inverseViewMatrix = matrix_identity_float4x4
    var fog = Fog()
}

struct Material: sizeable {
    var shininess: Float = 0.1
    var ambient = float3(1) //Ka
    var diffuse = float3(1) //Kd
    var specular = float3(0.5) //Ks
    var isLit: Bool = true
    var color = float4(0.7, 0.7, 0.7, 1.0);
    var useTexture: Bool = false
}

struct LightData: sizeable{
    var brightness: Float = 1.0
    var position = float3(0)
    var color = float3(1)
    var attenuation = float3(1.0, 0.0, 0.0) //maxes : x y z : 3 10 4
    var ambientIntensity: Float = 1.0
    var diffuseIntensity: Float = 1.0
    var specularIntensity: Float = 1.0
}
