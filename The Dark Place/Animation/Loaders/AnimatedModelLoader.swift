import simd

class AnimatedModelLoader {
    private static let MAX_VERTEX_WEIGHT_COUNT: Int = 3
    
    public static func LoadEntity(_ modelFile: String, textureFile: String = ""){
        
        let entityData: AnimatedModelData = ColladaLoader.LoadColladaModel(modelFile, MAX_VERTEX_WEIGHT_COUNT)
        
    }
    
    
}
