import Foundation
import UIKit

import Charts

class AdherenceHorizontalBarCell: UITableViewCell{
    
    
    let HighAdherenceComponents: [CGFloat] = [0.894, 0.429, 0.442]
    let LowAdherenceComponents: [CGFloat] = [0.374, 0.609, 0.574]

    let LowAdherenceColor = UIColor(red: 0.894, green: 0.429, blue: 0.442, alpha: 1.0)
    let HighAdherenceColor = UIColor(red: 0.374, green: 0.609, blue: 0.574, alpha: 1.0)
    
    
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var adherenceValue: UILabel!

    
    var setup = false
    func configureCell(date: NSDate, adhrenceValue: Float) -> AdherenceHorizontalBarCell{
        if !setup{
            slider.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 8)
            slider.setThumbImage(UIImage(), forState: UIControlState.Normal)
            slider.maximumTrackTintColor = UIColor.whiteColor()
            setup = true
        }
        
        slider.minimumTrackTintColor = adhrenceValue < 50 ? LowAdherenceColor : HighAdherenceColor
        
        slider.value = adhrenceValue
        month.text = (date.formatWith("MMM") as NSString).substringToIndex(3).capitalizedString
        adherenceValue.text = "\(Int(adhrenceValue))%"
        
        return self
    }
    
    
    //not working. In progress
    func interpolatedColor(start: [CGFloat], end: [CGFloat], progress: Float) -> UIColor {
        if start.count != 3 || end.count != 3 {
            return UIColor.blackColor()
        }
        
        let red = start[0]
        let green = start[1]
        let blue = start[2]
        
        let redEnd = end[0]
        let greenEnd = end[1]
        let blueEnd = end[2]

        let newRed   = CGFloat((1.0 - progress)) * red   + CGFloat(progress) * redEnd
        let newGreen = CGFloat((1.0 - progress)) * green + CGFloat(progress) * greenEnd
        let newBlue  = CGFloat((1.0 - progress)) * blue  + CGFloat(progress) * blueEnd
        
        println("----")
        println("progress: \(progress)")
        println("\(1.0 - progress)")
        let aux = CGFloat((1.0) - progress) * red
        println("\(aux)")
        let aux2 = CGFloat(progress) * redEnd
        println("\(aux2)")
        println("Red \(red) -> \(newRed)")
        println("Red \(green) -> \(newGreen)")
        println("Red \(blue) -> \(newBlue)")
        
        return UIColor(red: newBlue, green: newGreen, blue: newBlue, alpha: 1.0)
    }

    
}

class PillsStatsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var adherenceSliderTable: UITableView!
    
    var adherences = [Float]()
    
    @IBOutlet weak var chartView: LineChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adherenceSliderTable.delegate = self
        adherenceSliderTable.dataSource = self
        adherenceSliderTable.backgroundColor = UIColor.clearColor()
        
        chartView.layer.cornerRadius = 20
        chartView.layer.masksToBounds = true
        
        var days = [NSDate]()
        var adherences = [Float]()
        
        for i in 0...5{
           days.append(NSDate() + i.day)
           adherences.append(Float(arc4random_uniform(100)))
        }
        
        
        setChart(days, values: adherences)
        
        //generateGraph()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        for i in 0...100{
            adherences.append(Float(i))
        }
        
    }
    
    
    /* Adhrence Slider Table related methods */
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adherences.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let adherenceValue = adherences[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AdherenceHorizontalBarCell") as! AdherenceHorizontalBarCell
        cell.configureCell(NSDate() + indexPath.row.month, adhrenceValue: adherenceValue)
        
        return cell
    }
    
    /* Graph View related methods */
    
    let TextFont = UIFont(name: "AmericanTypewriter", size: 10.0)
    //fontColor: UIColor.fromHex(0x705246)
    
    func setChart(dataPoints: [NSDate], values: [Float]) {
        
        var dataPointsLabels = dataPoints.map({ $0.formatWith("yyyy.M")})

        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Adherence")
        lineChartDataSet.colors = [UIColor.blueColor()]
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.fillColor = UIColor.fromHex(0xA1D4E2)
        lineChartDataSet.lineWidth = 0
        
        let lineChartData = LineChartData(xVals: dataPointsLabels, dataSet: lineChartDataSet)
    
        
        chartView.legend.enabled = false
        chartView.noDataText = "There are no entries yet"

        chartView.data = lineChartData
        chartView.drawGridBackgroundEnabled = false
        chartView.highlightEnabled = false
    
        chartView.xAxis.labelPosition = .Bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelTextColor = UIColor.fromHex(0x705246)
        chartView.xAxis.labelFont = TextFont!
        chartView.xAxis.axisLineColor = UIColor.fromHex(0x8A8B8A)
        chartView.xAxis.axisLineWidth = 4.0
        
        chartView.rightAxis.enabled = false
        /*
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.rightAxis.axisLineColor = UIColor(red: 0.894, green: 0.429, blue: 0.442, alpha: 1.0)
        chartView.rightAxis.axisLineWidth = 4.0
        */
        
        chartView.leftAxis.axisLineColor = UIColor.fromHex(0x8A8B8A)
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.startAtZeroEnabled = true
        chartView.leftAxis.axisLineWidth = 4.0
        chartView.leftAxis.customAxisMax = 100
        chartView.leftAxis.labelFont = TextFont!
        chartView.leftAxis.labelTextColor = UIColor.fromHex(0x705246)
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.PercentStyle
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.multiplier = 1

        chartView.leftAxis.valueFormatter = numberFormatter
        
    }
    
}