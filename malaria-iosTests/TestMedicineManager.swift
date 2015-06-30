import UIKit
import XCTest
import malaria_ios

class TestSetupInsertClear: XCTestCase {

    let m: MedicineManager = MedicineManager.sharedInstance
    let currentPill = Medicine.Pill.Malarone
    
    override func setUp() {
        super.setUp()
        
        m.setup(currentPill, fireDate: NSDate())
    }
    
    override func tearDown() {
        super.tearDown()
        
        m.clearCoreData()
    }
    
    func testCurrentMedicine(){
        if let medi = m.getCurrentMedicine(){
            XCTAssertEqual(medi.name, Medicine.Pill.Malarone.name())
            XCTAssertEqual(medi.weekly, false)
            XCTAssertEqual(medi.registries.count, 0)
        }else{
            XCTFail("Fail initializing:")
        }
    }
    
    func testGetMedicine(){
        if let medi = m.getMedicine(currentPill){
            XCTAssertEqual(medi.name, Medicine.Pill.Malarone.name())
            XCTAssertEqual(medi.weekly, false)
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
        let medicines = m.getRegisteredMedicines()
        XCTAssertEqual(true, medicines.count == 1)
        
        m.clearCoreData()
        
        let medicines2 = m.getRegisteredMedicines()
        XCTAssertEqual(true, medicines2.count == 0)
    }
}
