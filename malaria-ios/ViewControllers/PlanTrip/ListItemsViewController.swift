import Foundation
import UIKit

@IBDesignable class ListItemsViewController : UIViewController{
    @IBOutlet weak var tableView: UITableView!
    @IBInspectable var DeleteButtonColor: UIColor = UIColor(hex: 0xA9504A)
    
    //must be provided by previous viewController
    var departure: NSDate!
    var arrival: NSDate!
    var listItems: [(String, Bool)] = []
    var completitionHandler: ((Medicine.Pill, [(String, Bool)]) -> ())!
    
    //internal
    var medicine: Medicine.Pill!
    var medicineManager: MedicineManager!
    var viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: "longPressHandler:")
        longPressGestureRecognizer.minimumPressDuration = 1.5
        longPressGestureRecognizer.delegate = self
        tableView.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @IBAction func cancelBtnHandler(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doneBtnHandler(sender: AnyObject) {
        completitionHandler(medicine, listItems)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        viewContext = CoreDataHelper.sharedInstance.createBackgroundContext()!
        medicineManager = MedicineManager(context: viewContext)
        
        if let trip = TripsManager(context: viewContext).getTrip() {
            medicine = Medicine.Pill(rawValue: trip.medicine)!
        }else {
            medicine = Medicine.Pill(rawValue: medicineManager.getCurrentMedicine()!.name)!
        }
        
        self.listItems.sort({ $0.0.lowercaseString < $1.0.lowercaseString })
        
        tableView.reloadData()
    }
}

extension ListItemsViewController : UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
    
    func longPressHandler(gestureRecognizer:UIGestureRecognizer) {
        let p = gestureRecognizer.locationInView(tableView)
        
        if let indexPath = tableView.indexPathForRowAtPoint(p) {
            if gestureRecognizer.state == UIGestureRecognizerState.Began {
                modifyItem(indexPath: indexPath)
            }
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        var deleteButton = UITableViewRowAction(style: .Default, title: "Delete", handler: { (action, indexPath) in
            self.listItems.removeAtIndex(indexPath.row)
            tableView.reloadData()
        })
        deleteButton.backgroundColor = DeleteButtonColor
        return [deleteButton]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            listItems.removeAtIndex(indexPath.row)
            tableView.reloadData()
        }
    }
    
    @IBAction func addNewItem(sender: AnyObject) {
        modifyItem()
    }
    
    func modifyItem(indexPath: NSIndexPath? = nil) {
        let modifySelectedEntry = indexPath != nil
        
        let title = modifySelectedEntry ? "Change item" : "What do you want to bring to the trip?"
        let message = ""
        
        var alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Done", style: .Default) { _ in
            let textField = alert.textFields![0] as! UITextField
            
            if modifySelectedEntry {
                self.listItems[indexPath!.row].0 = textField.text
                self.listItems[indexPath!.row].1 = false
            }else if !textField.text.isEmpty && self.listItems.filter({$0.0.lowercaseString == textField.text!.lowercaseString}).isEmpty {
                let tuple = (textField.text!, false)
                self.listItems.append(tuple)
            }
            
            self.listItems.sort({ $0.0.lowercaseString < $1.0.lowercaseString })
            
            self.tableView.reloadData()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        alert.addTextFieldWithConfigurationHandler { (textField: UITextField!) -> Void in
            textField.placeholder = "Name"
            textField.text = modifySelectedEntry ? self.listItems[indexPath!.row].0 : ""
        }
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = (tableView.dequeueReusableCellWithIdentifier("MedicineHeaderCell") as! MedicineHeaderCell)
        cell.name.setTitle(medicine.name(), forState: .Normal)
        cell.quantity.text = "\(MedicineStats.numberNeededPills(departure, date2: arrival, interval: self.medicine.interval())) pills"
        
        cell.name.titleLabel?.adjustsFontSizeToFitWidth = true
        return cell.contentView
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 78.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = listItems[indexPath.row]
        
        TripsManager(context: viewContext).getTrip()?.itemsManager(viewContext).toggleCheckItem([item.0])
        
        let isSelected = item.1
        listItems[indexPath.row].1 = !isSelected
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = listItems[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell") as! ItemCell
        return cell.configureCell(item.0, broughtItem: item.1)
    }
    
    @IBAction func medicineBtn(sender: AnyObject) {
        var alert = UIAlertController(title: "What do you want to bring to the trip?", message: "Pick one medicine", preferredStyle: .Alert)
        let medicines = Medicine.Pill.allValues.map({$0.name()})
        for m in medicines {
            alert.addAction(UIAlertAction(title: m, style: .Default) { _ in
                self.medicine = Medicine.Pill(rawValue: m)!
                self.tableView.reloadData()
            })
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

class ItemCell : UITableViewCell {
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var hasItem: UIView!
    
    @IBInspectable var BroughtItemColor: UIColor = UIColor(hex: 0x96C262)
    @IBInspectable var DidNotBringItemColor: UIColor = UIColor(hex: 0xDF8782)
    
    func configureCell(name: String, broughtItem: Bool) -> ItemCell {
        self.name.text = name
        hasItem.borderColor = broughtItem ? BroughtItemColor : DidNotBringItemColor
        
        return self
    }
}

class MedicineHeaderCell : UITableViewCell {
    @IBOutlet weak var name: UIButton!
    @IBOutlet weak var quantity: UILabel!
}