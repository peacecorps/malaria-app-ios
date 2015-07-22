import Foundation
import UIKit
import QuartzCore

import Charts

@IBDesignable class PillsStatsViewController : UIViewController {
    
    @IBOutlet weak var adherenceSliderTable: UITableView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var graphFrame: UIView!
    @IBOutlet weak var loadingGraphView: CircleProgressView!
    
    @IBInspectable var NoDataText: String = "No entries"
    @IBInspectable var NumberRecentMonths: Int = 4
    @IBInspectable var GraphFillColor: UIColor = UIColor.fromHex(0xA1D4E2)
    @IBInspectable var XAxisLineColor: UIColor = UIColor.fromHex(0x8A8B8A)
    @IBInspectable var RightYAxisLineColor: UIColor = UIColor(red: 0.894, green: 0.429, blue: 0.442, alpha: 1.0)
    @IBInspectable var LeftYAxisLineColor: UIColor = UIColor.fromHex(0x8A8B8A)
    @IBInspectable var AxisFontColor: UIColor = UIColor.fromHex(0x705246)
    
    let TextFont = UIFont(name: "AmericanTypewriter", size: 11.0)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureChart()
    }
    
    func refreshData() {
        self.chartView.clear()
        
        GraphData.sharedInstance.refreshContext()
        graphFrame.bringSubviewToFront(loadingGraphView)
        
        GraphData.sharedInstance.retrieveTookMedicineStats()
        
        GraphData.sharedInstance.retrieveMonthsData(NumberRecentMonths){
            self.adherenceSliderTable.reloadData()
        }
        
        GraphData.sharedInstance.retrieveGraphData({(progress: Float) in
            self.loadingGraphView!.valueProgress = progress
        }, completition: { _ in
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
            adherenceSliderTable.reloadData()
        }
    }
}

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

extension PillsStatsViewController: UITableViewDelegate, UITableViewDataSource{

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
            dataEntries.append(ChartDataEntry(value: values[i], xIndex: i))
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
        chartView.xAxis.avoidFirstLastClippingEnabled = true
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