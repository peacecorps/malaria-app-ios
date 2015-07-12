import Foundation
import UIKit

protocol Stat{
    var title : String { get }
    var image : UIImage { get }
    var attributeValue : String { get }
}

class Adherence : Stat{
    var context: NSManagedObjectContext
    var medicineManager: MedicineManager!

    init(context: NSManagedObjectContext){
        self.context = context
        medicineManager = MedicineManager(context: context)
    }
    
    var title : String { return "Adherence to medicine" }
    var image : UIImage { return UIImage(named: "Adherence")! }
    var attributeValue : String { return "\(100 * medicineManager.getCurrentMedicine()!.stats(context).pillAdherence())%"}
}

class PillStreak : Stat{
    var context: NSManagedObjectContext
    var medicineManager: MedicineManager!
    
    init(context: NSManagedObjectContext){
        self.context = context
        medicineManager = MedicineManager(context: context)
    }
    var title : String { return "Doses in a Row" }
    var image : UIImage { return UIImage(named: "DosesInRow")! }
    var attributeValue : String { return "\(medicineManager.getCurrentMedicine()!.stats(context).pillStreak())"}
}

class MedicineLastTaken : Stat{
    var context: NSManagedObjectContext
    var medicineManager: MedicineManager!
    
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

class DailyStatsTableViewController : UITableViewController{
    
    
    var listStats: [Stat] = []
    
    var viewContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        
        listStats = [
            MedicineLastTaken(context: viewContext),
            PillStreak(context: viewContext),
            Adherence(context: viewContext)
        ]
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listStats.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 125.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let stat = listStats[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("statCell") as! StateCell
        cell.statLbl.text = stat.title
        cell.statIcon.image = stat.image
        cell.statValueLbl.text = stat.attributeValue
        
        return cell
    }
}

class StateCell: UITableViewCell{
    @IBOutlet weak var statIcon: UIImageView!
    @IBOutlet weak var statLbl: UILabel!
    @IBOutlet weak var statValueLbl: UILabel!
}