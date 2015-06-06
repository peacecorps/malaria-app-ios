import XCTest

class TestMedicineRegistries: XCTestCase {

    var m: MedicineManager?
    var mr: MedicineRegistry?
    
    override func setUp() {
        super.setUp()
        m = MedicineManager.sharedInstance
        mr = MedicineRegistry.sharedInstance
        if m == nil || mr == nil{
            XCTFail("Fail initializing")
        }
        
        m!.setup(Medicine.Pill.Malarone, fireDate: NSDate())
        
        let d1 = NSDate()
        mr!.addRegistry(d1, tookMedicine: true)
        mr!.addRegistry(d1 - 1.day, tookMedicine: true)
        mr!.addRegistry(d1 - 2.day, tookMedicine: false)
        mr!.addRegistry(d1 - 3.day, tookMedicine: true)
        mr!.addRegistry(d1 - 4.day, tookMedicine: false)
        mr!.addRegistry(d1 - 5.day, tookMedicine: true)
        mr!.addRegistry(d1 - 6.day, tookMedicine: true)
        mr!.addRegistry(d1 - 7.day, tookMedicine: false)
        mr!.addRegistry(d1 - 8.day, tookMedicine: true)
        mr!.addRegistry(d1 - 9.day, tookMedicine: false)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        mr!.clearCoreData()
    }
    
    func testFindEntry(){
        
        
    }
    
    func testModifyEntry(){
        /*
        var r = mr!.findRegistry(d1 - 4.day)!
        XCTAssertEqual(false, r.tookMedicine)
        XCTAssertEqual(true, NSDate.areDatesSameDay(r.date, dateTwo: d1 - 4.day))
        
        //modify entry
        mr!.addRegistry(d1 - 4.day, tookMedicine: true)
        r = mr!.findRegistry(d1 - 4.day)!
        XCTAssertEqual(true, r.tookMedicine)
        XCTAssertEqual(true, NSDate.areDatesSameDay(r.date, dateTwo: d1 - 4.day))
*/
    }

}
