import Foundation

enum Endpoints : String{
    case BaseUrl = "http://pc-web-dev.systers.org/api/"
    case Api = "api"
    
    func toString() -> String{
        return self.rawValue
    }
}