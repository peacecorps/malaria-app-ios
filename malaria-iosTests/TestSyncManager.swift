import UIKit
import XCTest

class TestSyncManager: XCTestCase {
    let sm = SyncManager.sharedInstance
    
    var expectation: XCTestExpectation?
    var successCalled = false
    var failureCalled = false
    
    override func setUp() {
        super.setUp()
        
        successCalled = false
        failureCalled = false
    }
    
    override func tearDown() {
        super.tearDown()
        for (path, endpoint) in sm.endpoints{
            endpoint.clearFromDatabase()
        }
    }
    
    func successHandler(url: String, object: NSManagedObject){
        successCalled = true
        expectation!.fulfill()
    }
    
    func failureHandler(url: String, error: NSError){
        failureCalled = true
        expectation!.fulfill()
    }
    
    func genericTest(path: String, type : NSManagedObject.Type?){
        expectation = expectationWithDescription("\(path)_callback")
        
        sm.sync(path, save: true, failureHandler: failureHandler, successHandler: successHandler)
        
        waitForExpectationsWithTimeout(10, handler: { error in
            if let error = error {
                Logger.Error("Error: \(error.localizedDescription)")
            }
            
            if !self.failureCalled && !self.successCalled{
                XCTFail("Nor success nor failures callbacks were called")
            }
            
            //assure only one object per endpoint
            if let t = type{
                XCTAssertEqual(t.retrieve(t.self).count, 1)
            }
            
        })
    }
    
    func testBadUrl(){
        genericTest("Bad url", type: nil)
    }
    
    func testApi(){
        genericTest(Endpoints.Api.path(), type: Api.self)
    }
    
    func testPosts(){
        genericTest(Endpoints.Posts.path(), type: Posts.self)
    }
    
    func testRevPosts(){
        genericTest(Endpoints.Revposts.path(), type: RevPosts.self)
    }
    
    func testRegions(){
        genericTest(Endpoints.Regions.path(), type: Regions.self)
    }
    
    func testSectors(){
        genericTest(Endpoints.Sectors.path(), type: Sectors.self)
    }
    
    func testPtPosts(){
        genericTest(Endpoints.Ptposts.path(), type: PtPosts.self)
    }
    
    func testProjects(){
        genericTest(Endpoints.Projects.path(), type: Projects.self)
    }
    
    func testVolunteer(){
        genericTest(Endpoints.Volunteer.path(), type: Volunteers.self)
    }
    
    func testCohort(){
        genericTest(Endpoints.Cohort.path(), type: Cohorts.self)
    }
    
    func testMeasurement(){
        genericTest(Endpoints.Measurement.path(), type: Measurements.self)
    }
    
    func testActivity(){
        genericTest(Endpoints.Activity.path(), type: Activities.self)
    }
    
    func testOutcomes(){
        genericTest(Endpoints.Outcomes.path(), type: Outcomes.self)
    }
    
    func testOutputs(){
        genericTest(Endpoints.Outputs.path(), type: Outputs.self)
    }
    
    func testIndicators(){
        genericTest(Endpoints.Indicators.path(), type: Indicators.self)
    }
    
    func testObjectives(){
        genericTest(Endpoints.Objectives.path(), type: Objectives.self)
    }
    
    func testGoals(){
        genericTest(Endpoints.Goals.path(), type: Goals.self)
    }
}
