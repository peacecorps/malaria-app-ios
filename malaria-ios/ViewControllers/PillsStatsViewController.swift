import Foundation
import UIKit
import QuartzCore

import Charts

@IBDesignable class PillsStatsViewController : UIViewController {
    
    @IBOutlet weak var adherenceSliderTable: UITableView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var graphFrame: UIView!
    @IBOutlet weak var loadingGraphView: CircleProgressView!
    
    @IBInspectable let NoDataText: String = "No entries"
    @IBInspectable let NumberRecentMonths: Int = 4
    @IBInspectable let GraphFrameBorderRadius: CGFloat = 20
    @IBInspectable let GraphFillColor: UIColor = UIColor.fromHex(0xA1D4E2)
    @IBInspectable let XAxisLineColor: UIColor = UIColor.fromHex(0x8A8B8A)
    @IBInspectable let RightYAxisLineColor: UIColor = UIColor(red: 0.894, green: 0.429, blue: 0.442, alpha: 1.0)
    @IBInspectable let LeftYAxisLineColor: UIColor = UIColor.fromHex(0x8A8B8A)
    @IBInspectable let AxisFontColor: UIColor = UIColor.fromHex(0x705246)
    
    let TextFont = UIFont(name: "AmericanTypewriter", size: 11.0)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adherenceSliderTable.delegate = self
        adherenceSliderTable.dataSource = self
        adherenceSliderTable.backgroundColor = UIColor.clearColor()
        
        graphFrame.layer.cornerRadius = GraphFrameBorderRadius
        graphFrame.layer.masksToBounds = true
        
        configureChart()
    }
    
    func refreshData() {
        println("RENDERING")
        
        GraphData.sharedInstance.refreshContext()
        graphFrame.bringSubviewToFront(loadingGraphView)
        
        GraphData.sharedInstance.retrieveMonthsData(NumberRecentMonths){
            self.adherenceSliderTable.reloadData()
        }
        
        GraphData.sharedInstance.retrieveGraphData({(progress: Float) in
            self.loadingGraphView!.valueProgress = progress
        }, completition: { _ in
            println("Called")
            self.chartView.clear()
            self.configureData(GraphData.sharedInstance.days, values: GraphData.sharedInstance.adherencesPerDay)
            self.graphFrame.bringSubviewToFront(self.chartView)
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.graphFrame.bringSubviewToFront(self.chartView)
        
        if GraphData.sharedInstance.outdated{
            refreshData()
        }else{
            configureData(GraphData.sharedInstance.days, values: GraphData.sharedInstance.adherencesPerDay)
        }
    }
}

@IBDesignable class AdherenceHorizontalBarCell: UITableViewCell {
    
    @IBInspectable let LowAdherenceColor: UIColor = UIColor(red: 0.894, green: 0.429, blue: 0.442, alpha: 1.0)
    @IBInspectable let HighAdherenceColor: UIColor = UIColor(red: 0.374, green: 0.609, blue: 0.574, alpha: 1.0)
    @IBInspectable let BarHeightScale: CGFloat = 8
    
    
    @IBOutlet weak var month: UILabel!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var adherenceValue: UILabel!
    
    var setup = false
    func configureCell(date: NSDate, adhrenceValue: Float) -> AdherenceHorizontalBarCell{
        if !setup{
            slider.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.0, BarHeightScale)
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

extension PillsStatsViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GraphData.sharedInstance.months.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let month = GraphData.sharedInstance.months[indexPath.row]
        let adherenceValue = GraphData.sharedInstance.statsManager.pillAdherence(month)*100
        
        let cell = tableView.dequeueReusableCellWithIdentifier("AdherenceHorizontalBarCell") as! AdherenceHorizontalBarCell
        cell.configureCell(month, adhrenceValue: adherenceValue)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let monthView = UIStoryboard.instantiate(viewControllerClass: MonthlyViewController.self)
        monthView.startDay = GraphData.sharedInstance.months[indexPath.row]
        
        presentViewController(
            monthView,
            animated: true,
            completion: nil
        )
    }
}

extension PillsStatsViewController{
    
    
    /* Graph View related methods */
    
    func configureData(dataPoints: [NSDate], values: [Float]){
        var dataPointsLabels = dataPoints.map({ $0.formatWith("yyyy.MM.dd")})
        
        var dataEntries: [ChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let adherenceData = configureCharDataSet(dataEntries, label: "")
        let data = LineChartData(xVals: dataPointsLabels, dataSets: [adherenceData])

        chartView.data = data
    }
    
    func configureChart() {
        configureCharView()
        configureLegend()
        configureXAxis()
        configureLeftYAxis()
        configureRightYAxis()
    }
    
    func configureCharDataSet(dataEntries: [ChartDataEntry], label: String) -> ChartDataSet{
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: label)
        lineChartDataSet.colors = [UIColor.clearColor()]
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.drawCirclesEnabled = false
        lineChartDataSet.drawValuesEnabled = false
        
        lineChartDataSet.fillColor = GraphFillColor
        lineChartDataSet.fillAlpha = 1
        
        return lineChartDataSet
    }
    
    func configureLegend(){
        chartView.legend.enabled = false
    }
    
    
    func configureCharView(){
        chartView.descriptionText = ""
        chartView.noDataText = NoDataText
        
        chartView.scaleYEnabled = false
        chartView.doubleTapToZoomEnabled = false
        
        chartView.drawGridBackgroundEnabled = false
        chartView.highlightEnabled = false
        chartView.highlightIndicatorEnabled = false
    }
    
    func configureXAxis(){
        chartView.xAxis.labelPosition = .Bottom
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.xAxis.labelTextColor = AxisFontColor
        chartView.xAxis.labelFont = TextFont
        chartView.xAxis.axisLineColor = XAxisLineColor
        chartView.xAxis.axisLineWidth = 1.0
        chartView.xAxis.avoidFirstLastClippingEnabled = false
    }
    
    func configureRightYAxis(){
        chartView.rightAxis.axisLineColor = RightYAxisLineColor
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.rightAxis.axisLineWidth = 1.0
    }
    
    func configureLeftYAxis(){
        chartView.leftAxis.axisLineColor = LeftYAxisLineColor
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.axisLineWidth = 1.0
        chartView.leftAxis.customAxisMin = 0
        chartView.leftAxis.customAxisMax = 100
        chartView.leftAxis.labelFont = TextFont
        chartView.leftAxis.labelTextColor = AxisFontColor
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.PercentStyle
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.multiplier = 1
        
        chartView.leftAxis.valueFormatter = numberFormatter
    }
}