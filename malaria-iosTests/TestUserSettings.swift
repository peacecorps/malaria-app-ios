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
    }
    
    func testGetSet() {
        //dont forget to reset iOS Simulator
        XCTAssertEqual(false, UserSettingsManager.getDidConfiguredMedicine())
        UserSettingsManager.setDidConfiguredMedicine(true)
        XCTAssertEqual(true, UserSettingsManager.getDidConfiguredMedicine())
        UserSettingsManager.setDidConfiguredMedicine(false)
        XCTAssertEqual(false, UserSettingsManager.getDidConfiguredMedicine())
    }
}
