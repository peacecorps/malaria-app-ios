import UIKit
import XCTest
import malaria_ios

class TestSetupInsertClear: XCTestCase {

    var m: MedicineManager!
    let currentPill = Medicine.Pill.Malarone
    
    var currentContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
        m = MedicineManager(context: currentContext)
        m.setup(currentPill, fireDate: NSDate())
    }
    
    override func tearDown() {
        super.tearDown()
        m.clearCoreData()
        UserSettingsManager.clear()
    }
    
    func testCurrentMedicine(){
        if let medi = m.getCurrentMedicine(){
            XCTAssertEqual(medi.name, Medicine.Pill.Malarone.name())
            XCTAssertEqual(medi.frequency, 1.0)
            XCTAssertEqual(medi.registries.count, 0)
        }else{
            XCTFail("Fail initializing:")
        }
    }
    
    func testGetMedicine(){
        if let medi = m.getMedicine(currentPill){
            XCTAssertEqual(medi.name, Medicine.Pill.Malarone.name())
            XCTAssertEqual(medi.frequency, 1.0)
            XCTAssertEqual(medi.registries.count, 0)
        }else{
            XCTFail("Fail initializing:")
        }
    }
    
    func testSetCurrentPill(){
        XCTAssertFalse(m.registerNewMedicine(currentPill))
        XCTAssertTrue(m.registerNewMedicine(Medicine.Pill.Doxycycline))
        XCTAssertEqual(m.getCurrentMedicine()!, m.getMedicine(currentPill)!)
    }
    
    func testRegisteredMedicines(){
        XCTAssertEqual(m.getRegisteredMedicines().count, 1)
    }
    
    
    func testClearMedicines(){
        XCTAssertEqual(true, m.getRegisteredMedicines().count == 1)
        
        m.clearCoreData()
        
        XCTAssertEqual(true, m.getRegisteredMedicines().count == 0)
    }
}
