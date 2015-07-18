import Foundation
import UIKit

class MonthlyViewController: UIViewController {
    @IBOutlet weak var calendarView: CVCalendarView!
    @IBOutlet weak var menuView: CVCalendarMenuView!
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet weak var calendarFrame: UIView!
    let calendarVisualSettings = CalendarVisualSettings()
    
    var startDay: NSDate!
    var animationFinished = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        calendarFrame.layer.cornerRadius = 20
        calendarFrame.layer.masksToBounds = true
        
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
    func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
        let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
        circleView.fillColor = calendarVisualSettings.CurrentDayUnselectedCircleFillColor
        return circleView
    }
    
    func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
        return dayView.isCurrentDay
    }
}

extension MonthlyViewController: CVCalendarViewDelegate {
    func firstWeekday() -> Weekday { return .Sunday }                                           /// first week day is sunday
    func shouldShowWeekdaysOut() -> Bool { return true }                                        /// show all days
    func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool { return false }            /// hide line above day
    
    func didSelectDayView(dayView: CVCalendarDayView) {
        println("\(calendarView.presentedDate.commonDescription) is selected!")
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
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    
    /// Generic days settings
    func dayLabelWeekdaySelectedBackgroundColor() -> UIColor {
        return calendarVisualSettings.SelectedBackgroundColor
    }
    
    func dayLabelWeekdaySelectedBackgroundAlpha() -> CGFloat {
        return calendarVisualSettings.SelectedBackgroundColorAlpha
    }
    
    func dayLabelWeekdayInTextColor() -> UIColor {
        return calendarVisualSettings.UnselectedTextColor
    }
    
    func dayLabelWeekdayOutTextColor() -> UIColor {
        return calendarVisualSettings.OutSideMonthTextColor
    }
    
    func dayLabelWeekdaySelectedTextColor() -> UIColor {
        return calendarVisualSettings.SelectedTextBackgroundColor
    }
    
    func dayLabelWeekdayFont() -> UIFont {
        return calendarVisualSettings.WeekDayFont
    }
    
    func dayLabelWeekdaySelectedFont() -> UIFont {
        return calendarVisualSettings.WeekDaySelectedFont
    }
    
    /// current day settings
    func dayLabelPresentWeekdaySelectedBackgroundColor() -> UIColor {
        return calendarVisualSettings.SelectedTodayBackgroundColor
    }
    
    func dayLabelPresentWeekdaySelectedBackgroundAlpha() -> CGFloat {
        return calendarVisualSettings.SelectedTodayBackgroundColorAlpha
    }
    
    func dayLabelPresentWeekdaySelectedTextColor() -> UIColor {
        return calendarVisualSettings.SelectedTextBackgroundColor
    }
    
    func dayLabelPresentWeekdayTextColor() -> UIColor{
        return calendarVisualSettings.UnselectedTodayTextColor
    }
    
    func dayLabelPresentWeekdayFont() -> UIFont {
        return calendarVisualSettings.WeekDayFont
    }
    
    func dayLabelPresentWeekdaySelectedFont() -> UIFont {
        return calendarVisualSettings.WeekDaySelectedFont
    }
}

extension MonthlyViewController: CVCalendarMenuViewDelegate {
    func presentationMode() -> CalendarMode { return .MonthView }
    func dayOfWeekTextColor() -> UIColor { return calendarVisualSettings.DayWeekTextColor }
    func dayOfWeekTextUppercase() -> Bool { return true }
    func dayOfWeekFont() -> UIFont { return calendarVisualSettings.DayWeekTextFont }
}