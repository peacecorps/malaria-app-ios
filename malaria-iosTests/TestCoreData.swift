import UIKit
import XCTest
import malaria_ios

class TestCoreData: XCTestCase {

    var m: MedicineManager?
    
    override func setUp() {
        super.setUp()
        m = MedicineManager.sharedInstance
        if let instance = m { }else{
            XCTFail("Failing initializing")
        }
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInsertion() {
        
        m!.setup(Medicine.Pill.Malarone, fireDate: NSDate())
        
        let d1 = NSDate()
        m!.updatePillTracker(d1, tookPill: true)
        
        let d2 = d1 + 7.day
        m!.updatePillTracker(d2, tookPill: false)
        
        let d3 = d2 + 7.day
        m!.updatePillTracker(d3, tookPill: true)
        
        
        //getting
        let medicine: Medicine? = m!.getCurrentMedicine()
        if let med = medicine{
            if(med.registries.count != 3){
                XCTFail("Error registering pills")
            }
            med.print()
        }else{
            XCTFail("Error registering pills")
        }
        
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
