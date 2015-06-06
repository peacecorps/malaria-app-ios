import UIKit
import XCTest
import malaria_ios

class TestCoreData: XCTestCase {

    var m: MedicineManager?
    
    override func setUp() {
        super.setUp()
        m = MedicineManager.sharedInstance
        if m == nil {
            XCTFail("Fail initializing")
        }
        
        m!.setup(Medicine.Pill.Malarone, fireDate: NSDate())
    }
    
    override func tearDown() {
        //add method to clear CoreData
        m!.clearCoreData()
        
        super.tearDown()
    }

    func testSetup(){
        //getting
        let medicine: Medicine? = m!.getCurrentMedicine()
        
        if let m = medicine{
            m.print()
            XCTAssertEqual(m.name, Medicine.Pill.Malarone.name())
            XCTAssertEqual(m.weekly, false)
            XCTAssertEqual(m.currentStreak, 0)
            XCTAssertEqual(0, m.registries.count)
        }else{
            XCTFail("Error setting up medicine")
        }
    }
    
    func testInsertion() {
        
        let d1 = NSDate()
        m!.updatePillTracker(d1, tookPill: true)
        
        let d2 = d1 + 7.day
        m!.updatePillTracker(d2, tookPill: false)
        
        let d3 = d2 + 7.day
        m!.updatePillTracker(d3, tookPill: true)
        
        logger("-----")
        logger(d1.formatWith("dd-MM-yyyy"))
        logger(d2.formatWith("dd-MM-yyyy"))
        logger(d3.formatWith("dd-MM-yyyy"))
        logger("-----")
        
        //getting
        let medicine: Medicine? = m!.getCurrentMedicine()
        if let med = medicine{
            med.print()
            
            let array: [Registry] = med.registries.convertToArray()
            if(array.count != 3){
                XCTFail("Error registering pills")
            }
            
            let r1: Registry = array[0]
            
            XCTAssertEqual(r1.date, d3)
            XCTAssertEqual(r1.tookMedicine, true)
            
            
            let r2: Registry = array[1]
            
            XCTAssertEqual(r2.date, d2)
            XCTAssertEqual(r2.tookMedicine, false)
            
            let r3: Registry = array[2]
            
            XCTAssertEqual(r3.date, d1)
            XCTAssertEqual(r3.tookMedicine, true)
        }else{
            XCTFail("Error inserting registries pills")
        }
    }

}
