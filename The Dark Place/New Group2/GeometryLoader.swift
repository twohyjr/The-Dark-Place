import simd
import Foundation

class GeometryLoader {
    
    private enum Semantic {
        static let VERTEX = "VERTEX"
        static let NORMAL = "NORMAL"
        static let TEXCOORD = "TEXCOORD"
        static let COLOR = "COLOR"
        
        static let JOINT = "JOINT"
        static let WEIGHT = "WEIGHT"
    }
    
    private struct GeometrySourceInput {
        var semantic: String
        var source: String
        var offset: Int
        var data: [Any]
    }
    
    public static func extractRiggedVertexData(modelName: String)->[RiggedVertex]{
        var riggedVertices: [RiggedVertex] = []
        let xml: XML!
        if let url = Bundle.main.url(forResource: modelName, withExtension: "dae") {
            xml = XML(url: url)
            
            //Indices
            let polyList = xml["#library_geometries.geometry.mesh.polylist"]
            var polyValues: [GeometrySourceInput] = []
            var inputCount: Int = 0
            for input in polyList["#input"] {
                let semantic = input["@semantic"].string!
                var inputSource = input["@source"].string!.dropHash
                let offset = input["@offset"].int!
                var data: [Any]!
                if(semantic == "VERTEX") {
                    inputSource = xml["#library_geometries.geometry.mesh.vertices.input.@source"].stringValue.dropHash
                }
                inputCount += 1
                for sourceNode in xml["#library_geometries.geometry.mesh.source"] {
                    let source = sourceNode["@id"].string!.lowercased().dropHash
                    if(inputSource.lowercased() == source){
                        let stride = sourceNode["#technique_common.accessor.@stride"].int!
                        let floatArray = sourceNode["#float_array"].string!
                        if(stride == 2){
                            data = floatArray.toFloat2Array()
                        }else if(stride == 3) {
                            if(source.contains("color")){
                                data = floatArray.toFloat4ArrayFromStride3()
                            }else {
                                data = floatArray.toFloat3Array()
                            }
                        }else if (stride == 4){
                            data = floatArray.toFloat4Array()
                        }
                    }
                }
                polyValues.append(GeometrySourceInput(semantic: semantic, source: inputSource, offset: offset, data: data))
            }

            let skinXML = xml["#library_controllers.controller.skin"].xml!
            
            //Weights
            let controllerSkinData = getControllerSkinData(skinXML: skinXML)
            var weightValues: [Float] = []
            for val in controllerSkinData {
                if(val.key.lowercased().contains("weights")){
                    weightValues = val.value.arrData as? [Float] ?? []
                    break
                }
            }
            
            let vertexWeightsXML = skinXML["#vertex_weights"]
            var jointOffset: Int = -1
            var weightOffset: Int = -1
            var jointWeightInputCount: Int = 0
            for input in vertexWeightsXML["#input"] {
                switch input["@semantic"].string! {
                case Semantic.JOINT:
                    jointOffset = input["@offset"].int!
                case Semantic.WEIGHT:
                    weightOffset = input["@offset"].int!
                default:
                    break
                }
                jointWeightInputCount += 1
            }
            
            let vCountList = vertexWeightsXML["#vcount"].string!.toIntArray()
            let vList = vertexWeightsXML["#v"].string!.toIntArray()
           
            var vertexWeightDatas: [VertexWeightData] = []
            var offset = 0
            
            for value in vCountList {
                var vertexWeightData = VertexWeightData()
                for _ in 0..<value {
                    let joint = Int32(vList[offset + jointOffset])
                    let weight = weightValues[vList[offset + weightOffset]]
                    vertexWeightData.addJointEffect(weight: weight, joint: joint)
                    offset += jointWeightInputCount
                }
                vertexWeightData.normalize()
                vertexWeightDatas.append(vertexWeightData)
            }

//            var num: Int = 0
//            for data in vertexWeightDatas {
//                print("num: \(num++)     sum: \(data.weightSum)    weights: \(data.weights)  joints: \(data.joints)")
//            }

            var positions: [float3]!
            var normals: [float3]!
            var textureCoords: [float2]!
            var colors: [float4]!
            
            var positionOffset: Int = -1
            var normalOffset: Int = -1
            var textureOffset: Int = -1
            var colorOffset: Int = -1
            
            for poly in polyValues {
                switch poly.semantic {
                case Semantic.VERTEX:
                    positions = poly.data as? [float3] ?? []
                    positionOffset = poly.offset
                    break
                case Semantic.NORMAL:
                    normals = poly.data as? [float3] ?? []
                    normalOffset = poly.offset
                    break
                case Semantic.TEXCOORD:
                    textureCoords = poly.data as? [float2] ?? []
                    textureOffset = poly.offset
                    break
                case Semantic.COLOR:
                    colors = poly.data as? [float4] ?? []
                    colorOffset = poly.offset
                    break
                default:
                    print("There is no semantic path to follow")
                    break
                }
            }
            let pList = xml["#library_geometries.geometry.mesh.polylist.p"].string!.toIntArray()
            
            var currentOffset: Int = 0
            var colorPoint: float4 = float4(0)
            var vertexPoint: float3 = float3(0)
            var texturePoint: float2 = float2(0)
            var normalPoint: float3 = float3(0)
            
            var jointIDs: [Int32] = []
            var weights: [Float] = []
            
            var startedListIteration: Bool = false
            for value in pList {
                if(currentOffset == 0 && startedListIteration){
                    vertexPoint.rotate(axis: X_AXIS, angle: toRadians(-90))
                    riggedVertices.append(RiggedVertex(position: vertexPoint,
                                                       color: colorPoint,
                                                       normal: normalPoint,
                                                       jointIDs: convertIntArrayToInt3(jointIDs),
                                                       weights: convertFloatArrayToFloat3(weights),
                                                       textureCoordinate: texturePoint))
                }
                startedListIteration = true
                if(currentOffset == positionOffset){
                    vertexPoint = positions[value]
                    jointIDs = vertexWeightDatas[value].joints
                    weights = vertexWeightDatas[value].weights
                }else if(currentOffset == normalOffset){
                    normalPoint = normals[value]
                }else if(currentOffset == textureOffset){
                    texturePoint = textureCoords[value]
                }else if(currentOffset == colorOffset){
                    colorPoint = colors[value]
                }

                currentOffset += 1
                currentOffset = currentOffset % inputCount
            }
        }
        
        
        return riggedVertices
    }
    
    
    
    private static func getControllerSkinData(skinXML: XML)->[String : ControllerSkinSource<Any>] {
        var result: [String : ControllerSkinSource<Any>]  = [:]
        let skinSources = skinXML["#source"]
        for source in skinSources {
            var skinSource = ControllerSkinSource<Any>()
            let id = source["@id"].string!
            if(source["#float_array"].string != nil){
                let arr: [Float] = source["#float_array"].string!.toFloatArray()
                skinSource.id = id
                skinSource.arrData = arr
                result.updateValue(skinSource, forKey: id)
            }else if(source["#Name_array"].string != nil){
                var skinSource = ControllerSkinSource<Any>()
                let arr: [String] = source["#Name_array"].string!.toStringArray()
                skinSource.id = id
                skinSource.arrData = arr
                result.updateValue(skinSource, forKey: id)
            }
        }
        return result
    }
    
    private static func convertIntArrayToInt3(_ arr: [Int32])->int3{
        return int3(arr[0], arr[1], arr[2])
    }
    
    private static func convertFloatArrayToFloat3(_ arr: [Float])->float3{
        return float3(arr[0], arr[1], arr[2])
    }
    
}

struct ControllerSkinSource<T> {
    var id: String = ""
    var arrData: [T] = []
}

struct VertexWeightData {
    
    var weights: [Float] = []
    var joints: [Int32] = []
    
    var weightSum: Float = 0.0

    mutating func normalize(){
        while(weights.count > 3){
            let val = weights.last!
            weightSum -= val
            weights = Array(weights.dropLast())
            joints = Array(joints.dropLast())
        }
        while(weights.count < 3){
            weights.append(0)
            joints.append(0)
        }
        
        weights = weights.map { Float($0) / weightSum }
        
        weightSum = 0
        for weight in weights {
            weightSum += weight
        }
    }
    
    mutating func addJointEffect(weight: Float, joint: Int32){
        weightSum += weight
        for i in 0..<weights.count {
            if(weight > weights[i]){
                joints.insert(joint, at: i)
                weights.insert(weight, at: i)
                return
            }
        }
        joints.append(joint)
        weights.append(weight)
    }
    
}
