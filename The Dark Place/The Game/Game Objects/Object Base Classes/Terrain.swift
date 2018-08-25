import MetalKit

class Terrain: Node {
    private var _texture: MTLTexture!
    private var _mesh: CustomMesh!
    private var _modelConstants = ModelConstants()
    private var _material = Material()

    //Lighting
    var shininess: Float = 10
    var ambient: Float = 1
    var diffuse: Float = 0
    var specular: Float = 0
    
    init(gridSize: Int, terrainData: TerrainData, textureType: TextureTypes){
        super.init()
        self._texture = TextureLibrary.Texture(textureType)
        self._mesh = TerrainMeshGenerator.GenerateTerrainMesh(gridSize: gridSize,
                                                              terrainData: terrainData)
        self.position.x -= Float(gridSize) / 2.0
        self.position.z -= Float(gridSize) / 2.0
    }
    
    override func update(deltaTime: Float) {
        _modelConstants.modelMatrix = self.modelMatrix
        _modelConstants.normalMatrix = self.modelMatrix.upperLeftMatrix
        _material.shininess = shininess
        _material.ambient = float3(ambient)
        _material.diffuse = float3(diffuse)
        _material.specular = float3(specular)
        super.update(deltaTime: deltaTime)
    }
}

extension Terrain: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder, lights: inout [LightData]) {
        renderCommandEncoder.pushDebugGroup("Terrain Render Call")
        
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.VillageTerrain))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Basic))
        renderCommandEncoder.setVertexBuffer(_mesh.vertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.setVertexBytes(&_modelConstants, length: ModelConstants.stride, index: 2)
        renderCommandEncoder.setFragmentSamplerState(SamplerStateLibrary.SamplerState(.Basic), index: 0)
        renderCommandEncoder.setFragmentTexture(_texture, index: 0)
        renderCommandEncoder.setFragmentBytes(&_material, length: Material.stride, index: 1)
        renderCommandEncoder.setFragmentBytes(lights,
                                              length: LightData.stride(lights.count),
                                              index: 2)
        var lightCount = lights.count
        renderCommandEncoder.setFragmentBytes(&lightCount, length: Int.stride, index: 3)
        
        _mesh.drawPrimitives(renderCommandEncoder: renderCommandEncoder)
        
        renderCommandEncoder.popDebugGroup()
    }
}
