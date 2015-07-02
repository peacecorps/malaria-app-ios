import UIKit
import XCTest

class TestSyncManager: XCTestCase {
    let sm = SyncManager.sharedInstance
    
    var expectation: XCTestExpectation?
    var completionCalled = false
    
    override func setUp() {
        super.setUp()
        
        completionCalled = false
    }
    
    override func tearDown() {
        super.tearDown()
        for (path, endpoint) in sm.endpoints{
            endpoint.clearFromDatabase()
        }
    }
    
    func completionHandler(url: String, error: NSError?){
        completionCalled = true
        expectation!.fulfill()
    }
    
    func genericTest(path: String, type : NSManagedObject.Type?, additionalTests: (()->())? = nil){
        expectation = expectationWithDescription("\(path)_callback")
        
        sm.sync(path, save: true, completionHandler: completionHandler)
        
        var done: Bool = false
        
        waitForExpectationsWithTimeout(15, handler: { error in
            if let error = error {
                XCTFail("\(error.localizedDescription)")
            }
            
            if !self.completionCalled{
                XCTFail("Completition handler wasn't called")
            }
            
            //assure only one object per endpoint
            if let t = type{
                XCTAssertEqual(t.retrieve(t.self).count, 1)
            }
            
            additionalTests?()
            
            done = true
        })
        
        if(!done){
            XCTFail("Expectation not called!")
        }
    }
    
    func testSyncAll(){
        expectation = expectationWithDescription("syncall")
        
        
        sm.syncAll(completitionHandler: { Void in self.expectation!.fulfill() })
        var done: Bool = false
        waitForExpectationsWithTimeout(60, handler: { error in
            if let error = error {
                XCTFail("\(error.localizedDescription)")
            }
            
            XCTAssertEqual(Posts.retrieve(Posts.self).count, 1)
            
            done = true
        })

        if(!done){
            XCTFail("Expectation not called!")
        }
    }
    
    func testBadUrl(){
        genericTest("Bad url", type: nil)
    }
    
    func testPosts(){
        func additionalTests(){
            let endpointInfoArray = Posts.retrieve(Posts.self)
            XCTAssertEqual(endpointInfoArray.count, 1)
            XCTAssertNotEqual(Post.retrieve(Post.self).count, 0)
            XCTAssertNotEqual(endpointInfoArray[0].posts.count, 0)
            
        }
        
        genericTest(EndpointType.Posts.path(), type: Posts.self, additionalTests: additionalTests)
    }
}
