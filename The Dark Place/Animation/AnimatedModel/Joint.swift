import simd

class Joint {
    
    public var index: Int
    public var name: String
    public var children: [Joint] = []
    
    private var animatedTransform = matrix_identity_float4x4
    
    public var localBindTransform = matrix_identity_float4x4
    private var inverseBindTransform = matrix_identity_float4x4
    
    init(index: Int, name: String, bindLocalTransform: matrix_float4x4){
        self.index = index
        self.name = name
        self.localBindTransform = bindLocalTransform
    }
    
    public func addChild(_ child: Joint){
        children.append(child)
    }
    
    public func getAnimatedTransform()->matrix_float4x4 {
        return animatedTransform
    }
    
    public func setAnimatedTransform(_ animatedTransform: matrix_float4x4) {
        self.animatedTransform = animatedTransform
    }
    
    public func getInverseBindTransform()->matrix_float4x4{
        return inverseBindTransform
    }
    
    internal func calcInverseBindTransform(_ parentBindTransform: matrix_float4x4){
        let bindTransform = matrix_multiply(parentBindTransform, localBindTransform)
        self.inverseBindTransform = bindTransform.inverse
        for child in children {
            child.calcInverseBindTransform(bindTransform)
        }
    }
    
}
