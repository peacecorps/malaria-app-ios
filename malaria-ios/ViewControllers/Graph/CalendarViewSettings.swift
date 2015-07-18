import Foundation
import UIKit

class CalendarVisualSettings {
    var SelectedColor = UIColor.fromHex(0x009DE0)
    var SelectedColorAlpha: CGFloat = 1.0
    var UnselectedTextColor = UIColor.fromHex(0x444444)
    var InsideMonthTextColor = UIColor.fromHex(0x444444)
    var OutSideMonthTextColor = UIColor.fromHex(0x999999)
    var SelectedTextBackgroundColor = UIColor.whiteColor()
    var WeekDayFont = UIFont(name: "AmericanTypewriter", size: 13)!
    var WeekDaySelectedFont = UIFont(name: "AmericanTypewriter", size: 13)!
    var DayWeekTextFont = UIFont(name: "AmericanTypewriter", size: 11)!
    var DayWeekTextColor = UIColor.fromHex(0x444444)
    var CurrentDayUnselectedCircleFillColor = UIColor.fromHex(0xF7F7F7)
    var SelectedDayDotMarkerColor = UIColor.whiteColor()
}