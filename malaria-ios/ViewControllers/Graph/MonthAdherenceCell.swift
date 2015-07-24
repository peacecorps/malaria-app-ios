import Foundation
import UIKit

@IBDesignable class AdherenceHorizontalBarCell: UITableViewCell {
    @IBInspectable var LowAdherenceColor: UIColor = UIColor(red: 0.894, green: 0.429, blue: 0.442, alpha: 1.0)
    @IBInspectable var HighAdherenceColor: UIColor = UIColor(red: 0.374, green: 0.609, blue: 0.574, alpha: 1.0)
    
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var adherenceValue: UILabel!
    
    func configureCell(date: NSDate, adhrenceValue: Float) -> AdherenceHorizontalBarCell{
        slider.minimumTrackTintColor = adhrenceValue < 50 ? LowAdherenceColor : HighAdherenceColor
        slider.value = adhrenceValue
        month.text = (date.formatWith("MMM") as NSString).substringToIndex(3).capitalizedString
        adherenceValue.text = "\(Int(adhrenceValue))%"
        
        return self
    }
}