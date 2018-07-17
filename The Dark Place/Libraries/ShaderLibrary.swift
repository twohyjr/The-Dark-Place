import MetalKit

enum VertexShaderTypes{
    case Basic
    case VillageTerrain
}

enum FragmentShaderTypes {
    case Basic
    case VillageTerrain
}

class ShaderLibrary {
    
    public static var DefaultLibrary: MTLLibrary!
    
    private static var vertexShaders: [VertexShaderTypes: Shader] = [:]
    private static var fragmentShaders: [FragmentShaderTypes: Shader] = [:]
    
    public static func Initialize(){
        DefaultLibrary = Engine.Device.makeDefaultLibrary()
        createDefaultShaders()
    }
    
    public static func createDefaultShaders(){
        addVertexShader(.Basic, Shader(functionName: "basic_vertex_shader", label: "Basic Vertex Shader"))
        addVertexShader(.VillageTerrain, Shader(functionName: "village_terrain_vertex_shader", label: "Village Terrain Vertex Shader"))
        
        addFragmentShader(.Basic, Shader(functionName: "basic_fragment_shader", label: "Basic Fragment Shader"))
        addFragmentShader(.VillageTerrain, Shader(functionName: "village_terrain_fragment_shader", label: "Village Terrain Fragment Shader"))
    }
    
    private static func addVertexShader(_ vertexShaderType: VertexShaderTypes, _ shader: Shader){
        vertexShaders.updateValue(shader, forKey: vertexShaderType)
    }
    
    private static func addFragmentShader(_ fragmentShaderType: FragmentShaderTypes, _ shader: Shader){
        fragmentShaders.updateValue(shader, forKey: fragmentShaderType)
    }
    
    public static func Vertex(_ vertexShaderType: VertexShaderTypes)->MTLFunction{
        return vertexShaders[vertexShaderType]!.function
    }
    
    public static func Fragment(_ fragmentShaderType: FragmentShaderTypes)->MTLFunction{
        return fragmentShaders[fragmentShaderType]!.function
    }
    
}

public struct Shader {
    var function: MTLFunction!
    init(functionName: String, label: String){
        function = ShaderLibrary.DefaultLibrary.makeFunction(name: functionName)
        function?.label = label
    }
}

