import Foundation
import UIKit

class MedicineNotificationsManager : NotificationManager{
    override var category: String { get{ return "PillReminder"} }

    var medicine: Medicine!
    
    init(medicine: Medicine){
        self.medicine = medicine
    }
    
    func scheduleNotification(fireTime: NSDate){
        unsheduleNotification()
        
        let notification: UILocalNotification = createNotification(fireTime, alertBody: "hello", alertAction: "double")
        super.scheduleNotification(notification)
        
        medicine.notificationTime = fireTime
    }
    
    override func unsheduleNotification(){
        super.unsheduleNotification()
        CoreDataHelper.sharedInstance.saveContext()
    }

    func reshedule(){
        if var nextTime = medicine.notificationTime{
            nextTime += medicine.isDaily() ? 1.day : 7.day
            medicine.notificationTime = nextTime
        }
        
        if medicine.isCurrent{
            Logger.Error("Error: there should be already a fire date")
        }
    }
    
    func checkIfShouldReset(currentDate: NSDate = NSDate()) -> Bool{
        if let mostRecent = medicine.registriesManager.mostRecentEntry(){
            //get ellaped days
            return (currentDate - mostRecent) > 7
        }
        
        Logger.Warn("There is no registry yet registred")
        return false
    }
}