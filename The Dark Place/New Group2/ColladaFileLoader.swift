import Foundation
import simd

enum Semantic {
    static let VERTEX = "VERTEX"
    static let NORMAL = "NORMAL"
    static let TEXCOORD = "TEXCOORD"
    static let COLOR = "COLOR"
}

class ColladaFileLoader {
    

    public static func GetRiggedMesh(_ modelName: String)->[Vertex]{
        var vertices: [Vertex] = []
        let xml: XML!
        if let url = Bundle.main.url(forResource: modelName, withExtension: "dae") {
            xml = XML(url: url)
            
            //Indices
            let polyList = xml["#library_geometries.geometry.mesh.polylist"]
            var polyValues: [Input] = []
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
                polyValues.append(Input(semantic: semantic, source: inputSource, offset: offset, data: data))
            }
            
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
                case "VERTEX":
                    positions = poly.data as? [float3] ?? []
                    positionOffset = poly.offset
                    break
                case "NORMAL":
                    normals = poly.data as? [float3] ?? []
                    normalOffset = poly.offset
                    break
                case "TEXCOORD":
                    textureCoords = poly.data as? [float2] ?? []
                    textureOffset = poly.offset
                    break
                case "COLOR":
                    colors = poly.data as? [float4] ?? []
                    colorOffset = poly.offset
                    break
                default:
                    print("There is no semantic path to follow")
                    break
                }
            }
            print(colors)
            let pList = xml["#library_geometries.geometry.mesh.polylist.p"].string!.toIntArray()
            
            var currentOffset: Int = 0
            var colorPoint: float4 = float4(0)
            var vertexPoint: float3 = float3(0)
            var texturePoint: float2 = float2(0)
            var normalPoint: float3 = float3(0)
            var startedListIteration: Bool = false
            for value in pList {
                if(currentOffset == 0 && startedListIteration){
                    vertices.append(Vertex(position: vertexPoint, color: colorPoint, normal: normalPoint, textureCoordinate: texturePoint))
                    colorPoint = float4(0)
                    vertexPoint = float3(0)
                    texturePoint = float2(0)
                    normalPoint = float3(0)
                }
                startedListIteration = true
                if(currentOffset == positionOffset){
                    vertexPoint = positions[value]
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
        return vertices
    }
}

struct Input {
    var semantic: String
    var source: String
    var offset: Int
    var data: [Any]
}







