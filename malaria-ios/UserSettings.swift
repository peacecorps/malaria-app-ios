import Foundation

enum UserSetting: String{
    static let allValues = [DidConfiguredMedicineNotification, ReminderTime, MedicineName, MedicineLastRegistry, DosesInARow, AdherenceToMedicine]
    
    
    //launchScreenFlag
    case DidConfiguredMedicineNotification = "DidConfiguredMedicineNotification"
    
    //setup
    case MedicineStartTime = "MedicineStartTime"
    case ReminderTime = "ReminderTime"
    case MedicineName = "MedicineName"
    
    //for statistic measures
    case MedicineLastRegistry = "MedicineLastRegistry"
    case DosesInARow = "DosesInARow"
    
    //(# of doses taken)/(# of doses that should have been taken)
    case AdherenceToMedicine = "AdherenceToMedicine"
}