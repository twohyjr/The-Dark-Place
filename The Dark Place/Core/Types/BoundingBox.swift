import MetalKit

class BoundingBox: Node {
    var mins: float3 = float3(0)
    var maxs: float3 = float3(0)
    
    init(mins: float3, maxs: float3){
        super.init()
        self.mins = mins
        self.maxs = maxs
    }
    
    override init(){
        super.init()
        self.mins = float3(0)
        self.maxs = float3(0)
    }
}
