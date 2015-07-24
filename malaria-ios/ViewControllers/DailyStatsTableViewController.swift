import Foundation
import UIKit

class DailyStatsTableViewController : UITableViewController{
    
    var listStats: [Stat] = []
    var viewContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationEvents.ObserveEnteredForeground(self, selector: "refreshScreen")
    }
    
    deinit{
        NSNotificationEvents.UnregisterAll(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshScreen()
    }
    
    func refreshScreen() {
        viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
        listStats = [
            MedicineLastTaken(context: viewContext),
            PillStreak(context: viewContext),
            Adherence(context: viewContext)
        ]
        
        tableView.reloadData()
    }
}

//MARK: Table View Controller related methods
extension DailyStatsTableViewController{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listStats.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 125.0
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