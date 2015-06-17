import Foundation

enum Endpoints : String{
    case BaseUrl = "http://pc-web-dev.systers.org/"
    case Api = "api"
    
    func toString() -> String{
        return self.rawValue
    }
}