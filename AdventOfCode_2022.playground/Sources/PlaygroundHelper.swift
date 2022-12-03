import Foundation

public struct PlaygroundHelper {
    public static let shared = PlaygroundHelper()
    
    public func convertTextFileToString(name: String) -> String? {
        let path = Bundle.main.path(forResource: name, ofType: "txt")
        var outputString: String?
        do {
            outputString = try String(contentsOfFile: path!)
            return outputString
        } catch {
            print(error)
        }
        return nil
    }
}
