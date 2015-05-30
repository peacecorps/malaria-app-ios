import UIKit
import XCTest

class TestUserSettings: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserSettingsManager.clear()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testGetSet() {
        //dont forget to reset iOS Simulator
        XCTAssertEqual(false, UserSettingsManager.getBool(UserSetting.DidConfiguredMedicineNotification))
        UserSettingsManager.setBool(UserSetting.DidConfiguredMedicineNotification, true)
        XCTAssertEqual(true, UserSettingsManager.getBool(UserSetting.DidConfiguredMedicineNotification))
        UserSettingsManager.setBool(UserSetting.DidConfiguredMedicineNotification, false)
        XCTAssertEqual(false, UserSettingsManager.getBool(UserSetting.DidConfiguredMedicineNotification))
        
        
        let medicine = UserSettingsManager.getObject(UserSetting.MedicineName) as! String?
        if let m = medicine{
            XCTFail("Medicine should not be stored yet")
        }else{
            XCTAssertTrue(true, "medicine not defined yet")
        }
        
        
        UserSettingsManager.setObject(UserSetting.MedicineName, "Vicodin")
        XCTAssertEqual("Vicodin", UserSettingsManager.getObject(UserSetting.MedicineName) as! String)
        UserSettingsManager.setObject(UserSetting.MedicineName, "Nop")
        XCTAssertEqual("Nop", UserSettingsManager.getObject(UserSetting.MedicineName) as! String)
    }
    
    
    func testClear(){
        //add element if there is isn't one
        let medicine = UserSettingsManager.getObject(UserSetting.MedicineName) as! String?
        if let m = medicine{
            //do nothing
        }else{
            UserSettingsManager.setObject(UserSetting.MedicineName, "Vicodin")
        }
        
        UserSettingsManager.clear()
        
        let m2 =  UserSettingsManager.getObject(UserSetting.MedicineName) as! String?
        if let m = medicine{
            XCTFail("Should not exist since we had cleared UserDefault")
        }

    }
}
