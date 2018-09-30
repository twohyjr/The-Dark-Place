import Foundation
import simd

class ColladaFileLoader {

    public static func GetRiggedMesh(_ modelName: String)->RiggedMesh{
        let riggedMesh = RiggedMesh()
        
        let xml: XML!
        if let url = Bundle.main.url(forResource: modelName, withExtension: "dae") {
            xml = XML(url: url)
            
            let riggedVertices = GeometryLoader.extractRiggedVertexData(xml)
            riggedMesh.vertices = riggedVertices
            
            let rootJoint: Joint = JointsLoader.getJointData(xml)!
            riggedMesh.rootJoint = rootJoint
            var jointCount: Int = 0
            JointsLoader.getJointCount(headJoint: rootJoint, jointCount: &jointCount)
            riggedMesh.jointCount = jointCount
      
            let animationData: AnimationData = getAnimationData(xml, rootJoint)
            riggedMesh.animationData = animationData
            
        }

        return riggedMesh
    }

    private static func getAnimationData(_ xml: XML, _ rootJoint: Joint)->AnimationData{
        var times: [Float] = getKeyTimes(xml)
        let duration = times[times.count - 1]
        var keyFrames = initKeyFrames(times: times)
        let animationNodes = xml["#library_animations"].xml!
        
        for animationXML in animationNodes["#animation"] {
            loadJointTransforms(frames: &keyFrames, animationXML: animationXML, rootNode: rootJoint)
        }
       print(keyFrames)
        return AnimationData(lengthSeconds: duration, keyFrames: keyFrames)
    }

    private static func loadJointTransforms(frames: inout [KeyFrameData], animationXML: XML, rootNode: Joint){
        let jointNameID = getJointName(jointData: animationXML)
        let dataID = getDataId(jointData: animationXML)
        let transformationData = getTransformData(animationXML: animationXML, dataID: dataID)
        
        for i in 0..<frames.count {
            var transform = transformationData[i]
            if(jointNameID == rootNode.name){
                transform.rotate(angle: toRadians(-90), axis: X_AXIS)
            }
            frames[i].addJointTransform(transform: JointTransformData(jointNameID: jointNameID, jointLocalTransform: transform))
        }
    }
    
    private static func getTransformData(animationXML: XML, dataID: String)->[matrix_float4x4]{
        var data: [matrix_float4x4] = []
        for node in animationXML["#source"] {
            if(node["@id"].string! == dataID){
                data = node["#float_array"].string!.convertToMatrix4x4Array()
                break;
            }
        }
        return data
    }
    
    private static func getDataId(jointData: XML)->String{
        let node = jointData["#sampler"]
        var source: String = ""
        for input in node["#input"] {
            if(input["@semantic"].string! == "OUTPUT"){
                source = input["@source"].string!
                break;
            }
        }
        return source.dropHash
    }
    
    private static func getJointName(jointData: XML)->String{
        let channelNode = jointData["#channel"]
        let data: String = channelNode["@target"].string!
        return String(data.split(separator: Character("/")).first!)
    }
    
    private static func getKeyTimes(_ xml: XML)->[Float]{
        var inputXML: XML!
        for source in xml["#library_animations.animation.source"] {
            if(source["@id"].string!.contains("input")){
                inputXML = source
                break
            }
        }
        return inputXML["#float_array"].string!.toFloatArray()
    }
    
    private static func initKeyFrames(times: [Float])->[KeyFrameData]{
        var frames = [KeyFrameData].init(repeating: KeyFrameData(time: 0), count: times.count)
        for i in 0..<frames.count {
            frames[i] = KeyFrameData(time: times[i])
        }
        return frames
    }
    
    

}

class AnimationData {
    var legthInSeconds: Float = 0.0
    var keyFrames: [KeyFrameData] = []
    
    init(lengthSeconds: Float, keyFrames: [KeyFrameData]){
        self.legthInSeconds = lengthSeconds
        self.keyFrames = keyFrames
    }
}

class KeyFrameData {
    var time: Float = 0.0
    var jointTransforms: [JointTransformData] = []
    
    init(time: Float){
        self.time = time
    }
    
    func addJointTransform(transform: JointTransformData) {
        jointTransforms.append(transform)
    }
}

class JointTransformData {
    var jointNameID: String = ""
    var jointLocalTransform: matrix_float4x4 = matrix_identity_float4x4
    
    init(jointNameID: String, jointLocalTransform: matrix_float4x4) {
        self.jointNameID = jointNameID
        self.jointLocalTransform = jointLocalTransform
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







