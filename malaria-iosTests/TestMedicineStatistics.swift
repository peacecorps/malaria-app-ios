import XCTest

class TestMedicineStatistics: XCTestCase {

    let m: MedicineManager = MedicineManager.sharedInstance
    let d1 = NSDate.from(2015, month: 5, day: 8) //monday
    let currentPill = Medicine.Pill.Malarone

    var md: Medicine!
    
    override func setUp() {
        super.setUp()
        
        
        m.setup(currentPill, fireDate: d1)
        
        if let medi = m.findMedicine(currentPill){
            md = medi
        }else{
            XCTFail("Fail initializing:")
        }
        
        md.registriesManager.addRegistry(d1, tookMedicine: true)
        md.registriesManager.addRegistry(d1 - 1.day, tookMedicine: true)
        md.registriesManager.addRegistry(d1 - 2.day, tookMedicine: true)
        md.registriesManager.addRegistry(d1 - 3.day, tookMedicine: true)
        md.registriesManager.addRegistry(d1 - 4.day, tookMedicine: true)
        md.registriesManager.addRegistry(d1 - 5.day, tookMedicine: true)
        md.registriesManager.addRegistry(d1 - 6.day, tookMedicine: true)
        md.registriesManager.addRegistry(d1 - 7.day, tookMedicine: true)
        md.registriesManager.addRegistry(d1 - 8.day, tookMedicine: true)
        md.registriesManager.addRegistry(d1 - 9.day, tookMedicine: true)
    }
    
    override func tearDown() {
        super.tearDown()
        m.clearCoreData()
    }
    
    func testPillStreak(){
        XCTAssertEqual(10, md.stats.pillStreak())
        XCTAssertEqual(6, md.stats.pillStreak(date1: d1, date2: d1 - 5.day))
    
        //miss one pill
        XCTAssertTrue(md.registriesManager.addRegistry(d1 - 5.day, tookMedicine: false, modifyEntry: true))
        XCTAssertEqual(0, md.stats.pillStreak(date1: d1 - 9.day, date2: d1 - 5.day))
        XCTAssertEqual(5, md.stats.pillStreak(date1: d1, date2: d1 - 5.day))
        
        //did not took a pill more recently
        XCTAssertTrue(md.registriesManager.addRegistry(d1, tookMedicine: false, modifyEntry: true))
        XCTAssertEqual(0, md.stats.pillStreak())
    }
    
    /*
    func testSupposedPills(){
        XCTAssertEqual(10, md.stats.numberSupposedPills())
        
        //add one pill
        XCTAssertTrue(md.registriesManager.addRegistry(d1 - 10.day, tookMedicine: false))
        XCTAssertEqual(11, md.stats.numberSupposedPills())
        
        //miss one pill
        XCTAssertTrue(md.registriesManager.addRegistry(d1 - 11.day, tookMedicine: false))
        XCTAssertEqual(12, md.stats.numberSupposedPills())
        
        //miss one pill in the past
        XCTAssertTrue(md.registriesManager.addRegistry(d1 - 5.day, tookMedicine: false, modifyEntry: true))
        XCTAssertEqual(3, md.stats.numberSupposedPills(date1: d1 - 6.day, date2: d1 - 4.day))
    }*/
    
    
    func testPillsTaken(){
        XCTAssertEqual(10, md.stats.numberPillsTaken())
        XCTAssertEqual(6, md.stats.numberPillsTaken(date1: d1, date2: d1 - 5.day))
        
        //add one pill
        XCTAssertTrue(md.registriesManager.addRegistry(d1 - 11.day, tookMedicine: true))
        XCTAssertEqual(11, md.stats.numberPillsTaken())
        
        //miss one pill
        XCTAssertTrue(md.registriesManager.addRegistry(d1 - 10.day, tookMedicine: false))
        XCTAssertEqual(11, md.stats.numberPillsTaken())
        
        //miss one pill in the past
        XCTAssertTrue(md.registriesManager.addRegistry(d1 - 5.day, tookMedicine: false, modifyEntry: true))
        XCTAssertEqual(2, md.stats.numberPillsTaken(date1: d1 - 6.day, date2: d1 - 4.day))
    }
    
    func testAdherence(){
        XCTAssertEqual(1, md.stats.pillAdherence())
        
        //add one pill
        XCTAssertTrue(md.registriesManager.addRegistry(d1 - 10.day, tookMedicine: true))
        XCTAssertEqual(1, md.stats.pillAdherence())
        
        //miss one pill
        XCTAssertTrue(md.registriesManager.addRegistry(d1 - 11.day, tookMedicine: false))
        
        
        let numberPillsTaken = Float(md.stats.numberPillsTaken())
        XCTAssertEqual(Float(md.stats.numberPillsTaken())/Float(md.stats.numberSupposedPills()), md.stats.pillAdherence())
        
        //miss one pill in the past
        XCTAssertTrue(md.registriesManager.addRegistry(d1 - 5.day, tookMedicine: false, modifyEntry: true))
        
        let afterDate = d1 - 6.day
        let beforeDate = d1 - 4.day
        
        let expectedAdherence = Float(md.stats.numberPillsTaken(date1: afterDate, date2: beforeDate))/Float(md.stats.numberSupposedPills(date1: afterDate, date2: beforeDate))
        
        XCTAssertEqual(expectedAdherence, md.stats.pillAdherence(date1: afterDate, date2: beforeDate))
    }
    
    
    func testShouldReshedulePillReminder(){
        //only applicable to weekly pills
        /* If the user fails to take their medication mid-way through a week, and a full 7 days goes by without the medication being recorded, on DayX+7 the system will start again and allow the user to enter new data for that week. So if the user is supposed to take medications on Mondays, and next Monday arrives with no data entry, the day and date at the top will go back to black text, and the system will now record data for that new week and consider the previous week a missed week.*/
    }
}
