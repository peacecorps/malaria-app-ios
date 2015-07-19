import Foundation
import UIKit
import QuartzCore

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

class PillsStatsViewController : UIViewController {
    
    @IBOutlet weak var adherenceSliderTable: UITableView!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var graphFrame: UIView!
    
    let TextFont = UIFont(name: "AmericanTypewriter", size: 11.0)!
    let NoDataText = "There are no entries yet"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        adherenceSliderTable.delegate = self
        adherenceSliderTable.dataSource = self
        adherenceSliderTable.backgroundColor = UIColor.clearColor()
        
        graphFrame.layer.cornerRadius = 20
        graphFrame.layer.masksToBounds = true
        
        configureChart()
    }
    
    func refreshData() {
        println("RENDERING")
        chartView.data?.clearValues()
        println("DONE CLEARING VALUES")
        
        GraphData.sharedInstance.retrieveMonthsData(4){
            self.adherenceSliderTable.reloadData()
        }
        
        GraphData.sharedInstance.retrieveGraphData(){
            self.configureData(GraphData.sharedInstance.days, values: GraphData.sharedInstance.adherencesPerDay)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if GraphData.sharedInstance.outdated{
            GraphData.sharedInstance.refresh()
            refreshData()
        }else{
            configureData(GraphData.sharedInstance.days, values: GraphData.sharedInstance.adherencesPerDay)
        }
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
        println("Configuring data")
        
        var dataPointsLabels = dataPoints.map({ $0.formatWith("yyyy.MM.dd")})
        
        if let data = chartView.data{
            let datSet = data.getDataSetByLabel("Adherence", ignorecase: true)
            for i in 0..<dataPoints.count {
                datSet!.addEntry(ChartDataEntry(value: values[i], xIndex: i))
            }
        }else{
            println("wtf?")
        }
        
        

    }
    
    func configureChart() {
        println("Configuring chart")
        configureCharView()
        configureLegend()
        configureXAxis()
        configureLeftYAxis()
        configureRightYAxis()
        
        let dataSet = createCharDataSet("Adherence")
        let data = ChartData(xVals: ["DummyValue"], dataSet: dataSet)
        chartView.data = data
        configureDataSetView(dataSet)
        println("DONE RECONFIGURING")
    }
    
    func configureDataSetView(adherenceDataSet: LineChartDataSet){
        adherenceDataSet.colors = [UIColor.clearColor()]
        adherenceDataSet.drawFilledEnabled = true
        adherenceDataSet.drawCirclesEnabled = false
        adherenceDataSet.drawValuesEnabled = false
        adherenceDataSet.fillColor = UIColor.fromHex(0xA1D4E2)
        adherenceDataSet.fillAlpha = 1
    }
    
    func createCharDataSet(label: String) -> LineChartDataSet{
        let dummyEntry = ChartDataEntry(value: 100, xIndex: 0)
        return LineChartDataSet(yVals: [], label: label)
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
        chartView.xAxis.labelTextColor = UIColor.fromHex(0x705246)
        chartView.xAxis.labelFont = TextFont
        chartView.xAxis.axisLineColor = UIColor.fromHex(0x8A8B8A)
        chartView.xAxis.axisLineWidth = 1.0
        chartView.xAxis.avoidFirstLastClippingEnabled = false
    }
    
    func configureRightYAxis(){
        chartView.rightAxis.axisLineColor = UIColor(red: 0.894, green: 0.429, blue: 0.442, alpha: 1.0)
        chartView.rightAxis.drawGridLinesEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.rightAxis.axisLineWidth = 1.0
    }
    
    func configureLeftYAxis(){
        chartView.leftAxis.axisLineColor = UIColor.fromHex(0x8A8B8A)
        chartView.leftAxis.drawGridLinesEnabled = false
        chartView.leftAxis.axisLineWidth = 1.0
        chartView.leftAxis.customAxisMin = 0
        chartView.leftAxis.customAxisMax = 100
        chartView.leftAxis.labelFont = TextFont
        chartView.leftAxis.labelTextColor = UIColor.fromHex(0x705246)
        
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.PercentStyle
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.multiplier = 1
        
        chartView.leftAxis.valueFormatter = numberFormatter
    }
}