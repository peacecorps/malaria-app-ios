import Foundation

class PrivateEndpoint : Endpoint{
    override var isPublic: Bool { get { return true } }
    
    override func parameters() -> [String:String] {
        return ["systerspcweb" : "systerspcweb"]
    }
}