import UIKit

public class ToolbarWithDone: UIToolbar {
    
    public init (target: NSObject, selector: Selector) {
        super.init(frame: CGRectZero)
        sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: target, action: selector)
        items = [flexBarButton, doneBarButton]
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}