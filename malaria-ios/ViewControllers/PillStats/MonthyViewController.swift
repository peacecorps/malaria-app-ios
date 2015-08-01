import Foundation
import UIKit

@IBDesignable class MonthlyViewController: UIViewController {
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var calendarFrame: UIView!
    
    @IBInspectable var LowAdherenceColor: UIColor = UIColor(red: 0.894, green: 0.429, blue: 0.442, alpha: 1.0)
    @IBInspectable var HighAdherenceColor: UIColor = UIColor(red: 0.374, green: 0.609, blue: 0.574, alpha: 1.0)
    
    @IBInspectable var SelectedBackgroundColor: UIColor = UIColor(hex: 0xE3C79B)
    @IBInspectable var SelectedTodayBackgroundColor: UIColor = UIColor(hex: 0xE3C79B)
    @IBInspectable var UnselectedTextColor: UIColor = UIColor(hex: 0x444444)
    @IBInspectable var UnselectedTodayTextColor: UIColor = UIColor.blackColor()
    @IBInspectable var DayWeekTextColor: UIColor = UIColor(hex: 0x444444)
    @IBInspectable var CurrentDayUnselectedCircleFillColor: UIColor = UIColor(hex: 0xA1D4E2)//UIColor(red: 0.894, green: 0.429, blue: 0.442, alpha: 1.0)
    @IBInspectable var SelectedDayDotMarkerColor: UIColor = UIColor.blackColor()
    @IBInspectable var InsideMonthTextColor: UIColor = UIColor(hex: 0x444444)
    @IBInspectable var OutSideMonthTextColor: UIColor = UIColor(hex: 0x999999)
    @IBInspectable var SelectedTextBackgroundColor: UIColor = UIColor.blackColor()
    
    let WeekDayFont = UIFont(name: "AmericanTypewriter", size: 14)!
    let WeekDaySelectedFont = UIFont(name: "AmericanTypewriter", size: 14)!
    let DayWeekTextFont = UIFont(name: "AmericanTypewriter", size: 12)!
    
    //provided by previousViewController
    var startDay: NSDate!
    var callback: (() -> ())?
    
    private var previouslySelect: NSDate?
    private var animationFinished = true
    private let RingViewTag = 123
    
    //hack because CVCalendar doesn't support updates yet
    private var dayViews = [NSDate : Set<DayView>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("Calendar View did load")
        
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
        callback?()
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
    
    func createRingView(dayView: DayView, tookMedicine: Bool) -> CVAuxiliaryView {
        let ringView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
        ringView.fillColor = UIColor.clearColor()
        ringView.strokeColor = tookMedicine ? HighAdherenceColor : LowAdherenceColor
        ringView.tag = RingViewTag
        return ringView
    }
    
    func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
        if let  date = dayView.date,
                registryDate = date.convertedDate(),
                tookMedicine = CachedStatistics.sharedInstance.tookMedicine[registryDate.startOfDay]{
            return createRingView(dayView, tookMedicine: tookMedicine)
        }
        
        return UIView()
    }
    
    func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        if let  date = dayView.date,
                registryDate = date.convertedDate(){
                    
            //hack
            if let d = dayView.date.convertedDate(){
                if dayViews[d.startOfDay] == nil {
                    dayViews[d.startOfDay] = Set<DayView>()
                }
                dayViews[d.startOfDay]!.insert(dayView)
            }
            
            return CachedStatistics.sharedInstance.tookMedicine[registryDate.startOfDay] != nil
        }

        return false
    }
}

extension MonthlyViewController: CVCalendarViewDelegate {
    func firstWeekday() -> Weekday {
        switch (NSCalendar.currentCalendar().firstWeekday % 7) {
        case 0:
            return .Saturday
        case 1:
            return .Sunday
        case 2:
            return .Monday
        case 3:
            return .Tuesday
        case 4:
            return .Wednesday
        case 5:
            return .Thursday
        case 6:
            return .Friday
        default:
            return .Sunday
        }
    }
    
    func shouldShowWeekdaysOut() -> Bool { return true }                                        /// show all days
    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool { return false }            /// hide line above day
    
    func didSelectDayView(dayView: CVCalendarDayView) {
        let selected = dayView.date.convertedDate()!
        if let previous = previouslySelect{
            if previous.sameDayAs(selected) {
                if let registryDate = dayView.date.convertedDate(){
                    popup(registryDate.startOfDay, dayView: dayView)
                }
            }
        }
        
        previouslySelect = selected
    }
    
    func popup(date: NSDate, dayView: CVCalendarDayView){
        if date > NSDate() {
            var failAlert = UIAlertController(title: "Not possible to change entries in the future.", message: "Try another day", preferredStyle: .Alert)
            failAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
            presentViewController(failAlert, animated: true, completion: nil)
            
            return
        }
        
        let isWeekly = CachedStatistics.sharedInstance.medicine.isWeekly()
        let tookMedicine = CachedStatistics.sharedInstance.registriesManager.tookMedicine(date)
        
        var title = ""
        var message = ""
        
        if tookMedicine != nil {
            title = "You already took your " + (isWeekly ? "weekly" : "daily") + " pill."
            message = "Have you taken your pill?"
        } else {
            title = "You did not took your " + (isWeekly ? "weekly" : "daily") + " pill."
            message = "Have you taken your pill?"
        }
        
        let tookPillActionSheet: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        
        tookPillActionSheet.addAction(UIAlertAction(title:"Yes, I did.", style: .Default, handler: { _ in
            println("Pressed yes")
            if CachedStatistics.sharedInstance.registriesManager.addRegistry(date, tookMedicine: true, modifyEntry: true) {
                let d1 = (isWeekly ? date - 8.day : date).startOfDay
                let d2 = (isWeekly ? date + 8.day : date).startOfDay
                CachedStatistics.sharedInstance.updateTookMedicineStats(d1, d2: d2)
                
                self.updateDayView(date, dayView: dayView, isWeekly: isWeekly, tookMedicine: true)
            }else {
                self.generateErrorMessage()
            }
        }))
        
        tookPillActionSheet.addAction(UIAlertAction(title:"No I didn't.", style: .Default, handler: { _ in
            println("pressed no")
            if CachedStatistics.sharedInstance.registriesManager.addRegistry(date, tookMedicine: false, modifyEntry: true) {
                let d1 = (isWeekly ? date - 8.day : date).startOfDay
                let d2 = (isWeekly ? date + 8.day : date).startOfDay
                CachedStatistics.sharedInstance.updateTookMedicineStats(d1, d2: d2)
                
                self.updateDayView(date, dayView: dayView, isWeekly: isWeekly, tookMedicine: false)
            }else {
                self.generateErrorMessage()
            }
        }))
        
        
        tookPillActionSheet.addAction(UIAlertAction(title:"Cancel", style: .Cancel, handler: nil))
        presentViewController(tookPillActionSheet, animated: true, completion: nil)
    }
    
    func generateErrorMessage() {
        let errorAlert: UIAlertController = UIAlertController(title: "Error updating", message: "Did you already take your pill?", preferredStyle: .Alert)
        errorAlert.addAction(UIAlertAction(title:"Dismiss", style: .Default, handler: nil))
        presentViewController(errorAlert, animated: true, completion: nil)
    }
    
    ///hack until library offers what we need
    func updateDayView(date: NSDate, dayView: CVCalendarDayView, isWeekly: Bool, tookMedicine: Bool) {
        func updateDayView(dayView: CVCalendarDayView, tookMedicine: Bool){
            if let ringView = dayView.viewWithTag(RingViewTag){
                (ringView as? CVAuxiliaryView)!.strokeColor = tookMedicine ? HighAdherenceColor : LowAdherenceColor
            }else {
                dayView.insertSubview(createRingView(dayView, tookMedicine: tookMedicine), atIndex: 0)
            }
        }
        
        if isWeekly {
            for i in -8...8 {
                let day = (date + i.day).startOfDay
                if day.sameWeekAs(date){
                    for view in dayViews[day]!{
                        updateDayView(view, CachedStatistics.sharedInstance.tookMedicine[day]!)
                    }
                }
            }
        }else {
            updateDayView(dayView, CachedStatistics.sharedInstance.tookMedicine[date.startOfDay]!)
        }
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