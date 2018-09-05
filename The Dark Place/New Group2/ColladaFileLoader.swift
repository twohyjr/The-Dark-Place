import Foundation
import simd

class ColladaFileLoader {
    
    public static func GetRiggedMesh(_ modelName: String)->RiggedMesh{
        let result = RiggedMesh()
        
        result.vertices = [
            Vertex(position: float3(0, 1, 0),
                   color: float4(0, 0, 0, 0),
                   normal: float3(0, 0, 0),
                   textureCoordinate: float2(0, 0)),
            Vertex(position: float3(-1, -1, 0),
                   color: float4(0, 0, 0, 0),
                   normal: float3(0, 0, 0),
                   textureCoordinate: float2(0, 0)),
            Vertex(position: float3(1, -1, 0),
                   color: float4(0, 0, 0, 0),
                   normal: float3(0, 0, 0),
                   textureCoordinate: float2(0, 0))
        ]
        
        result.indices = [
            0, 1, 2
        ]
        
        return result
    }
    

}


