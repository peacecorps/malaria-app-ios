import UIKit
import XCTest
import malaria_ios


class TestUserSettings: XCTestCase {
    
    override func setUp() {
        super.setUp()
        UserSettingsManager.clear()
    }
    
    override func tearDown() {
        super.tearDown()
        UserSettingsManager.clear()
    }
    
    func testGetSet() {
        //dont forget to reset iOS Simulator
        XCTAssertFalse(UserSettingsManager.UserSetting.DidConfiguredMedicine.getBool())
        UserSettingsManager.UserSetting.DidConfiguredMedicine.setBool(true)
        XCTAssertTrue(UserSettingsManager.UserSetting.DidConfiguredMedicine.getBool())
        UserSettingsManager.UserSetting.DidConfiguredMedicine.setBool(false)
        XCTAssertFalse(UserSettingsManager.UserSetting.DidConfiguredMedicine.getBool())
    }
    
    func testUndefinedValue() {
        XCTAssertEqual(UserSettingsManager.UserSetting.TripReminderOption.getString(defaultValue: "Bla"), "Bla")
        XCTAssertTrue(UserSettingsManager.UserSetting.DidConfiguredMedicine.getBool(defaultValue: true))
    }
}