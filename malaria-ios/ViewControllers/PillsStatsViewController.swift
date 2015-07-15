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
        
        generateGraph()
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
    
    let TextFont = UIFont(name: "ChalkboardSE-Regular", size: 16.0)
    
    func genChartFrame(containerBounds: CGRect) -> CGRect {
        return CGRectMake(0, 0, containerBounds.size.width, containerBounds.size.height)
    }
    
    
    private var iPhoneChartSettings: ChartSettings {
        let chartSettings = ChartSettings()
        chartSettings.leading = 10
        chartSettings.top = 10
        chartSettings.trailing = 10
        chartSettings.bottom = 10
        chartSettings.labelsToAxisSpacingX = 5
        chartSettings.labelsToAxisSpacingY = 5
        chartSettings.axisTitleLabelsToLabelsSpacing = 4
        chartSettings.axisStrokeWidth = 0.2
        chartSettings.spacingBetweenAxesX = 8
        chartSettings.spacingBetweenAxesY = 8

        return chartSettings
    }
    
    //https://github.com/i-schuetz/SwiftCharts/blob/fbe06bad96ab5fa53f6cd6f53c89f5f71f441ad1/Examples/Examples/Examples/TrackerExample.swift
    func generateGraph(){
        let labelSettings = ChartLabelSettings(font: TextFont!)
        
        //limited to three because clipping.
        let chartPoints1 = [(0, 15), (1, 30), (2, 45)/*, (3, 60), (4, 75), (5, 80), (6, 90), (7, 100)*/].map{ChartPoint(x: ChartAxisValueInt($0.0, labelSettings: labelSettings), y: ChartAxisValueInt($0.1))}
        
        let allChartPoints = sorted(chartPoints1) {(obj1, obj2) in return obj1.x.scalar < obj2.x.scalar}
        
        let xValues = ChartAxisValuesGenerator.generateXAxisValuesWithChartPoints(allChartPoints, minSegmentCount: 0, maxSegmentCount: 3, multiple: 1, axisValueGenerator: {ChartAxisValueFloat($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
        
        
        //let xValues: [ChartAxisValue] = (NSOrderedSet(array: allChartPoints).array as! [ChartPoint]).map{$0.x}
        
        let yValues = ChartAxisValuesGenerator.generateYAxisValuesWithChartPoints(allChartPoints, minSegmentCount: 1, maxSegmentCount: 4, multiple: 25, axisValueGenerator: {ChartAxisValueFloat($0, labelSettings: labelSettings)}, addPaddingSegmentIfEdge: false)
        
        let xModel = ChartAxisModel(axisValues: xValues, axisTitleLabel: ChartAxisLabel(text: "Date", settings: labelSettings))
        let yModel = ChartAxisModel(axisValues: yValues, axisTitleLabel: ChartAxisLabel(text: "Adherence", settings: labelSettings))
        let chartFrame = genChartFrame(self.chartView.frame)
        let chartSettings = iPhoneChartSettings
        
        let coordsSpace = ChartCoordsSpaceLeftBottomSingleAxis(chartSettings: chartSettings, chartFrame: chartFrame, xModel: xModel, yModel: yModel)
        let (xAxis, yAxis, innerFrame) = (coordsSpace.xAxis, coordsSpace.yAxis, coordsSpace.chartInnerFrame)
        
        let chartPointsLayer1 = ChartPointsAreaLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, chartPoints: chartPoints1, areaColor: UIColor.blueColor(), animDuration: 3, animDelay: 0, addContainerPoints: true)
        
        
        let lineModel1 = ChartLineModel(chartPoints: chartPoints1, lineColor: UIColor.clearColor(), animDuration: 1, animDelay: 0)
        let chartPointsLineLayer = ChartPointsLineLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, lineModels: [lineModel1])
        
        var settings = ChartGuideLinesDottedLayerSettings(linesColor: UIColor.blackColor(), linesWidth: 0.1)
        let guidelinesLayer = ChartGuideLinesDottedLayer(xAxis: xAxis, yAxis: yAxis, innerFrame: innerFrame, settings: settings)
        
        let chart = Chart(
            frame: chartFrame,
            layers: [
                xAxis,
                yAxis,
                guidelinesLayer,
                chartPointsLayer1,
                chartPointsLineLayer,
            ]
        )
        
        self.chartView.addSubview(chart.view)
        self.chart = chart
    }
    
}