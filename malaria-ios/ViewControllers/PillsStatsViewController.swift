import Foundation
import UIKit

import Charts

class AdherenceHorizontalBarCell: UITableViewCell {
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
    
}

class PillsStatsViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var adherenceSliderTable: UITableView!
    
    var adherences = [Float]()
    
    @IBOutlet weak var chartView: LineChartView!
    
    let leastRecentEntry = NSDate() - 1.year
    let mostRecentEntry = NSDate() - 6.month
    let departureEntry = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adherenceSliderTable.delegate = self
        adherenceSliderTable.dataSource = self
        adherenceSliderTable.backgroundColor = UIColor.clearColor()
        
        graphFrame.layer.cornerRadius = 20
        graphFrame.layer.masksToBounds = true
        
        chartView.delegate = self
        
        
        var days = [NSDate]()
        var adherences = [Float]()
        
        for i in 0...(departureEntry - leastRecentEntry){
            let day = leastRecentEntry + i.day
            days.append(day)
            
            let value = day <= mostRecentEntry ? Float((100 * abs(sin(3.145*Double(i))))) : 0
            
            adherences.append(value)
        }
        
        setChart(days, values: adherences)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        for i in 0...10{
            adherences.append(Float(i+i*10))
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
    
    @IBOutlet weak var graphFrame: UIView!
    let TextFont = UIFont(name: "AmericanTypewriter", size: 10.0)
    //fontColor: UIColor.fromHex(0x705246)
    
    func formatDate(date: NSDate) -> String{
        if !NSDate.areDatesSameDay(date, dateTwo: self.departureEntry) {
            return date.formatWith("yyyy.MM.dd")
        }else {
            return "End of Service"
        }
    }
    
    var circleDataSet: LineChartDataSet!
    func setChart(dataPoints: [NSDate], values: [Float]) {
        var dataPointsLabels = dataPoints.map({ self.formatDate($0)})

        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let adherenceData = configureCharDataSet(dataPointsLabels, dataEntries: dataEntries, label: "")
        
        
        let data = LineChartData(xVals: dataPointsLabels, dataSet: adherenceData)
        
        configureCharView(data)
        
        configureLegend()
        configureXAxis()
        configureLeftYAxis()
        configureRightYAxis()
    }
    
    /*
    func configureCircleView(){
        let lineChartDataSet = LineChartDataSet(yVals: [], label: "")
        lineChartDataSet.colors = [UIColor.clearColor()]
        lineChartDataSet.drawCirclesEnabled = true
        lineChartDataSet.drawValuesEnabled = true
        
        //hightlight line customization
        lineChartDataSet.highlightLineWidth = 0.1
        lineChartDataSet.highlightColor = UIColor.fromHex(0x705246)
        
        lineChartDataSet.fillColor = UIColor.fromHex(0xA1D4E2)
        lineChartDataSet.fillAlpha = 1
        
        return lineChartDataSet
    }*/
    
    func configureCharDataSet(dataPointsLabels: [String], dataEntries: [ChartDataEntry], label: String) -> ChartDataSet{
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: label)
        lineChartDataSet.colors = [UIColor.clearColor()]
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled = false
        
        //hightlight line customization
        lineChartDataSet.highlightLineWidth = 0.1
        lineChartDataSet.highlightColor = UIColor.fromHex(0x705246)
        
        lineChartDataSet.fillColor = UIColor.fromHex(0xA1D4E2)
        lineChartDataSet.fillAlpha = 1
        
        return lineChartDataSet
    }
    
    func configureLegend(){
        chartView.legend.enabled = false
    }
    
    let NoDataText = "There are no entries yet"
    
    
    func configureCharView(data: LineChartData){
        chartView.descriptionText = ""
        chartView.noDataText = NoDataText
        
        chartView.data = data
        chartView.drawGridBackgroundEnabled = false
        chartView.highlightEnabled = true
        chartView.highlightIndicatorEnabled = true
        chartView.highlightPerDragEnabled = true
    }
    
    func configureXAxis(){
        chartView.xAxis.labelPosition = .Bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelTextColor = UIColor.fromHex(0x705246)
        chartView.xAxis.labelFont = TextFont!
        chartView.xAxis.axisLineColor = UIColor.fromHex(0x8A8B8A)
        chartView.xAxis.axisLineWidth = 1.0
        chartView.xAxis.avoidFirstLastClippingEnabled = true
        
        let currentDayLine = ChartLimitLine(limit: Float(mostRecentEntry - leastRecentEntry))
        currentDayLine.lineColor = UIColor(red: 0.894, green: 0.429, blue: 0.442, alpha: 1.0)
        chartView.xAxis.addLimitLine(currentDayLine)
    }
    
    func configureRightYAxis(){
        chartView.rightAxis.enabled = false
    }
    
    func configureLeftYAxis(){
        chartView.leftAxis.axisLineColor = UIColor.fromHex(0x8A8B8A)
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.startAtZeroEnabled = true
        chartView.leftAxis.axisLineWidth = 1.0
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

extension PillsStatsViewController : ChartViewDelegate {
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight){
        //chartView.highlightValue(xIndex: -1, dataSetIndex: highlight.xIndex, callDelegate: false)
        
        if let data = chartView.data,
              charDataSet = data.dataSets[0] as? LineChartDataSet{
                
                println("drawing...")
            
                //charDataSet.drawCirclesEnabled = true
                //charDataSet.drawValuesEnabled = true
                
        }
        
        println("Selected \(entry)")
    }
    
    func chartValueNothingSelected(chartView: ChartViewBase){
        println("deselected")
    }
}