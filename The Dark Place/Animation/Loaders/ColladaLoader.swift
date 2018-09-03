import Foundation

class ColladaLoader {
    
    public static func LoadColladaModel(_ colladaFile: String, _ maxWeights: Int)->AnimatedModelData{
        let result = AnimatedModelData()
        
        let colladaParser = ColladaParser("Cowboy.xml")
        
        return result
    }

}

public class ColladaParser {
    init(_ colladaFileName: String){
        if let url = Bundle.main.url(forResource: "Cowboy.xml", withExtension: nil) {
            let xml = XML(url: url)!
            print(xml["#library_controllers.controller.0.@id"].string!)
        }
    }
}








