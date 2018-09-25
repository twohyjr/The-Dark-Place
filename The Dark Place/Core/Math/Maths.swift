import MetalKit

public var X_AXIS: float3{
    return float3(1,0,0)
}

public var Y_AXIS: float3{
    return float3(0,1,0)
}

public var Z_AXIS: float3{
    return float3(0,0,1)
}

public func toRadians(_ degrees: Float)->Float{
    return (degrees / 180) * Float.pi
}

public func toDegrees(_ radians: Float) -> Float{
    return radians * (180 / Float.pi)
}

func randomBounded(lowerBound: Int, upperBound: Int) -> Int {
    return lowerBound + Int(arc4random_uniform(UInt32(upperBound - lowerBound)))
}

func barryCentric(_ p1: float3,_ p2: float3,_ p3: float3,_ pos: float2)->Float{
    let det = (p2.z - p3.z) * (p1.x - p3.x) + (p3.x - p2.x) * (p1.z - p3.z);
    let l1 = ((p2.z - p3.z) * (pos.x - p3.x) + (p3.x - p2.x) * (pos.y - p3.z)) / det;
    let l2 = ((p3.z - p1.z) * (pos.x - p3.x) + (p1.x - p3.x) * (pos.y - p3.z)) / det;
    let l3 = 1.0 - l1 - l2;
    return l1 * p1.y + l2 * p2.y + l3 * p3.y;
}


//mat4 LookAt(vec3 eye, vec3 at, vec3 up)
//{
//    vec3 zaxis = normalize(eye - at);
//    vec3 xaxis = normalize(cross(zaxis, up));
//    vec3 yaxis = cross(xaxis, zaxis);
//
//    negate(zaxis);
//    
//    mat4 viewMatrix = {
//        vec4(xaxis.x, xaxis.y, xaxis.z, -dot(xaxis, eye)),
//        vec4(yaxis.x, yaxis.y, yaxis.z, -dot(yaxis, eye)),
//        vec4(zaxis.x, zaxis.y, zaxis.z, -dot(zaxis, eye)),
//        vec4(0, 0, 0, 1)
//    };
//
//    return viewMatrix;
//}
