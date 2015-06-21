import UIKit
import XCTest

class TestRestMappers: XCTestCase {

    let rootEndpoint = RootEndpoint()
    
    override func setUp() {
        super.setUp()
        
        let testTargetBundle = NSBundle(identifier: "anita-borg.malaria-iosTests")
        RKTestFixture.setFixtureBundle(testTargetBundle)
    }

    func testRootEndpointMapper() {
        let parsedJson: AnyObject? = RKTestFixture.parsedObjectWithContentsOfFixture("api.json")
        
        let mapping = rootEndpoint.mapping
        
        let test = RKMappingTest(forMapping: mapping, sourceObject: parsedJson, destinationObject: nil)
        test.managedObjectContext = CoreDataHelper.sharedInstance.backgroundContext
        
        test.addExpectation(RKPropertyMappingTestExpectation(sourceKeyPath: "users", destinationKeyPath: "users"))
        
        XCTAssertTrue(test.evaluate)
    }
}
