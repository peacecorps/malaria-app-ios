import XCTest

class TestMedicineStatistics: XCTestCase {

    var m: MedicineManager?
    var mr: MedicineRegistry?
    var d1 = NSDate()
    
    override func setUp() {
        super.setUp()
        m = MedicineManager.sharedInstance
        mr = MedicineRegistry.sharedInstance
        if m == nil || mr == nil{
            XCTFail("Fail initializing")
        }
        
        m!.setup(Medicine.Pill.Malarone, fireDate: NSDate())
        
        mr!.addRegistry(d1, tookMedicine: true)
        mr!.addRegistry(d1 - 1.day, tookMedicine: true)
        mr!.addRegistry(d1 - 2.day, tookMedicine: true)
        mr!.addRegistry(d1 - 3.day, tookMedicine: true)
        mr!.addRegistry(d1 - 4.day, tookMedicine: true)
        mr!.addRegistry(d1 - 5.day, tookMedicine: true)
        mr!.addRegistry(d1 - 6.day, tookMedicine: true)
        mr!.addRegistry(d1 - 7.day, tookMedicine: true)
        mr!.addRegistry(d1 - 8.day, tookMedicine: true)
        mr!.addRegistry(d1 - 9.day, tookMedicine: true)
    }
    
    override func tearDown() {
        super.tearDown()
        mr!.clearCoreData()
    }
    
    func testPillStreak(){
    
    }
    
    func testAdherence(){
        
    }


}
