import XCTest
import malaria_ios

class TestMedicineRegistries: XCTestCase {

    var m: MedicineManager!
    
    let d1 = NSDate.from(2015, month: 6, day: 13) //Saturday intentionally
    
    let currentPill = Medicine.Pill.Malarone
    var md: Medicine!
    
    var currentContext: NSManagedObjectContext!
    var registriesManager: RegistriesManager!
    
    override func setUp() {
        super.setUp()

        currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
        m = MedicineManager(context: currentContext)
        m.setup(currentPill, fireDate: NSDate())
        
        if let medi = m.getMedicine(currentPill){
            md = medi
        }else{
            XCTFail("Fail initializing:")
        }
        
        registriesManager = md.registriesManager(currentContext)
        
        registriesManager.addRegistry(d1, tookMedicine: true)
        registriesManager.addRegistry(d1 - 1.day, tookMedicine: true)
        registriesManager.addRegistry(d1 - 2.day, tookMedicine: false)
        registriesManager.addRegistry(d1 - 3.day, tookMedicine: true)
        registriesManager.addRegistry(d1 - 4.day, tookMedicine: false)
        registriesManager.addRegistry(d1 - 5.day, tookMedicine: true)
        registriesManager.addRegistry(d1 - 6.day, tookMedicine: true)
        registriesManager.addRegistry(d1 - 7.day, tookMedicine: false)
        registriesManager.addRegistry(d1 - 8.day, tookMedicine: true)
        registriesManager.addRegistry(d1 - 9.day, tookMedicine: false)
    }
    
    override func tearDown() {
        super.tearDown()
        m.clearCoreData()
        UserSettingsManager.clear()
    }
    
    func testFindEntriesInBetween(){
        let entries = registriesManager.getRegistries(date1: d1 - 5.day, date2: d1 - 3.day)
        
        if entries.count != 3 {
            XCTFail("Incorrect number of elements")
            return
        }
        
        let r1 = entries[0]
        XCTAssertEqual(r1.date, d1 - 3.day)
        XCTAssertEqual(r1.tookMedicine, true)
        
        let r2 = entries[1]
        XCTAssertEqual(r2.date, d1 - 4.day)
        XCTAssertEqual(r2.tookMedicine, false)
        
        let r3 = entries[2]
        XCTAssertEqual(r3.date, d1 - 5.day)
        XCTAssertEqual(r3.tookMedicine, true)
        
        
        //flip the dates, should reproduce the same results
        let entriesFlipped = registriesManager.getRegistries(date1:d1 - 3.day, date2: d1 - 5.day)
        
        if entriesFlipped.count == 0 {
            XCTFail("No element found")
            return
        }
        
        let r1f = entriesFlipped[0]
        XCTAssertEqual(r1f.date, d1 - 3.day)
        XCTAssertEqual(r1f.tookMedicine, true)
        
        let r2f = entriesFlipped[1]
        XCTAssertEqual(r2f.date, d1 - 4.day)
        XCTAssertEqual(r2f.tookMedicine, false)
        
        let r3f = entriesFlipped[2]
        XCTAssertEqual(r3f.date, d1 - 5.day)
        XCTAssertEqual(r3f.tookMedicine, true)
        
        
        //check interval without entries
        XCTAssertEqual(0, registriesManager.getRegistries(date1:d1 - 30.day,  date2: d1 - 25.day).count)
        
        //check interval big enough to fit every entry
        let entries2 = registriesManager.getRegistries(date1:d1 - 50.day, date2: d1 + 50.day)
        XCTAssertEqual(registriesManager.getRegistries().count, entries2.count)
        
        //single registry
        let entries3 = registriesManager.getRegistries(date1:d1 - 4.day, date2: d1 - 4.day)
        XCTAssertEqual(1, entries3.count)
    }
    
    func testFindEntry(){
        //find existing entry
        var r = registriesManager.findRegistry(d1 - 4.day)!
        XCTAssertEqual(r.date, d1 - 4.day)
        XCTAssertEqual(r.tookMedicine, false)
        
        //finding inexistent entry
        XCTAssertEqual(true, registriesManager.findRegistry(d1 - 30.day) == nil)
    }
    
    func testAlreadyRegisteredWeeklyPill(){
        let weeklyPill = Medicine.Pill.Mefloquine
        m.registerNewMedicine(weeklyPill)

        var weekly: Medicine!
        if let w = m.getMedicine(weeklyPill){
            weekly = w
        }else{
            XCTFail("Failure registering weekly pill")
        }
        
        
        let weeklyRegistriesManager = weekly.registriesManager(currentContext)
        
        //Saturday = 0, Sunday = 1, etc
        var dStartWeek = d1 + NSCalendar.currentCalendar().firstWeekday.day
        
        XCTAssertTrue(weeklyRegistriesManager.addRegistry(dStartWeek, tookMedicine: true))

        XCTAssertFalse(weeklyRegistriesManager.tookMedicine(dStartWeek - 1.day))
        XCTAssertTrue(weeklyRegistriesManager.tookMedicine(dStartWeek + 1.day))
        XCTAssertTrue(weeklyRegistriesManager.tookMedicine(dStartWeek + 2.day))
        XCTAssertTrue(weeklyRegistriesManager.tookMedicine(dStartWeek + 3.day))
        XCTAssertTrue(weeklyRegistriesManager.tookMedicine(dStartWeek + 4.day))
        XCTAssertTrue(weeklyRegistriesManager.tookMedicine(dStartWeek + 5.day))
        XCTAssertTrue(weeklyRegistriesManager.tookMedicine(dStartWeek + 6.day))
        XCTAssertFalse(weeklyRegistriesManager.tookMedicine(dStartWeek + 7.day))
    }
    
    func testAlreadyRegisteredDailyPill(){
        XCTAssertTrue(registriesManager.tookMedicine(d1))
        XCTAssertTrue(registriesManager.tookMedicine(d1 - 1.day))
        XCTAssertFalse(registriesManager.tookMedicine(d1 + 1.day))
    }
    
    func testFailAddEntryInFuture(){
        XCTAssertTrue(registriesManager.addRegistry( NSDate(), tookMedicine: true))
        XCTAssertFalse(registriesManager.addRegistry( NSDate() + 1.day, tookMedicine: true))
    }
    
    func testModifyEntry(){
        //modify entry and check if the number of elements did not change
        let lastCount = registriesManager.getRegistries().count
        XCTAssertTrue(registriesManager.addRegistry(d1 - 4.day, tookMedicine: true, modifyEntry: true))
        XCTAssertEqual(lastCount, registriesManager.getRegistries().count)
        
        //verify if modification was a success
        let r = registriesManager.findRegistry(d1 - 4.day)!
        XCTAssertEqual(true, r.tookMedicine)
        XCTAssertEqual(true, r.date.sameDayAs(d1 - 4.day))
    }
    
    func testCascadeDelete(){
        XCTAssertEqual(Registry.retrieve(Registry.self, context: currentContext).count, 10)
        Medicine.clear(Medicine.self, context: currentContext)
        XCTAssertEqual(Registry.retrieve(Registry.self, context: currentContext).count, 0)
    }
}
