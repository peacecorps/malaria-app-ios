import Foundation
import UIKit

@IBDesignable class ListItemsViewController : UIViewController, UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var tableView: UITableView!

    @IBInspectable var TextColor: UIColor = UIColor(hex: 0x6F5247)
    
    
    let TextFont = UIFont(name: "ChalkboardSE-Regular", size: 16.0)!
    var initialItems: [String]!
    var completitionHandler: ([String] -> ())!
    
    var listItems: [String : Bool] = [
        "Toilet paper" : false,
        "Luggage Lock" : false,
        "Flashlight" : false,
        "Compass" : false,
        "Whistle" : false,
        "Sewing Kit" : false,
        "Repair tape" : false,
        "Deodorant" : false,
        "Nail clipper" : false,
        "Towels" : false,
        "Tweezers" : false,
        "Pen" : false,
        "Notebook" : false,
        "Map" : false,
        "Passaport" : false,
        "Travelling ticket" : false,
        "Shaving blade" : false,
        "Extra batteries" : false,
        "Watch" : false,
    ]
    
    var sortedItems: [String] = []
    
    @IBAction func cancelBtnHandler(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func doneBtnHandler(sender: AnyObject) {
        var selected = [String]()
        for (key, value) in listItems{
            if value {
                selected.append(key)
            }
        }
        
        completitionHandler(selected)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        for i in initialItems{
            println("setting up initial items")
            listItems[i]? = true
        }
        
        sortedItems = [String] (listItems.keys).sorted({$0 < $1})
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedItems.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50.0
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item: String = sortedItems[indexPath.row]
        
        let wasSelected: Bool = listItems[item]!
        listItems[item] = !wasSelected
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = wasSelected ? UITableViewCellAccessoryType.None : UITableViewCellAccessoryType.Checkmark
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = sortedItems[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("itemCell") as! UITableViewCell
        
        let isSelected: Bool = listItems[item]!
        cell.accessoryType = isSelected ? UITableViewCellAccessoryType.Checkmark : UITableViewCellAccessoryType.None
        cell.textLabel?.font = TextFont
        cell.textLabel?.textColor = TextColor
        cell.textLabel?.text = item
        
        return cell
    }
}