import XCTest
import malaria_ios

class TestPlanTrip: XCTestCase {

    var tManager: TripsManager!
    
    let location = "Heaven"
    let currentPill = Medicine.Pill.Malarone
    let cashToBring: Int64 = 10
    let d1 = NSDate.from(2015, month: 5, day: 8) //monday
    let d2 = NSDate.from(2015, month: 5, day: 8) + 1.week//monday
    let reminderTime = NSDate.from(1, month: 1, day: 1, hour: 9, minute: 0)
    var trip: Trip!
    var itemsManager: ItemsManager!
    var currentContext: NSManagedObjectContext!
    
    override func setUp() {
        super.setUp()
        
        currentContext = CoreDataHelper.sharedInstance.createBackgroundContext()
        
        tManager = TripsManager(context: currentContext)        
        trip = tManager.createTrip(location, medicine: currentPill, departure: d1, arrival: d2, timeReminder: reminderTime)
        
        itemsManager = trip.itemsManager(currentContext)
    }
    
    override func tearDown() {
        super.tearDown()
        tManager.clearCoreData()
    }
    
    func testGetTrip(){
        if let t = tManager.getTrip(){
            XCTAssertEqual(t, trip)
            XCTAssertEqual(t.location, location)
            XCTAssertEqual(t.medicine, currentPill.name())
            XCTAssertEqual(t.departure, d1)
            XCTAssertEqual(t.arrival, d2)
            XCTAssertTrue(t.reminderTime.sameClockTimeAs(reminderTime))
        }else{
            XCTFail("Trip wasn't created")
        }
    }
    
    func testCreateAnotherTrip(){
        let location2 = "Alabama"
        let pill2 = Medicine.Pill.Mefloquine
        let cash: Int64 = 9000
        let departure2 = d1 + 10.day
        let arrival2 = d1 + 20.day
        
        trip = tManager.createTrip(location2, medicine: pill2, departure: departure2, arrival: arrival2, timeReminder: reminderTime)
        
        XCTAssertEqual(trip.location, location2)
        XCTAssertEqual(trip.medicine, pill2.name())
        XCTAssertEqual(trip.departure, departure2)
        XCTAssertEqual(trip.arrival, arrival2)
        XCTAssertTrue(trip.reminderTime.sameClockTimeAs(reminderTime))

        if let t = tManager.getTrip(){
            XCTAssertEqual(t.location, location2)
            XCTAssertEqual(t.medicine, pill2.name())
            XCTAssertEqual(trip.departure, departure2)
            XCTAssertEqual(trip.arrival, arrival2)
            XCTAssertTrue(trip.reminderTime.sameClockTimeAs(reminderTime))

        }else{
            XCTFail("Trip wasn't created")
        }
    }
    
    
    func testAddItems(){
        itemsManager.addItem("lantern", quantity: 1)
        XCTAssertEqual(trip.items.count, 1)
        
        itemsManager.addItem("Stress Ball", quantity: 2)
        XCTAssertEqual(trip.items.count, 2)
        
        
        if let  lantern = itemsManager.findItem("lantern"),
                lanternUpper = itemsManager.findItem("Lantern")
        {
            XCTAssertEqual(lantern.quantity, 1)
        }else{
            XCTFail("findItem lantern not found")
        }
        
        if let streessBall = itemsManager.findItem("Stress Ball"){
            XCTAssertEqual(streessBall.quantity, 2)
        }
        
        //check case insensitive
        XCTAssertTrue(itemsManager.getItems().count == 2)
    }
    
    
    func testAddQuantity(){
        itemsManager.addItem("lantern", quantity: 1)
        
        if let lantern = itemsManager.findItem("lantern"){
            XCTAssertEqual(lantern.quantity, 1)
        }else{
            XCTFail("findItem lantern not found")
        }
        
        XCTAssertEqual(trip.items.count, 1)
        
        //add more 3 lanterns to the trip ( 3 + 1)
        itemsManager.addItem("lantern", quantity: 3)
        
        if let lantern = itemsManager.findItem("lantern"){
            XCTAssertEqual(lantern.quantity, 4)
        }else{
            XCTFail("findItem lantern not found")
        }
        
        XCTAssertEqual(trip.items.count, 1)
    }
    
    func testRemoveItem(){
        //test simple decrement
        itemsManager.addItem("lantern", quantity: 6)
        itemsManager.removeItem("lantern", quantity: 2)
        
        if let lantern = itemsManager.findItem("lantern"){
            XCTAssertEqual(lantern.quantity, 4)
        }else{
            XCTFail("findItem lantern not found")
        }
        
        XCTAssertEqual(trip.items.count, 1)
        
        //test removing more elements that there is. The item must be removed
        itemsManager.removeItem("lantern", quantity: 30)
        
        if let lantern = itemsManager.findItem("lantern"){
            XCTFail("item was not removed despite")
        }
        
        
        //adding again
        itemsManager.addItem("lantern", quantity: 9)
        if let lantern = itemsManager.findItem("LANTERN"){
            XCTAssertEqual(lantern.quantity, 9)
        }else{
            XCTFail("findItem lantern not found")
        }
        
        XCTAssertEqual(trip.items.count, 1)
        
        //removing again
        itemsManager.removeItem("lantern")
        if let lantern = itemsManager.findItem("lantern"){
            XCTFail("item was not removed despite")
        }
        
        XCTAssertEqual(trip.items.count, 0)
    }
    
    func testCheckItems() {
        //TODO
    }
    
    func testCascadeDelete(){
        XCTAssertEqual(Item.retrieve(Item.self, context: currentContext).count, 0)
        itemsManager.addItem("lantern", quantity: 6)
        itemsManager.addItem("medalion", quantity: 2)
        XCTAssertEqual(Item.retrieve(Item.self, context: currentContext).count, 2)
        
        Trip.clear(Trip.self, context: currentContext)
        XCTAssertEqual(Item.retrieve(Item.self, context: currentContext).count, 0)
    }
    
    
}
