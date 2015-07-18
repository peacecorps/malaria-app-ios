import XCTest
import malaria_ios


class TestWeeklyMedicineStatistics: XCTestCase {

    var m: MedicineManager!
    let d1 = NSDate.from(2010, month: 1, day: 4) + NSCalendar.currentCalendar().firstWeekday.day //start of the week
    let currentPill = Medicine.Pill.Mefloquine //weekly Pill
    
    var md: Medicine!
    var currentContext: NSManagedObjectContext!
    var registriesManager: RegistriesManager!
    var stats: MedicineStats!
    /*
        No entries past the 5th week
    */
    
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
        for i in 0...5{
            XCTAssertTrue(registriesManager.addRegistry(d1 + i.week, tookMedicine: true))
        }
    }
    
    override func tearDown() {
        super.tearDown()
        m.clearCoreData()
        UserSettingsManager.clear()
    }
    
    func testPillStreak(){
        XCTAssertEqual(stats.pillStreak(), 6)
        XCTAssertTrue(registriesManager.addRegistry(d1 + 6.week, tookMedicine: false))
        XCTAssertEqual(stats.pillStreak(), 0)
    }
    
    func testPillStreakMissingEntries(){
        //baseline
        XCTAssertEqual(stats.pillStreak(), 6)
        
        //1 week gap
        XCTAssertTrue(registriesManager.addRegistry(d1 + 8.week, tookMedicine: false))
        XCTAssertEqual(stats.pillStreak(), 0)
        
        //2 more week gap
        XCTAssertTrue(registriesManager.addRegistry(d1 + 10.week, tookMedicine: true))
        XCTAssertEqual(stats.pillStreak(), 1)
    }
    
    
    func testSupposedPillsMissingEntries(){
        //baseline on the 5th week
        XCTAssertEqual(stats.numberSupposedPills(), 6)
        
        //1 week gap. 6th and 7th week were skipped. week none
        XCTAssertTrue(registriesManager.addRegistry(d1 + 8.week, tookMedicine: false))
        XCTAssertEqual(stats.numberSupposedPills(), 9)
        
        //1 more week gap
        XCTAssertTrue(registriesManager.addRegistry(d1 + 10.week, tookMedicine: true))
        XCTAssertEqual(stats.numberSupposedPills(), 11)
    }
    
    func testSupposedPills(){
        XCTAssertEqual(stats.numberSupposedPills(), 6)
        
        XCTAssertTrue(registriesManager.addRegistry(d1 + 6.week, tookMedicine: false))
        XCTAssertEqual(stats.numberSupposedPills(), 7)
        
        XCTAssertTrue(registriesManager.addRegistry(d1 + 7.week, tookMedicine: true))
        XCTAssertEqual(stats.numberSupposedPills(), 8)
    }
    
    
    func testPillsTaken(){
        XCTAssertEqual(stats.numberPillsTaken(), 6)
        
        XCTAssertTrue(registriesManager.addRegistry(d1 + 6.week, tookMedicine: false))
        XCTAssertEqual(stats.numberPillsTaken(), 6)
        
        XCTAssertTrue(registriesManager.addRegistry(d1 + 7.week, tookMedicine: true))
        XCTAssertEqual(stats.numberPillsTaken(), 7)
    }
    
    func testPillsTakenMissingEntries(){
        XCTAssertEqual(stats.numberPillsTaken(), 6)
        
        //add gap
        XCTAssertTrue(registriesManager.addRegistry(d1 + 7.week, tookMedicine: false))
        XCTAssertEqual(stats.numberPillsTaken(), 6)
        
        //add another gap
        XCTAssertTrue(registriesManager.addRegistry(d1 + 9.week, tookMedicine: true))
        XCTAssertEqual(stats.numberPillsTaken(), 7)
    }
}
