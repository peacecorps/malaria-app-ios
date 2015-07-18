import Foundation
import UIKit

class CalendarVisualSettings {
    var SelectedBackgroundColor = UIColor.fromHex(0x009DE0)
    var SelectedBackgroundColorAlpha: CGFloat = 1.0
    
    var SelectedTodayBackgroundColor = UIColor.fromHex(0x009DE0)
    var SelectedTodayBackgroundColorAlpha: CGFloat = 1.0
    
    var UnselectedTextColor = UIColor.fromHex(0x444444)
    var UnselectedTodayTextColor = UIColor.whiteColor()
    
    
    var InsideMonthTextColor = UIColor.fromHex(0x444444)
    var OutSideMonthTextColor = UIColor.fromHex(0x999999)
    var SelectedTextBackgroundColor = UIColor.whiteColor()
    var WeekDayFont = UIFont(name: "AmericanTypewriter", size: 14)!
    var WeekDaySelectedFont = UIFont(name: "AmericanTypewriter", size: 14)!
    var DayWeekTextFont = UIFont(name: "AmericanTypewriter", size: 12)!
    var DayWeekTextColor = UIColor.fromHex(0x444444)
    var CurrentDayUnselectedCircleFillColor = UIColor(red: 0.894, green: 0.429, blue: 0.442, alpha: 1.0)//UIColor.fromHex(0xFFDF98)
    var SelectedDayDotMarkerColor = UIColor.whiteColor()
}