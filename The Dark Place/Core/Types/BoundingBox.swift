import MetalKit

class BoundingBox {
    
    private var mins = float3(0)
    private var maxs = float3(0)
    
    private var modelConstants = ModelConstants()
    
    private var mesh: CustomMesh!
    func updateMinsAndMaxes(_ position: float3){
        if(position.x > self.maxs.x){ maxs.x = position.x }
        if(position.y > self.maxs.y){ maxs.y = position.y }
        if(position.z > self.maxs.z){ maxs.z = position.z }
        
        if(position.x < self.mins.x){ self.mins.x = position.x }
        if(position.y < self.mins.y){ self.mins.y = position.y }
        if(position.z < self.mins.z){ self.mins.z = position.z }
    }
    
    func generateBoundingBoxMesh(){
        mesh = Cube_CustomMesh(mins: mins, maxs: maxs, isBoundingBox: true)
    }
    
    func update(modelConstants: ModelConstants){
        self.modelConstants = modelConstants
    }
    
    func draw(renderCommandEncoder: MTLRenderCommandEncoder){
        print("Drawing")
    }
    
}
