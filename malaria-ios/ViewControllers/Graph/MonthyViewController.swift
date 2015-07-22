import Foundation
import UIKit

@IBDesignable class MonthlyViewController: UIViewController {
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarFrame: UIView!
    
    @IBInspectable var LowAdherenceColor: UIColor = UIColor(red: 0.894, green: 0.429, blue: 0.442, alpha: 1.0)
    @IBInspectable var HighAdherenceColor: UIColor = UIColor(red: 0.374, green: 0.609, blue: 0.574, alpha: 1.0)
    
    @IBInspectable var SelectedBackgroundColor: UIColor = UIColor.fromHex(0xE3C79B)
    @IBInspectable var SelectedTodayBackgroundColor: UIColor = UIColor.fromHex(0xE3C79B)
    @IBInspectable var UnselectedTextColor: UIColor = UIColor.fromHex(0x444444)
    @IBInspectable var UnselectedTodayTextColor: UIColor = UIColor.whiteColor()
    @IBInspectable var DayWeekTextColor: UIColor = UIColor.fromHex(0x444444)
    @IBInspectable var CurrentDayUnselectedCircleFillColor: UIColor = UIColor(red: 0.894, green: 0.429, blue: 0.442, alpha: 1.0)
    @IBInspectable var SelectedDayDotMarkerColor: UIColor = UIColor.blackColor()
    @IBInspectable var InsideMonthTextColor: UIColor = UIColor.fromHex(0x444444)
    @IBInspectable var OutSideMonthTextColor: UIColor = UIColor.fromHex(0x999999)
    @IBInspectable var SelectedTextBackgroundColor: UIColor = UIColor.blackColor()
    
    let WeekDayFont = UIFont(name: "AmericanTypewriter", size: 14)!
    let WeekDaySelectedFont = UIFont(name: "AmericanTypewriter", size: 14)!
    let DayWeekTextFont = UIFont(name: "AmericanTypewriter", size: 12)!
    
    var previouslySelect: NSDate?
    
    var startDay: NSDate!
    var animationFinished = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        monthLabel.text = generateMonthLabel(startDay)
        calendarView.toggleViewWithDate(startDay)
    }
        
    func generateMonthLabel(date: NSDate) -> String {
        return date.formatWith("MMMM, yyyy").capitalizedString
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
    
    @IBAction func closeBtnHandler(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func previousMonthToggle(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    @IBAction func nextMonthToggle(sender: AnyObject) {
        calendarView.loadNextView()
    }
    
    @IBAction func todayMonthView() {
        calendarView.toggleCurrentDayView()
    }
}

extension MonthlyViewController: CVCalendarViewDelegate {
    func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool { return false }
    
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
        circleView.fillColor = CurrentDayUnselectedCircleFillColor
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        return dayView.isCurrentDay
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        if let date = dayView.date,
            registryDate = date.convertedDate(),
            tookMedicine = GraphData.sharedInstance.tookMedicine[registryDate.startOfDay]{
                let ringView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
                ringView.fillColor = UIColor.clearColor()
                ringView.strokeColor = tookMedicine ? HighAdherenceColor : LowAdherenceColor
                
                return ringView
        }
        
        return UIView()
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if let date = dayView.date,
            registryDate = date.convertedDate(){
                return GraphData.sharedInstance.tookMedicine[registryDate.startOfDay] != nil
        }

        return false
    }
    
}

extension MonthlyViewController: CVCalendarViewDelegate {
    func firstWeekday() -> Weekday { return .Sunday }                                           /// first week day is sunday
    func shouldShowWeekdaysOut() -> Bool { return true }                                        /// show all days
    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool { return false }            /// hide line above day
    
    func didSelectDayView(dayView: CVCalendarDayView) {
        let selected = dayView.date.convertedDate()!
        if let previous = previouslySelect{
            if NSDate.areDatesSameDay(previous, dateTwo: selected) {
                if let registryDate = dayView.date.convertedDate(){
                    popup(registryDate)
                }
            }
        }
        
        previouslySelect = selected
    }
    
    func popup(date: NSDate){
        let isWeekly = GraphData.sharedInstance.medicine.isWeekly()
        let existsEntry = GraphData.sharedInstance.registriesManager.findRegistry(date) != nil
        let tookMedicine = GraphData.sharedInstance.registriesManager.tookMedicine(date)
        
        var title = ""
        var message = ""
        
        if existsEntry && tookMedicine {
            title = "You already took your " + (isWeekly ? "weekly" : "daily") + " pill."
            message = "Have you taken your pill?"
        } else if existsEntry && !tookMedicine{
            title = "You did not took your " + (isWeekly ? "weekly" : "daily") + " pill."
            message = "Have you taken your pill?"
        } else {
            title = "There is no entry in that date."
            message = "Have you taken your pill?"
        }
        
        let tookPillActionSheet: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        
        tookPillActionSheet.addAction(UIAlertAction(title:"Yes, I did.", style: .Default, handler:{ action in
            println("Pressed yes")
            GraphData.sharedInstance.registriesManager.addRegistry(date, tookMedicine: true, modifyEntry: true)
        }))
        
        tookPillActionSheet.addAction(UIAlertAction(title:"No I didn't.", style: .Default, handler:{ action in
            println("pressed nop")
            GraphData.sharedInstance.registriesManager.addRegistry(date, tookMedicine: false, modifyEntry: true)
        }))
        
        tookPillActionSheet.addAction(UIAlertAction(title:"Cancel", style: .Cancel, handler: nil))
        presentViewController(tookPillActionSheet, animated: true, completion: nil)
    }
    
    func presentedDateUpdated(date: CVDate) {
        if monthLabel.text != generateMonthLabel(date.convertedDate()!) && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.text = generateMonthLabel(date.convertedDate()!)
            
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
                }) { _ in
                    
                    self.animationFinished = true
                    self.monthLabel.frame = updatedMonthLabel.frame
                    self.monthLabel.text = updatedMonthLabel.text
                    self.monthLabel.transform = CGAffineTransformIdentity
                    self.monthLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    

}

extension MonthlyViewController: CVCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool { return false }
    
    /// Generic days settings
    func dayLabelWeekdaySelectedBackgroundColor() -> UIColor { return SelectedBackgroundColor }
    func dayLabelWeekdaySelectedBackgroundAlpha() -> CGFloat { return 1.0 }
    func dayLabelWeekdayInTextColor() -> UIColor { return UnselectedTextColor }
    func dayLabelWeekdayOutTextColor() -> UIColor { return OutSideMonthTextColor }
    func dayLabelWeekdaySelectedTextColor() -> UIColor { return SelectedTextBackgroundColor }
    func dayLabelWeekdayFont() -> UIFont { return WeekDayFont }
    func dayLabelWeekdaySelectedFont() -> UIFont { return WeekDaySelectedFont }
    
    /// current day settings
    func dayLabelPresentWeekdaySelectedBackgroundColor() -> UIColor { return SelectedTodayBackgroundColor }
    func dayLabelPresentWeekdaySelectedBackgroundAlpha() -> CGFloat { return 1.0 }
    func dayLabelPresentWeekdaySelectedTextColor() -> UIColor { return SelectedTextBackgroundColor }
    func dayLabelPresentWeekdayTextColor() -> UIColor{ return UnselectedTodayTextColor }
    func dayLabelPresentWeekdayFont() -> UIFont { return WeekDayFont }
    func dayLabelPresentWeekdaySelectedFont() -> UIFont { return WeekDaySelectedFont }
}

extension MonthlyViewController: CVCalendarMenuViewDelegate {
    func presentationMode() -> CalendarMode { return .MonthView }
    func dayOfWeekTextColor() -> UIColor { return DayWeekTextColor }
    func dayOfWeekTextUppercase() -> Bool { return true }
    func dayOfWeekFont() -> UIFont { return DayWeekTextFont }
}