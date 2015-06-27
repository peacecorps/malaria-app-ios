import XCTest
import SwiftyJSON

class TestMapping: XCTestCase {
    let apiEndpoint = ApiEndpoint()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
        apiEndpoint.clearFromDatabase()
        
    }
    
    func testApi(){
        
        let path = NSBundle(forClass: TestMapping.self).pathForResource("api", ofType: "json")
        if let jsonData = NSData(contentsOfFile:path!) {
            let json = JSON(data: jsonData, options: NSJSONReadingOptions.AllowFragments, error: nil)
            
            if let api = apiEndpoint.retrieveJSONObject(json) as? Api{
                XCTAssertEqual(api.users, "url1")
                XCTAssertEqual(api.posts, "url2")
                XCTAssertEqual(api.revposts, "url3")
                XCTAssertEqual(api.regions, "url4")
                XCTAssertEqual(api.sectors, "url5")
                XCTAssertEqual(api.ptposts, "url6")
                XCTAssertEqual(api.projects, "url7")
                XCTAssertEqual(api.goals, "url8")
                XCTAssertEqual(api.objectives, "url9")
                XCTAssertEqual(api.indicators, "url10")
                XCTAssertEqual(api.outputs, "url11")
                XCTAssertEqual(api.outcomes, "url12")
                XCTAssertEqual(api.activity, "url13")
                XCTAssertEqual(api.measurement, "url14")
                XCTAssertEqual(api.cohort, "url15")
                XCTAssertEqual(api.volunteer, "url16")
            }else{
                XCTFail("Parse fail")
            }
        }
        else{
            XCTFail("file not found")
        }
    }
    
    
    

}
