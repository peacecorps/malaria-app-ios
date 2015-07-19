import UIKit

///based on 2 or 3 tutorials
@IBDesignable class CircleProgressView: UIView {
    
    ///to be modified in the storyboard
    @IBInspectable var lineWidth: CGFloat = 4.0
    @IBInspectable var circleColor: UIColor = UIColor.grayColor()
    @IBInspectable var progressColor: UIColor = UIColor.greenColor()
    @IBInspectable var valueProgress: Float = Float()
    @IBInspectable var clockWise: Bool = true
    
    private let backgroundCircle = CAShapeLayer()
    private let progressCircle = CAShapeLayer()
    
    /// must be in range 0-1
    var statusProgress: Float {
        get { return self.statusProgress }
        set(status) { self.progressCircle.strokeEnd = CGFloat(status) / 100 }
    }
    
    override func drawRect(rect: CGRect) {
        // Create path
        let centerPointArc = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        let radiusArc: CGFloat = self.frame.width / 2 * 0.8
        var circlePath = UIBezierPath(arcCenter: centerPointArc, radius: radiusArc, startAngle: radial_angle(0), endAngle: radial_angle(360), clockwise: clockWise)
        
        // Define background circle still to be loaded
        backgroundCircle.path = circlePath.CGPath
        backgroundCircle.strokeColor = circleColor.CGColor
        backgroundCircle.fillColor = UIColor.clearColor().CGColor
        backgroundCircle.lineWidth = CGFloat(lineWidth)
        backgroundCircle.strokeStart = 0
        backgroundCircle.strokeEnd = CGFloat(1.0)
        
        // Define circle showing loading
        progressCircle.path = circlePath.CGPath
        progressCircle.strokeColor = progressColor.CGColor
        progressCircle.fillColor = UIColor.clearColor().CGColor
        progressCircle.lineWidth = CGFloat(lineWidth) + 0.1
        progressCircle.strokeStart = 0
        progressCircle.strokeEnd = CGFloat(valueProgress) / 100
        
        // set layers
        layer.addSublayer(backgroundCircle)
        layer.addSublayer(progressCircle)
    }
    
    private func radial_angle(arc: CGFloat) -> CGFloat {
        return CGFloat(M_PI) * arc / 180
    }
    
    func changeLineWidth(size: CGFloat) {
        backgroundCircle.lineWidth = size
        progressCircle.lineWidth = size + 0.1
    }
}