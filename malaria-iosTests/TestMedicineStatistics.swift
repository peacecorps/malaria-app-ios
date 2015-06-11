import XCTest

class TestMedicineStatistics: XCTestCase {

    var m: MedicineManager?
    var mr: MedicineRegistry?
    var d1 = NSDate()
    let currentPill = Medicine.Pill.Malarone

    override func setUp() {
        super.setUp()
        m = MedicineManager.sharedInstance
        mr = MedicineRegistry.sharedInstance
        if m == nil || mr == nil{
            XCTFail("Fail initializing")
        }
        
        m!.setup(currentPill, fireDate: NSDate())
        
        mr!.addRegistry(currentPill, date: d1, tookMedicine: true)
        mr!.addRegistry(currentPill, date: d1 - 1.day, tookMedicine: true)
        mr!.addRegistry(currentPill, date: d1 - 2.day, tookMedicine: true)
        mr!.addRegistry(currentPill, date: d1 - 3.day, tookMedicine: true)
        mr!.addRegistry(currentPill, date: d1 - 4.day, tookMedicine: true)
        mr!.addRegistry(currentPill, date: d1 - 5.day, tookMedicine: true)
        mr!.addRegistry(currentPill, date: d1 - 6.day, tookMedicine: true)
        mr!.addRegistry(currentPill, date: d1 - 7.day, tookMedicine: true)
        mr!.addRegistry(currentPill, date: d1 - 8.day, tookMedicine: true)
        mr!.addRegistry(currentPill, date: d1 - 9.day, tookMedicine: true)
    }
    
    override func tearDown() {
        super.tearDown()
        mr!.clearCoreData()
    }
    
    func testPillStreak(){
        XCTAssertEqual(10, m!.pillStreak(mr!.getRegistries(currentPill)))
        XCTAssertEqual(6, m!.pillStreak(mr!.getRegistries(currentPill, date1: d1, date2: d1 - 5.day)))
    
        //miss one pill
        XCTAssertTrue(mr!.addRegistry(currentPill, date: d1 - 5.day, tookMedicine: false, modifyEntry: true))
        XCTAssertEqual(0, m!.pillStreak(mr!.getRegistries(currentPill, date1: d1 - 9.day, date2: d1 - 5.day)))
        XCTAssertEqual(5, m!.pillStreak(mr!.getRegistries(currentPill, date1: d1, date2: d1 - 5.day)))
        
        //did not took a pill more recently
        XCTAssertTrue(mr!.addRegistry(currentPill, date: d1 + 1.day, tookMedicine: false))
        XCTAssertEqual(0, m!.pillStreak(mr!.getRegistries(currentPill)))
    }
    
    func testSupposedPills(){
        XCTAssertEqual(10, m!.numberSupposedPills(mr!.getRegistries(currentPill)))
        
        //add one pill
        XCTAssertTrue(mr!.addRegistry(currentPill, date: d1 + 1.day, tookMedicine: false))
        XCTAssertEqual(11, m!.numberSupposedPills(mr!.getRegistries(currentPill)))
        
        //miss one pill
        XCTAssertTrue(mr!.addRegistry(currentPill, date: d1 + 2.day, tookMedicine: false))
        XCTAssertEqual(12, m!.numberSupposedPills(mr!.getRegistries(currentPill)))
        
        //miss one pill in the past
        XCTAssertTrue(mr!.addRegistry(currentPill, date: d1 - 5.day, tookMedicine: false, modifyEntry: true))
        XCTAssertEqual(3, m!.numberSupposedPills(mr!.getRegistries(currentPill, date1: d1 - 6.day, date2: d1 - 4.day)))
    }
    
    func testPillsTaken(){
        XCTAssertEqual(10, m!.numberPillsTaken(mr!.getRegistries(currentPill)))
        XCTAssertEqual(6, m!.numberPillsTaken(mr!.getRegistries(currentPill, date1: d1, date2: d1 - 5.day)))
        
        //add one pill
        XCTAssertTrue(mr!.addRegistry(currentPill, date: d1 + 1.day, tookMedicine: true))
        XCTAssertEqual(11, m!.numberPillsTaken(mr!.getRegistries(currentPill)))
        
        //miss one pill
        XCTAssertTrue(mr!.addRegistry(currentPill, date: d1 + 2.day, tookMedicine: false))
        XCTAssertEqual(11, m!.numberPillsTaken(mr!.getRegistries(currentPill)))
        
        //miss one pill in the past
        XCTAssertTrue(mr!.addRegistry(currentPill, date: d1 - 5.day, tookMedicine: false, modifyEntry: true))
        XCTAssertEqual(2, m!.numberPillsTaken(mr!.getRegistries(currentPill, date1: d1 - 6.day, date2: d1 - 4.day)))
    }
    
    func testAdherence(){
        XCTAssertEqual(1, m!.pillAdherence(mr!.getRegistries(currentPill)))
        
        //add one pill
        XCTAssertTrue(mr!.addRegistry(currentPill, date: d1 + 1.day, tookMedicine: true))
        XCTAssertEqual(1, m!.pillAdherence(mr!.getRegistries(currentPill)))
        
        //miss one pill
        XCTAssertTrue(mr!.addRegistry(currentPill, date: d1 + 2.day, tookMedicine: false))
        let currentRegistries = mr!.getRegistries(currentPill)
        XCTAssertEqual(Float(m!.numberPillsTaken(currentRegistries))/Float(m!.numberSupposedPills(currentRegistries)), m!.pillAdherence(currentRegistries))
        
        //miss one pill in the past
        XCTAssertTrue(mr!.addRegistry(currentPill, date: d1 - 5.day, tookMedicine: false, modifyEntry: true))
        let filter = mr!.getRegistries(currentPill, date1: d1 - 6.day, date2: d1 - 4.day)
        let expectedAdherenceFilter = Float(m!.numberPillsTaken(filter))/Float(m!.numberSupposedPills(filter))
        XCTAssertEqual(expectedAdherenceFilter, m!.pillAdherence(filter))
    }
    
    
    func testShouldReshedulePillReminder(){
        //only applicable to weekly pills
        /* If the user fails to take their medication mid-way through a week, and a full 7 days goes by without the medication being recorded, on DayX+7 the system will start again and allow the user to enter new data for that week. So if the user is supposed to take medications on Mondays, and next Monday arrives with no data entry, the day and date at the top will go back to black text, and the system will now record data for that new week and consider the previous week a missed week.*/
    }
}
