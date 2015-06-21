import UIKit
import XCTest

class TestRestMappers: XCTestCase {

    override func setUp() {
        super.setUp()
        
        let testTargetBundle = NSBundle(identifier: "anita-borg.malaria-iosTests")
        RKTestFixture.setFixtureBundle(testTargetBundle)
    }

    func createMappingDirectAttributeMapTest(mapping: RKEntityMapping, sourceJson: String, attrs: [String]) -> RKMappingTest{
        let parsedJson: AnyObject? = RKTestFixture.parsedObjectWithContentsOfFixture(sourceJson)
        
        let test = RKMappingTest(forMapping: mapping, sourceObject: parsedJson, destinationObject: nil)
        test.managedObjectContext = CoreDataHelper.sharedInstance.backgroundContext
        
        attrs.map({test.addExpectation(RKPropertyMappingTestExpectation(sourceKeyPath: $0, destinationKeyPath: $0))})
        
        return test
    }
    
    
    func testApiEndpointMapper() {
        
        let attributes = [
            "users",
            "posts",
            "revposts",
            "regions" ,
            "sectors",
            "ptposts",
            "projects",
            "goals",
            "objectives",
            "indicators",
            "outputs",
            "outcomes",
            "activity",
            "measurement",
            "cohort",
            "volunteer"
        ]
        let test = createMappingDirectAttributeMapTest(ApiEndpoint().mapping, sourceJson: "api.json", attrs: attributes)
        
        XCTAssertTrue(test.evaluate)
    }
}
