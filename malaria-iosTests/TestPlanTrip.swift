import XCTest

class TestPlanTrip: XCTestCase {

    let tManager: TripsManager = TripsManager.sharedInstance
    
    let location = "Heaven"
    let currentPill = Medicine.Pill.Malarone
    let cashToBring = 10
    let d1 = NSDate.from(2015, month: 5, day: 8) //monday
    var trip: Trip!
    
    
    override func setUp() {
        super.setUp()
        
        if let t = tManager.createTrip(location, medicine: currentPill, cashToBring: cashToBring, reminderDate: d1){
            trip = t
        }else{
            XCTFail("Setup failed")
        }
        
    }
    
    override func tearDown() {
        super.tearDown()
        tManager.clearCoreData()
    }
    
    func testCreation(){
        if let t = tManager.getTrip(){
            XCTAssertEqual(t.location, location)
            XCTAssertEqual(t.medicine, currentPill.name())
            XCTAssertEqual(t.cashToBring, cashToBring)
            XCTAssertEqual(t.reminderDate, d1)
        }else{
            XCTFail("Trip wasn't created")
        }
        

    }

    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }

}
