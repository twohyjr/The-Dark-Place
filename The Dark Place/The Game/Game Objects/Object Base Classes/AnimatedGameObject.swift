import MetalKit

class AnimatedGameObject: Node {
    
    private var mesh: RiggedModelMesh!

    //Skin
    var material = Material()
    var texture: MTLTexture!

    var animator: Animator!
    var animation: Animation!
    
    init(riggedMeshType: RiggedMeshTypes,  textureType: TextureTypes = TextureTypes.None, name: String = String.Empty){
        super.init()
        self.name = name
        self.mesh = RiggedMeshLibrary.Mesh(riggedMeshType)
        if(textureType != TextureTypes.None) {
            texture = TextureLibrary.Texture(textureType)
            material.useTexture = true
        }
        self.animator = Animator(entity: self)
        getRootJoint().calcInverseBindTransform(matrix_identity_float4x4)
        animation = AnimationLoader.loadAnimation(animationData: mesh.riggedMesh.animationData)
    }
    
    func getRootJoint()->Joint{
        return mesh.riggedMesh.rootJoint
    }

    override func update(deltaTime: Float) {
        animator.doAnimation(animation: animation)
        animator.update(deltaTime: time)
        time += 0.02
        time = time.truncatingRemainder(dividingBy: 0.8)
        super.update(deltaTime: deltaTime)
    }
    
    var time: Float = 0.0
    private func getJointTransforms()->[matrix_float4x4] {
        let jointCount = mesh.riggedMesh.jointCount!
        
        var jointMatrices = [matrix_float4x4].init(repeating: matrix_identity_float4x4, count: jointCount)
        addJointsToArray(headJoint: mesh.riggedMesh.rootJoint, jointMatrices: &jointMatrices)
        return jointMatrices
    }
    
    private func addJointsToArray(headJoint: Joint, jointMatrices: inout [matrix_float4x4]){
        jointMatrices[headJoint.index] = headJoint.getAnimatedTransform()
        for childJoint in headJoint.children {
            addJointsToArray(headJoint: childJoint, jointMatrices: &jointMatrices)
        }
    }
}

extension AnimatedGameObject: Renderable {
    func doRender(_ renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setRenderPipelineState(RenderPipelineStateLibrary.PipelineState(.Rigged))
        renderCommandEncoder.setDepthStencilState(DepthStencilStateLibrary.DepthStencilState(.Basic))
        renderCommandEncoder.setFragmentBytes(&material, length: Material.stride, index: 1)
        
        renderCommandEncoder.setVertexBytes(getJointTransforms(), length: matrix_float4x4.stride(mesh.riggedMesh.jointCount), index: 3)
        
        if(material.useTexture){
            renderCommandEncoder.setFragmentSamplerState(SamplerStateLibrary.SamplerState(.Basic), index: 0)
            renderCommandEncoder.setFragmentTexture(texture, index: 0)
        }

        mesh.drawPrimitives(renderCommandEncoder: renderCommandEncoder)
    }
}
