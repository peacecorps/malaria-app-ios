import Foundation

enum Endpoints : String{
    case BaseUrl = "http://pc-web-dev.systers.org/"
    
    case Api = "api"
    case Posts = "posts"
    case Revposts = "revposts"
    case Regions = "regions"
    case Sectors = "sectors"
    case Ptposts = "ptposts"
    case Projects = "projects"
    case Volunteer = "volunteer"
    case Cohort = "cohort"
    case Measurement = "measurement"
    case Activity = "activity"
    case Outcomes = "outcomes"
    case Outputs = "outputs"
    case Indicators = "indicators"
    case Objectives = "objectives"
    case Goals = "goals"
    
    func path() -> String{
        
        if self == BaseUrl {
            return self.rawValue
        }else if self == Api {
            return BaseUrl.rawValue + Api.rawValue
        }
        
        return BaseUrl.rawValue + Api.rawValue + "/" + self.rawValue
    }
}