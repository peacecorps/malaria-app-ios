import XCTest

class TestWeeklyMedicineStatistics: XCTestCase {

    let m: MedicineManager = MedicineManager.sharedInstance
    let d1 = NSDate.from(2010, month: 1, day: 4) + NSCalendar.currentCalendar().firstWeekday.day //start of the week
    let currentPill = Medicine.Pill.Mefloquine //weekly Pill
    
    var md: Medicine!
    var currentContext: NSManagedObjectContext!
    var registriesManager: RegistriesManager!
    
    /*
        No entries past the 5th week
    */
    
    override func setUp() {
        super.setUp()
       
        currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
        m.context = currentContext
        m.setup(currentPill, fireDate: d1)
        
        if let medi = m.getMedicine(currentPill){
            md = medi
        }else{
            XCTFail("Fail initializing:")
        }
        
        registriesManager = md.registriesManager
        registriesManager.context = currentContext
        
        for i in 0...5{
            XCTAssertTrue(registriesManager.addRegistry(d1 + i.week, tookMedicine: true))
        }
    }
    
    override func tearDown() {
        super.tearDown()
        m.clearCoreData()
    }
    
    func testPillStreak(){
        XCTAssertEqual(md.stats.pillStreak(), 6)
        XCTAssertTrue(registriesManager.addRegistry(d1 + 6.week, tookMedicine: false))
        XCTAssertEqual(md.stats.pillStreak(), 0)
    }
    
    func testPillStreakMissingEntries(){
        //baseline
        XCTAssertEqual(md.stats.pillStreak(), 6)
        
        //1 week gap
        XCTAssertTrue(registriesManager.addRegistry(d1 + 8.week, tookMedicine: false))
        XCTAssertEqual(md.stats.pillStreak(), 0)
        
        //2 more week gap
        XCTAssertTrue(registriesManager.addRegistry(d1 + 10.week, tookMedicine: true))
        XCTAssertEqual(md.stats.pillStreak(), 1)
    }
    
    
    func testSupposedPillsMissingEntries(){
        //baseline on the 5th week
        XCTAssertEqual(md.stats.numberSupposedPills(), 6)
        
        //1 week gap. 6th and 7th week were skipped. week none
        XCTAssertTrue(registriesManager.addRegistry(d1 + 8.week, tookMedicine: false))
        XCTAssertEqual(md.stats.numberSupposedPills(), 9)
        
        //1 more week gap
        XCTAssertTrue(registriesManager.addRegistry(d1 + 10.week, tookMedicine: true))
        XCTAssertEqual(md.stats.numberSupposedPills(), 11)
    }
    
    func testSupposedPills(){
        XCTAssertEqual(md.stats.numberSupposedPills(), 6)
        
        XCTAssertTrue(registriesManager.addRegistry(d1 + 6.week, tookMedicine: false))
        XCTAssertEqual(md.stats.numberSupposedPills(), 7)
        
        XCTAssertTrue(registriesManager.addRegistry(d1 + 7.week, tookMedicine: true))
        XCTAssertEqual(md.stats.numberSupposedPills(), 8)
    }
    
    
    func testPillsTaken(){
        XCTAssertEqual(md.stats.numberPillsTaken(), 6)
        
        XCTAssertTrue(registriesManager.addRegistry(d1 + 6.week, tookMedicine: false))
        XCTAssertEqual(md.stats.numberPillsTaken(), 6)
        
        XCTAssertTrue(registriesManager.addRegistry(d1 + 7.week, tookMedicine: true))
        XCTAssertEqual(md.stats.numberPillsTaken(), 7)
    }
    
    func testPillsTakenMissingEntries(){
        XCTAssertEqual(md.stats.numberPillsTaken(), 6)
        
        //add gap
        XCTAssertTrue(registriesManager.addRegistry(d1 + 7.week, tookMedicine: false))
        XCTAssertEqual(md.stats.numberPillsTaken(), 6)
        
        //add another gap
        XCTAssertTrue(registriesManager.addRegistry(d1 + 9.week, tookMedicine: true))
        XCTAssertEqual(md.stats.numberPillsTaken(), 7)
    }
}
