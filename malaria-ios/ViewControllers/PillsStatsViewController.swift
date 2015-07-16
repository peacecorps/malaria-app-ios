import Foundation
import UIKit
import SwiftCharts

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
    
    @IBOutlet weak var chartView: UIView!
    private var chart: Chart? // arc
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adherenceSliderTable.delegate = self
        adherenceSliderTable.dataSource = self
        adherenceSliderTable.backgroundColor = UIColor.clearColor()
        
        chartView.layer.cornerRadius = 20
        chartView.layer.masksToBounds = true
        
        println(UIFont.fontNamesForFamilyName("American Typewriter"))
        
        gen2()
        //generateGraph()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        adherences = [
            0,
            10,
            20,
            30,
            40,
            50,
            60,
            70,
            80,
            90,
            100
        ]
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
    
    let TextFont = UIFont(name: "AmericanTypewriter", size: 14.0)
    
    
    
    private var iPhoneChartSettings: ChartSettings {
        let chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 20
        chartSettings.trailing = 10
        chartSettings.bottom = 20
        chartSettings.labelsToAxisSpacingX = 10
        chartSettings.labelsToAxisSpacingY = 10
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8

        return chartSettings
    }
    
    func createChartPoint(x: CGFloat, _ y: CGFloat, _ labelSettings: ChartLabelSettings) -> ChartPoint {
        return ChartPoint(x: ChartAxisValueFloat(x, labelSettings: labelSettings), y: ChartAxisValueFloat(y))
    }
    
    
    func generateAxis(values: [ChartAxisValue], text: String, settings: ChartLabelSettings) -> ChartAxisModel{
        return ChartAxisModel(axisValues: values, lineColor: UIColor.grayColor(), axisTitleLabel: ChartAxisLabel(text: text, settings: settings))
    }
    
    
    //https://github.com/i-schuetz/SwiftCharts/blob/fbe06bad96ab5fa53f6cd6f53c89f5f71f441ad1/Examples/Examples/Examples/TrackerExample.swift
    
    
    func gen2(){
        let labelSettings = ChartLabelSettings(font: TextFont!, fontColor: UIColor.fromHex(0x705246))
        
        let chartPoints = [
            self.createChartPoint(0, 0, labelSettings),
            self.createChartPoint(1, 100, labelSettings),
            self.createChartPoint(2, 10, labelSettings),
            self.createChartPoint(3, 90, labelSettings),
            self.createChartPoint(4, 20, labelSettings),
            self.createChartPoint(5, 80, labelSettings),
            self.createChartPoint(6, 30, labelSettings),
            self.createChartPoint(7, 70, labelSettings),
            self.createChartPoint(8, 40, labelSettings),
            self.createChartPoint(9, 60, labelSettings),
            self.createChartPoint(10, 50, labelSettings),
            self.createChartPoint(11, 55, labelSettings),
            self.createChartPoint(12, 55, labelSettings)
        ]
        
        let xValues = Array(stride(from: 0, through: 12, by: 1)).map {ChartAxisValueFloat($0, labelSettings: labelSettings)}
        let yValues = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(chartPoints, minSegmentCount: 4, maxSegmentCount: 4, multiple: 25, axisValueGenerator: {ChartAxisValueFloat($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
        
        let xModel = generateAxis(xValues, text: "Date", settings: labelSettings)
        let yModel = generateAxis(yValues, text: "Adherence", settings: labelSettings)

        let scrollViewFrame = self.chartView.bounds
        let chartFrame = CGRectMake(0, 10, 1000, scrollViewFrame.size.height - 10)
        
        let chartSettings = iPhoneChartSettings
        
        
        // calculate coords space in the background to keep UI smooth
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
            let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
            
            dispatch_async(dispatch_get_main_queue()) {
                let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
                
                let lineModel = ChartLineModel(chartPoints: chartPoints, lineColor: UIColor.clearColor(), animDuration: 1, animDelay: 0)
                let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel])
                
                let chartPointsLayer1 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints, areaColor: UIColor.fromHex(0xA1D4E2), animDuration: 3, animDelay: 0, addContainerPoints: true)
                
                let scrollView = UIScrollView(frame: scrollViewFrame)
                scrollView.contentSize = CGSizeMake(chartFrame.size.width, scrollViewFrame.size.height)
                
                let chart = Chart(
                    frame: chartFrame,
                    layers: [
                        xAxis,
                        yAxis,
                        chartPointsLineLayer,
                        chartPointsLayer1
                    ]
                )
                self.chartView.clipsToBounds = true
                
                
                scrollView.addSubview(chart.view)
                self.chartView.addSubview(scrollView)
                self.chart = chart
                
            }
        }
    
    }
    
}