import Foundation
import simd

class ColladaFileLoader {

    public static func GetRiggedMesh(_ modelName: String)->RiggedMesh{
        let riggedVertices = GeometryLoader.extractRiggedVertexData(modelName: modelName)
        
        
        
        
        
        let riggedMesh = RiggedMesh()
        riggedMesh.vertices = riggedVertices
        return riggedMesh
    }
    

}

class Joint {
    var index: Int = 0
    var name: String = ""
    var children: [Joint] = []
    
    private var animatedTranform = matrix_identity_float4x4
    private var localBindTransform = matrix_identity_float4x4
    private var inverseBindTransform = matrix_identity_float4x4

    init(index: Int, name: String, bindLocalTransform: matrix_float4x4){
        self.index = index
        self.name = name
        self.localBindTransform = bindLocalTransform
    }
    
    func addChild(_ child: Joint){
        children.append(child)
    }
    
    func getAnimatedTransform()->matrix_float4x4{
        return animatedTranform
    }
    
    func setAnimationTransform(_ animationTrasform: matrix_float4x4){
        self.animatedTranform = animationTrasform
    }
    
    func getInverseBindTransform()->matrix_float4x4{
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

class JointTransform {
    private var position: float3!
    private var rotation: Quaternion!
    
    init(position: float3, rotation: Quaternion){
        self.position = position
        self.rotation = rotation
    }
    
    func getLocalTransform()->matrix_float4x4 {
        var matrix = matrix_identity_float4x4
        matrix.translate(direction: position)
        matrix = matrix_multiply(matrix, rotation.toRotationMatrix)
        return matrix
    }
    
    func interpolate(frameA: JointTransform, frameB: JointTransform, progression: Float)->JointTransform{
        let pos = interpolate(start: frameA.position, end: frameB.position, progression: progression)
        let rot = frameA.rotation.sLerp(dest: frameB.rotation, lerpFactor: progression, shortest: true)
        return JointTransform(position: pos, rotation: rot)
    }
    
    func interpolate(start: float3, end: float3, progression: Float)->float3 {
        let x: Float = start.x + (end.x - start.x) * progression;
        let y: Float = start.y + (end.y - start.y) * progression;
        let z: Float = start.z + (end.z - start.z) * progression;
        return float3(x, y, z);
    }
}

class KeyFrame {
    private var timeStamp: Float = 0.0
    private var pose: [String : JointTransform] = [:]
    
    init(timeStamp: Float, jointKeyFrames: [String : JointTransform]){
        self.timeStamp = timeStamp
        self.pose = jointKeyFrames
    }
    
    internal func getTimeStamp()->Float {
        return timeStamp
    }
    
    internal func getJointKeyFrames()->[String : JointTransform] {
        return pose
    }
}

class Animation {
    
    private var length: Float = 0.0
    private var keyFrames: [KeyFrame] = []
    
    init(lengthInSeconds: Float, frames: [KeyFrame]){
        self.keyFrames = frames
        self.length = lengthInSeconds
    }
    
    func getLength()->Float {
        return length
    }
    
    func getKeyFrames()->[KeyFrame]{
        return keyFrames
    }
    
}

class Animator {
    
    private var entity: AnimatedGameObject!
    
    private var currentAnimation: Animation!
    private var animationTime: Float = 0.0
    
    init(entity: AnimatedGameObject){
        self.entity = entity
    }
    
    public func doAnimation(animation: Animation){
        self.animationTime = 0.0
        self.currentAnimation = animation
    }
    
    public func update(deltaTime: Float){
        if(currentAnimation == nil) {
            return
        }
        increaseAnimationTime(deltaTime: deltaTime)
        let currentPose = calculateCurrentAnimationPose()
        applyPoseToJoints(currentPose: currentPose, joint: entity.getRootJoint(), parentTransform: matrix_identity_float4x4)
    }
    
    private func increaseAnimationTime(deltaTime: Float){
        animationTime += deltaTime
        if(animationTime > currentAnimation.getLength()){
            self.animationTime.formTruncatingRemainder(dividingBy: currentAnimation.getLength())
        }
    }
    
    private func getPreviousAndNextFrames()->[KeyFrame]{
        let allFrames = currentAnimation.getKeyFrames()
        var previousFrame = allFrames[0]
        var nextFrame = allFrames[0]
        
        for i in 0..<allFrames.count {
            nextFrame = allFrames[i]
            if(nextFrame.getTimeStamp() > animationTime){
                break
            }
            previousFrame = allFrames[i]
        }
        return [ previousFrame, nextFrame ]
    }
    
    private func calculateProgression(previousFrame: KeyFrame, nextFrame: KeyFrame)->Float{
        let totalTime: Float = nextFrame.getTimeStamp() - previousFrame.getTimeStamp()
        let currentTime = animationTime - previousFrame.getTimeStamp()
        return currentTime / totalTime
    }
    
    private func interpolatePoses(previousFrame: KeyFrame, nextFrame: KeyFrame, progression: Float)->[String : matrix_float4x4]{
        var currentPose: [String : matrix_float4x4] = [:]
        for jointName in previousFrame.getJointKeyFrames().keys {
            let previousTransform = previousFrame.getJointKeyFrames()[jointName]!
            let nextTransform = nextFrame.getJointKeyFrames()[jointName]!
            let currentTransform = previousTransform.interpolate(frameA: previousTransform, frameB: nextTransform, progression: progression)
            currentPose.updateValue(currentTransform.getLocalTransform(), forKey: jointName)
        }
        return currentPose
    }
    
    private func calculateCurrentAnimationPose()->[String : matrix_float4x4]{
        let frames = getPreviousAndNextFrames()
        let progression = calculateProgression(previousFrame: frames[0], nextFrame: frames[1])
        return interpolatePoses(previousFrame: frames[0], nextFrame: frames[1], progression: progression)
    }
    
    private func applyPoseToJoints(currentPose: [String : matrix_float4x4], joint: Joint, parentTransform: matrix_float4x4){
        let currentLocalTransform = currentPose[joint.name]!
        var currentTransform = matrix_multiply(parentTransform, currentLocalTransform)
        for childJoint in joint.children {
            applyPoseToJoints(currentPose: currentPose, joint: childJoint, parentTransform: currentTransform)
        }
        currentTransform = matrix_multiply(currentTransform, joint.getInverseBindTransform())
        joint.setAnimationTransform(currentTransform)
    }
    
}







