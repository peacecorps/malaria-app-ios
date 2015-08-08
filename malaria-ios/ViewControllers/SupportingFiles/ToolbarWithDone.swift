import UIKit

public class ToolbarWithDone: UIToolbar {
    public var viewsWithToolbar: [UIView] = []
    
    public init (viewsWithToolbar: [UIView]) {
        self.viewsWithToolbar = viewsWithToolbar
        super.init(frame: CGRectZero)
        
        sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace,target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: Selector("dismissInputView:"))
        items = [flexBarButton, doneBarButton]
    }

    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    //sender is a UIBarButtonItem
    internal func dismissInputView(sender: UIView){
        viewsWithToolbar.map({ $0.endEditing(true) })
    }
}
