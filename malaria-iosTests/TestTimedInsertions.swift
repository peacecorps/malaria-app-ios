import XCTest

class TestTimedInsertions: XCTestCase {
    
    var m: MedicineManager?
    var mr: MedicineRegistry?
    var d1 = NSDate.from(2015, month: 5, day: 8) //monday
    let weekly = Medicine.Pill.Mefloquine
    let daily = Medicine.Pill.Malarone
    
    
    override func setUp() {
        super.setUp()

        m = MedicineManager.sharedInstance
        mr = MedicineRegistry.sharedInstance
        if m == nil || mr == nil{
            XCTFail("Fail initializing")
        }
        
        mr!.registerNewMedicine(weekly)
        mr!.registerNewMedicine(daily)
    }
    
    override func tearDown() {
        super.tearDown()
        mr!.clearCoreData()
    }

    func testDailyInsert(){
        XCTAssertTrue(mr!.addRegistry(daily, date: d1, tookMedicine: false))
        XCTAssertFalse(mr!.addRegistry(daily, date: d1, tookMedicine: false))
        
        XCTAssertEqual(1, mr!.getRegistries(daily).count)
        
        
        XCTAssertTrue(mr!.addRegistry(daily, date: d1 - 1.day, tookMedicine: false))
        XCTAssertTrue(mr!.addRegistry(daily, date: d1 + 1.day, tookMedicine: false))
        
        XCTAssertEqual(3, mr!.getRegistries(daily).count)
        
    }
    
    func testWeeklyInsert(){
        XCTAssertTrue(mr!.addRegistry(weekly, date: d1, tookMedicine: false))
        XCTAssertFalse(mr!.addRegistry(weekly, date: d1 + 1.day, tookMedicine: false))
        XCTAssertEqual(1, mr!.getRegistries(weekly).count)
        XCTAssertTrue(mr!.addRegistry(weekly, date: d1 + 1.week, tookMedicine: false))
        XCTAssertEqual(2, mr!.getRegistries(weekly).count)
    }
    
    func testDailyModifyPastEntry(){
        XCTAssertTrue(mr!.addRegistry(weekly, date: d1, tookMedicine: false))
        XCTAssertTrue(mr!.addRegistry(weekly, date: d1, tookMedicine: true, modifyEntry: true))
        XCTAssertEqual(1, mr!.getRegistries(weekly).count)
        XCTAssertTrue(mr!.getRegistries(weekly)[0].tookMedicine)
    }
    
}
