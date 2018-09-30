import MetalKit

class JointsLoader {
    public static func getJointData(_ xml: XML)->Joint?{
        let skinXML = xml["#library_controllers.controller.skin"]
        
        var jointNames: [String : Int] = [:]
        for source in skinXML["#source"] {
            if(source["@id"].string!.lowercased().contains("joint")){
                let vals = source["#Name_array"].string!.toStringArray()
                var count: Int = 0
                for value in vals {
                    jointNames.updateValue(count, forKey: value)
                    count += 1
                }
                break
            }
        }
        
        let nodesXML = xml["#library_visual_scenes.visual_scene"]
        var rootNodeXML: XML!
        for node in nodesXML["#node"] {
            if(node["@id"].string!.lowercased().contains("armature")) {
                rootNodeXML = node["#node"].xml
                break;
            }
        }
        
        let rootJoint = createJoint(xml: rootNodeXML, jointNames: jointNames)
        
        return rootJoint
    }
    
    public static func getJointCount(headJoint: Joint, jointCount: inout Int) {
        jointCount += 1
        
        for child in headJoint.children {
            getJointCount(headJoint: child, jointCount: &jointCount)
        }
    }
    
    private static func createJoint(xml: XML, jointNames: [String:Int])->Joint{
        let jointName: String = xml["@id"].string!
        let index: Int = jointNames[jointName]!
        
        let bindLocalTransform = xml["#matrix"].string!.convertToMatrix4x4()
        
        let joint: Joint = Joint(index: index, name: jointName, bindLocalTransform: bindLocalTransform)
        
        for node in xml["#node"] {
            joint.addChild(createJoint(xml: node, jointNames: jointNames))
        }
        
        return joint
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
    
    func printJointNames(){
        for child in children {
            child.printJointNames()
        }
        print("Index: (\(index))   Name: \(name)")
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
