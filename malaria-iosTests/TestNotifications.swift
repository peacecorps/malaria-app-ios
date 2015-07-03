import XCTest

class TestNotifications: XCTestCase {
    let m = MedicineManager.sharedInstance
    
    let d1 = NSDate.from(2015, month: 5, day: 8) //monday
    let currentPill = Medicine.Pill.Malarone //dailyPill
    let weeklyPill = Medicine.Pill.Mefloquine //weekly
    
    
    var mdDaily: Medicine!
    var mdWeekly: Medicine!
    
    override func setUp() {
        super.setUp()
        
        m.setup(currentPill, fireDate: d1) //current pill is daily
        m.registerNewMedicine(weeklyPill)
        
        if let medi = m.getCurrentMedicine(),
           let medi2 = m.getMedicine(weeklyPill){
            mdDaily = medi
            mdWeekly = medi2
        }else{
            XCTFail("Fail initializing:")
        }
        
        XCTAssertTrue(mdDaily.registriesManager.addRegistry(d1, tookMedicine: true))
    }
    
    override func tearDown() {
        super.tearDown()
        m.clearCoreData()
    }
    
    
    //only valid in weekly pills
    func testShoudResetNotificationTime(){
        XCTAssertFalse(mdWeekly.notificationManager.checkIfShouldReset(currentDate: d1))
        XCTAssertTrue(mdWeekly.registriesManager.addRegistry(d1, tookMedicine: true))
        
        for i in 1...6 {
            XCTAssertFalse(mdWeekly.notificationManager.checkIfShouldReset(currentDate: d1 + i.day))
        }
        
        XCTAssertTrue(mdWeekly.notificationManager.checkIfShouldReset(currentDate: d1 + 7.day))
    }
    
    func testNotificationTime(){
        //reshedule notification
        mdDaily.notificationManager.reshedule()
        XCTAssertTrue(NSDate.areDatesSameDay(mdDaily.notificationTime!, dateTwo: d1 + 1.day))
        
        //since mdWeekly is not currentPill, this should return nil
        XCTAssertNil(mdWeekly.notificationTime)
        
        //setCurrentPill, current trigger time is not defined yet
        m.setCurrentPill(weeklyPill)
        XCTAssertNil(mdWeekly.notificationTime)
        
        //define currentTime
        mdWeekly.notificationManager.scheduleNotification(d1)
        XCTAssertTrue(NSDate.areDatesSameDay(mdWeekly.notificationTime!, dateTwo: d1))
        
        //add new entry and reshedule
        XCTAssertTrue(mdWeekly.registriesManager.addRegistry(d1, tookMedicine: true))
        mdWeekly.notificationManager.reshedule()
        XCTAssertTrue(NSDate.areDatesSameDay(mdWeekly.notificationTime!, dateTwo: d1 + 7.day))
    }
    
    func testNotificationDampening(){
        //todo when there is more information
    }

}
