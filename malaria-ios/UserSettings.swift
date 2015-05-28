import Foundation

enum UserSetting: String{
    //launchScreenFlag
    case DidConfiguredMedicineNotification = "DidConfiguredMedicineNotification"
    
    //setup
    case ReminderTime = "ReminderTime"
    case MedicineName = "MedicineName"
    
    //for statistic measures
    case MedicineLastTake = "MedicineLastTake"
    case DosesInARow = "DosesInARow"
    case AdherenceToMedicine = "AdherenceToMedicine"
}