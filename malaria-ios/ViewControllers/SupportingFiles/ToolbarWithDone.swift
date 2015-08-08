import UIKit

public class ToolbarWithDone: UIToolbar {
    public var viewsWithToolbar: [UIView] = []
    
    private let DoneButtonHeight: CGFloat = 40.0
    private let DoneButtonWidth: CGFloat  = 100.0
    
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
    
    public func generateInputView(view: UIView, inputHeight: CGFloat = 200) -> UIView{
        let screenWidth = UIScreen.mainScreen().bounds.width
        let inputView = UIView(frame: CGRectMake(0, 0, screenWidth, inputHeight + DoneButtonHeight))
        let inputViewSize = view.frame.size.width
        
        view.frame.origin.x = screenWidth*0.5 - inputViewSize*0.5
        inputView.addSubview(view)
        
        return inputView
    }
    
    //sender is a UIBarButtonItem
    internal func dismissInputView(sender: UIView){
        viewsWithToolbar.map({ $0.endEditing(true) })
    }
}
