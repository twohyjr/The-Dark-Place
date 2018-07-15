import MetalKit

class BoundingBox {

    var boundingBox: Mesh!
    var center: float3!
    init(mins: float3, maxs: float3){
        boundingBox = BoundingBoxMesh(mins: mins, maxs: maxs)
    }

}
