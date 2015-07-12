import XCTest
import malaria_ios

class TestNotifications: XCTestCase {
    var m: MedicineManager!
    
    let d1 = NSDate.from(2015, month: 5, day: 8) //monday
    let currentPill = Medicine.Pill.Malarone //dailyPill
    let weeklyPill = Medicine.Pill.Mefloquine //weekly
    
    var mdDaily: Medicine!
    var mdWeekly: Medicine!
    
    var currentContext: NSManagedObjectContext!
    var mdDailyregistriesManager: RegistriesManager!
    var mdWeeklyregistriesManager: RegistriesManager!
    
    var mdDailyNotifManager: MedicineNotificationsManager!
    var mdWeeklyNotifManager: MedicineNotificationsManager!
    
    
    override func setUp() {
        super.setUp()
        
        currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
        m = MedicineManager(context: currentContext)
        m.setup(currentPill, fireDate: d1) //current pill is daily
        m.registerNewMedicine(weeklyPill)
        
        if let medi = m.getCurrentMedicine(),
           let medi2 = m.getMedicine(weeklyPill){
            mdDaily = medi
            mdWeekly = medi2
        }else{
            XCTFail("Fail initializing:")
        }
        
        mdDailyregistriesManager = mdDaily.registriesManager(currentContext)
        mdWeeklyregistriesManager = mdWeekly.registriesManager(currentContext)
        
        mdDailyNotifManager = mdDaily.notificationManager(currentContext)
        mdWeeklyNotifManager = mdWeekly.notificationManager(currentContext)
        
        XCTAssertTrue(mdDailyregistriesManager.addRegistry(d1, tookMedicine: true))
    }
    
    override func tearDown() {
        super.tearDown()
        m.clearCoreData()
    }
    
    
    //only valid in weekly pills
    func testShoudResetNotificationTime(){
        XCTAssertFalse(mdWeeklyNotifManager.checkIfShouldReset(currentDate: d1))
        XCTAssertTrue(mdWeeklyregistriesManager.addRegistry(d1, tookMedicine: true))
        
        for i in 1...6 {
            XCTAssertFalse(mdWeeklyNotifManager.checkIfShouldReset(currentDate: d1 + i.day))
        }
        
        XCTAssertTrue(mdWeeklyNotifManager.checkIfShouldReset(currentDate: d1 + 7.day))
    }
    
    func testNotificationTime(){
        //reshedule notification
        mdDailyNotifManager.reshedule()
        XCTAssertTrue(NSDate.areDatesSameDay(mdDaily.notificationTime!, dateTwo: d1 + 1.day))
        
        //since mdWeekly is not currentPill, this should return nil
        XCTAssertNil(mdWeekly.notificationTime)
        
        //setCurrentPill, current trigger time is not defined yet
        m.setCurrentPill(weeklyPill)
        XCTAssertNil(mdWeekly.notificationTime)
        
        //define currentTime
        mdWeeklyNotifManager.scheduleNotification(d1)
        XCTAssertTrue(NSDate.areDatesSameDay(mdWeekly.notificationTime!, dateTwo: d1))
        
        //add new entry and reshedule
        XCTAssertTrue(mdWeeklyregistriesManager.addRegistry(d1, tookMedicine: true))
        mdWeeklyNotifManager.reshedule()
        XCTAssertTrue(NSDate.areDatesSameDay(mdWeekly.notificationTime!, dateTwo: d1 + 7.day))
    }
    
    func testNotificationDampening(){
        //todo when there is more information
    }

}
