import Foundation
import UIKit

class StateCell: UITableViewCell{
    @IBOutlet weak var statIcon: UIImageView!
    @IBOutlet weak var statLbl: UILabel!
    @IBOutlet weak var statValueLbl: UILabel!
}

protocol Stat{
    var title : String { get }
    var image : UIImage { get }
    var attributeValue : String { get }
}

class Adherence : Stat{
    let context: NSManagedObjectContext
    let medicineManager: MedicineManager
    
    init(context: NSManagedObjectContext){
        self.context = context
        medicineManager = MedicineManager(context: context)
    }
    
    var title : String { return "Adherence to medicine" }
    var image : UIImage { return UIImage(named: "Adherence")! }
    var attributeValue : String {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.PercentStyle
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.multiplier = 1
        
        return numberFormatter.stringFromNumber(100 * medicineManager.getCurrentMedicine()!.stats(context).pillAdherence())!
    }
}

class PillStreak : Stat{
    let context: NSManagedObjectContext
    let medicineManager: MedicineManager
    
    init(context: NSManagedObjectContext){
        self.context = context
        medicineManager = MedicineManager(context: context)
    }
    
    var title : String { return "Doses in a Row" }
    var image : UIImage { return UIImage(named: "DosesInRow")! }
    var attributeValue : String { return "\(medicineManager.getCurrentMedicine()!.stats(context).pillStreak())"}
}

class MedicineLastTaken : Stat{
    let context: NSManagedObjectContext
    let medicineManager: MedicineManager
    
    init(context: NSManagedObjectContext){
        self.context = context
        medicineManager = MedicineManager(context: context)
    }
    
    var title : String { return "Medicine Last Take" }
    var image : UIImage { return UIImage(named: "MedicineLastTaken")! }
    var attributeValue : String {
        for r in medicineManager.getCurrentMedicine()!.registriesManager(context).getRegistries(mostRecentFirst: true){
            if r.tookMedicine{
                return r.date.formatWith("d/M")
            }
        }
        
        return "-/-"
    }
}