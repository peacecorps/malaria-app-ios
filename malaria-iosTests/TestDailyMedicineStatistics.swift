import XCTest
import malaria_ios

class TestDailyMedicineStatistics: XCTestCase {

    var m: MedicineManager!
    let d1 = NSDate.from(2015, month: 5, day: 8)
    let currentPill = Medicine.Pill.Malarone

    var md: Medicine!
    var currentContext: NSManagedObjectContext!
    var registriesManager: RegistriesManager!
    var stats: MedicineStats!
    
    override func setUp() {
        super.setUp()
        
        currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
        m = MedicineManager(context: currentContext)
        
        m.setup(currentPill, fireDate: d1)
        
        if let medi = m.getMedicine(currentPill){
            md = medi
        }else{
            XCTFail("Fail initializing:")
        }
        registriesManager = md.registriesManager(currentContext)
        stats = md.stats(currentContext)
        
        XCTAssertTrue(registriesManager.addRegistry(d1, tookMedicine: true))
        XCTAssertTrue(registriesManager.addRegistry(d1 - 1.day, tookMedicine: true))
        XCTAssertTrue(registriesManager.addRegistry(d1 - 2.day, tookMedicine: true))
        XCTAssertTrue(registriesManager.addRegistry(d1 - 3.day, tookMedicine: true))
        XCTAssertTrue(registriesManager.addRegistry(d1 - 4.day, tookMedicine: true))
        XCTAssertTrue(registriesManager.addRegistry(d1 - 5.day, tookMedicine: true))
        XCTAssertTrue(registriesManager.addRegistry(d1 - 6.day, tookMedicine: true))
        XCTAssertTrue(registriesManager.addRegistry(d1 - 7.day, tookMedicine: true))
        XCTAssertTrue(registriesManager.addRegistry(d1 - 8.day, tookMedicine: true))
        XCTAssertTrue(registriesManager.addRegistry(d1 - 9.day, tookMedicine: true))
    }
    
    override func tearDown() {
        super.tearDown()
        m.clearCoreData()
        UserSettingsManager.clear()
    }
    
    func testPillStreak(){
        XCTAssertEqual(10, stats.pillStreak())
        XCTAssertEqual(6, stats.pillStreak(date1: d1, date2: d1 - 5.day))
    
        //miss one pill
        println("1. ----")
        XCTAssertTrue(registriesManager.addRegistry(d1 - 5.day, tookMedicine: false, modifyEntry: true))
        println("2. ----")
        XCTAssertEqual(0, stats.pillStreak(date1: d1 - 9.day, date2: d1 - 5.day))
        XCTAssertEqual(5, stats.pillStreak(date1: d1, date2: d1 - 5.day))
        
        //did not took a pill more recently
        XCTAssertTrue(registriesManager.addRegistry(d1, tookMedicine: false, modifyEntry: true))
        XCTAssertEqual(0, stats.pillStreak())
    }
    
    func testPillStreakMissingEntries(){
        XCTAssertEqual(10, stats.pillStreak())

        //add 5 day gap
        XCTAssertTrue(registriesManager.addRegistry(d1 + 5.day, tookMedicine: true))
        XCTAssertEqual(1, stats.pillStreak())
        
        XCTAssertTrue(registriesManager.addRegistry(d1 + 6.day, tookMedicine: true))
        XCTAssertEqual(2, stats.pillStreak())
        
        //add one day gap
        XCTAssertTrue(registriesManager.addRegistry(d1 + 8.day, tookMedicine: false))
        XCTAssertEqual(0, stats.pillStreak())
    }
    
    
    func testSupposedPills(){
        XCTAssertEqual(10, stats.numberSupposedPills())
        
        //add one pill
        XCTAssertTrue(registriesManager.addRegistry(d1 - 10.day, tookMedicine: false))
        XCTAssertEqual(11, stats.numberSupposedPills())
        
        //miss one pill
        XCTAssertTrue(registriesManager.addRegistry(d1 - 11.day, tookMedicine: false))
        XCTAssertEqual(12, stats.numberSupposedPills())
        
        //miss one pill in the past
        XCTAssertTrue(registriesManager.addRegistry(d1 - 5.day, tookMedicine: false, modifyEntry: true))
        XCTAssertEqual(3, stats.numberSupposedPills(date1: d1 - 6.day, date2: d1 - 4.day))
    }
    
    func testSupposedPillsMissingEntries(){
        //baseline
        XCTAssertEqual(10, stats.numberSupposedPills())
        
        //add 1 days gap
        XCTAssertTrue(registriesManager.addRegistry(d1 + 2.day, tookMedicine: false))
    }
    
    
    func testPillsTaken(){
        XCTAssertEqual(10, stats.numberPillsTaken())
        XCTAssertEqual(6, stats.numberPillsTaken(date1: d1, date2: d1 - 5.day))
        
        //add one pill
        XCTAssertTrue(registriesManager.addRegistry(d1 - 11.day, tookMedicine: true))
        XCTAssertEqual(11, stats.numberPillsTaken())
        
        //miss one pill
        XCTAssertTrue(registriesManager.addRegistry(d1 - 10.day, tookMedicine: false))
        XCTAssertEqual(11, stats.numberPillsTaken())
        
        //miss one pill in the past
        XCTAssertTrue(registriesManager.addRegistry(d1 - 5.day, tookMedicine: false, modifyEntry: true))
        XCTAssertEqual(2, stats.numberPillsTaken(date1: d1 - 6.day, date2: d1 - 4.day))
    }
    
    func testPillsTakenMissingEntries(){
        //baseline
        XCTAssertEqual(10, stats.numberPillsTaken())
        
        //add 1 day gap
        XCTAssertTrue(registriesManager.addRegistry(d1 + 2.day, tookMedicine: true))
        XCTAssertEqual(11, stats.numberPillsTaken())
        
        //check if doesn't change
        XCTAssertTrue(registriesManager.addRegistry(d1 + 6.day, tookMedicine: false))
        XCTAssertEqual(11, stats.numberPillsTaken())
    }
    
    func testAdherence(){
        XCTAssertEqual(1, stats.pillAdherence())
        
        //add one pill
        XCTAssertTrue(registriesManager.addRegistry(d1 - 10.day, tookMedicine: true))
        XCTAssertEqual(1, stats.pillAdherence())
        
        //miss one pill
        XCTAssertTrue(registriesManager.addRegistry(d1 - 11.day, tookMedicine: false))
        
        
        let numberPillsTaken = Float(stats.numberPillsTaken())
        XCTAssertEqual(Float(stats.numberPillsTaken())/Float(stats.numberSupposedPills()), stats.pillAdherence())
        
        //miss one pill in the past
        XCTAssertTrue(registriesManager.addRegistry(d1 - 5.day, tookMedicine: false, modifyEntry: true))
        
        let afterDate = d1 - 6.day
        let beforeDate = d1 - 4.day
        
        let expectedAdherence = Float(stats.numberPillsTaken(date1: afterDate, date2: beforeDate))/Float(stats.numberSupposedPills(date1: afterDate, date2: beforeDate))
        
        XCTAssertEqual(expectedAdherence, stats.pillAdherence(date1: afterDate, date2: beforeDate))
    }
}
