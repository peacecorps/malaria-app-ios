import Foundation
import UIKit

protocol Stat{
    var title : String { get }
    var image : UIImage { get }
    var attributeValue : String { get }
}

class Adherence : Stat{
    var title : String { return "Adherence to medicine" }
    var image : UIImage { return UIImage(named: "Adherence")! }
    var attributeValue : String { return "\(100 * MedicineManager.sharedInstance.getCurrentMedicine()!.stats.pillAdherence())%"}
}

class PillStreak : Stat{
    var title : String { return "Doses in a Row" }
    var image : UIImage { return UIImage(named: "DosesInRow")! }
    var attributeValue : String { return "\(MedicineManager.sharedInstance.getCurrentMedicine()!.stats.pillStreak())"}
}

class MedicineLastTaken : Stat{
    var title : String { return "Medicine Last Take" }
    var image : UIImage { return UIImage(named: "MedicineLastTaken")! }
    var attributeValue : String {
        if let mostRecentEntry = MedicineManager.sharedInstance.getCurrentMedicine()!.registriesManager.mostRecentEntry(){
            return mostRecentEntry.date.formatWith("dd-MM")
        }
        
        return "+oo"
    }
}

class DailyStatsTableViewController : UITableViewController{
    let listStats: [Stat] = [
        MedicineLastTaken(),
        PillStreak(),
        Adherence()
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
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