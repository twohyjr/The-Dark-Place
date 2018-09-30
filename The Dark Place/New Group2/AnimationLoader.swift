import MetalKit

class AnimationLoader {
    
    public static func loadAnimation(animationData: AnimationData)->Animation {
        var frames = [KeyFrame].init(repeating: KeyFrame(timeStamp: 0, jointKeyFrames: [:]), count: animationData.keyFrames.count)
        for i in 0..<frames.count {
            frames[i] = createKeyFrame(data: animationData.keyFrames[i])
        }
        return Animation(lengthInSeconds: 10, frames: frames)
    }

    private static func createKeyFrame(data: KeyFrameData)->KeyFrame{
        var map: [String: JointTransform] = [:]
        for jointData in data.jointTransforms {
            let jointTransform = createTransform(data: jointData)
            map.updateValue(jointTransform, forKey: jointData.jointNameID)
        }
        return KeyFrame(timeStamp: data.time, jointKeyFrames: map)
    }
    
    private static func createTransform(data: JointTransformData)->JointTransform{
        let mat = data.jointLocalTransform
        let translation = float3(mat.m30, mat.m31, mat.m32)
        let rotation = Quaternion.fromMatrix(matrix: mat)
        return JointTransform(position: translation, rotation: rotation)
    }
}
