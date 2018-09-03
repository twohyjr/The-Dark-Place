import MetalKit

class ModelLoader {
    
    public static func CreateMtkMeshArrayFromWavefront(_ modelName: String)->[MDLMesh]{
        var meshes: [MDLMesh]! = nil
        
        let url = Bundle.main.url(forResource: "\(modelName).obj", withExtension: nil)
        
        let assetVertexDescriptor = MTKModelIOVertexDescriptorFromMetal(VertexDescriptorLibrary.Descriptor(.Basic))
        let position = assetVertexDescriptor.attributes[0] as! MDLVertexAttribute
        position.name = MDLVertexAttributePosition
        assetVertexDescriptor.attributes[0] = position
        
        let color = assetVertexDescriptor.attributes[1] as! MDLVertexAttribute
        color.name = MDLVertexAttributeColor
        assetVertexDescriptor.attributes[1] = color
        
        let normals = assetVertexDescriptor.attributes[2] as! MDLVertexAttribute
        normals.name = MDLVertexAttributeNormal
        assetVertexDescriptor.attributes[2] = normals

        let textureCoordiantes = assetVertexDescriptor.attributes[3] as! MDLVertexAttribute
        textureCoordiantes.name = MDLVertexAttributeTextureCoordinate
        assetVertexDescriptor.attributes[3] = textureCoordiantes
        
        let bufferAllocator = MTKMeshBufferAllocator(device: Engine.Device)
        
        //TODO: Unable to find ear error??? Yo no say
        let asset = MDLAsset(url: url!, vertexDescriptor: assetVertexDescriptor, bufferAllocator: bufferAllocator)
        do{
            meshes = try MTKMesh.newMeshes(asset: asset, device: Engine.Device).modelIOMeshes
        }catch let error as NSError{
            print("ERROR::CREATING::MESH_FROM_WAVEFRONT::--\(modelName)--::\(error)")
        }

        return meshes
    }
    
    public static func CreateMeshFromDAEFile(_ modelName: String)->RiggedMesh{
        let result = RiggedMesh()
        
        AnimatedModelLoader.LoadEntity("")
        
        return result
    }
    
}
