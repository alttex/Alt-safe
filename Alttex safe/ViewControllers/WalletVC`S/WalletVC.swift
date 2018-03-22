//
//  WalletsVC.swift
//  Alttex_messager
//
//  Created by Vlad Kovryzhenko on 1/18/18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import Foundation
import UIKit
import Charts
import UIKit
import CoreData

class WalletsViewController: ChartsVC {
    
    var managedObjextContext:NSManagedObjectContext!
    var NewPriceCoin = [CoinPrice]()
    var coinPrice = [String]()
    
    @IBAction func addCoinBtn(_ sender: UIBarButtonItem) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "allCoinsVC") //as! NavVC
        self.present(vc!, animated: false, completion: nil)
    }
    
    @IBOutlet var chartView: BarChartView!
    @IBAction func moreBtnTapped(_ sender: UIBarButtonItem) {
        handleOption(Option.saveToGallery, forChartView: chartView)
    }
    
    var options: [Option]!
    let dataLabels = ["100", "200","300","400","500","600"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get Api info
        coinPrice =  ApiHelper.getCoinValue()
        
        //Context
        managedObjextContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Data from databse about coin
        getDataFromCD()
      
        
        self.title = "Wallets"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        chartView.highlightPerDragEnabled = false
        chartView.drawValueAboveBarEnabled = true
        chartView.autoScaleMinMaxEnabled = true
        chartView.fitBars = true
        handleOption(Option.animateXY, forChartView: chartView)
        
        
        // Do any additional setup after loading the view.
        self.options = [.toggleValues,
                        .toggleHighlight,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .saveToGallery,
                        .togglePinchZoom,
                        .toggleAutoScaleMinMax,
                        .toggleData,
                        .toggleBarBorders]
        
        self.setup(barLineChartView: chartView)
        chartView.delegate = self
        chartView.setExtraOffsets(left: 12, top: -15, right: 12, bottom: -50)
        chartView.drawBarShadowEnabled = false
        chartView.chartDescription?.enabled = false
        chartView.xAxis.enabled = false
        chartView.rightAxis.enabled = false
        chartView.drawBarShadowEnabled = false
        let leftAxis = chartView.leftAxis
        leftAxis.drawLabelsEnabled = false
        leftAxis.drawAxisLineEnabled = false
        leftAxis.drawZeroLineEnabled = true
        leftAxis.zeroLineColor = .black
        leftAxis.zeroLineWidth = 1.5

        self.updateChartData()
        
        
    }
    
    
    
    func getDataFromCD(){
        
        let NewtcktRequest:NSFetchRequest<CoinPrice> = CoinPrice.fetchRequest()
        do {
            NewPriceCoin = try managedObjextContext.fetch(NewtcktRequest)
        }catch {
            print("Could not load data from database \(error.localizedDescription)")
        }
    }
    
    
    override func updateChartData() {
        if self.shouldHideData {
            chartView.data = nil
            return
        }
          self.setChartData()
    }
    

    func setChartData() {
        var coin = [String]() // nil value
        for value in NewPriceCoin {
            coin.append(value.price! as String)
        }
        if coin.isEmpty {
            coin = ApiHelper.getCoinValue()    // get info from api
        }
        
            if Connectivity.isConnectedToInternet == false {
                coin = ["8571.87", "538.495", "77.692862", "1004.64", "160.565", "0.190794"] // default parametr when connection lost
                SweetAlert().showAlert("No internet connection" )
            }

        let coin0:Double? = Double(coin[0])
        let coin1:Double? = Double(coin[1])
        let coin2:Double? = Double(coin[2])
        let coin3:Double? = Double(coin[3])
        let coin4:Double? = Double(coin[4])
        let coin5:Double? = Double(coin[5])
           
        let yVals = [BarChartDataEntry(x: 0, y: coin0!),
                     BarChartDataEntry(x: 1, y: coin1!),
                     BarChartDataEntry(x: 2, y: coin2!),
                     BarChartDataEntry(x: 3, y: coin3!),
                     BarChartDataEntry(x: 4, y: coin4!),
                     BarChartDataEntry(x: 5, y: coin5!)]
        
        
        
        let green = UIColor(red: 228/255, green: 32/255, blue: 30/255, alpha: 1)
        let red = UIColor(red: 31/255, green: 228/255, blue: 24/255, alpha: 1)
        
        let colors = yVals.map { (entry) -> NSUIColor in
            return entry.y > 257 ? red : green
        }
        
        let set = BarChartDataSet(values: yVals, label: "")
        set.colors = colors
        set.valueColors = colors
        //set.stackLabels = ["btc","btc","btc","btc","btc","btc"]
        
        let data = BarChartData(dataSet: set)
        data.setValueFont(.systemFont(ofSize: 13))
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        data.barWidth = 0.9
        chartView.data = data
        chartView.fitBars = true
        
        
       
    }
    
    override func optionTapped(_ option: Option) {
        super.handleOption(option, forChartView: chartView)
    }
    
    
    override func handleOption(_ option: Option, forChartView chartView: ChartViewBase) {
        switch option {
        case .toggleValues:
            for set in chartView.data!.dataSets {
                set.drawValuesEnabled = !set.drawValuesEnabled
            }
            chartView.setNeedsDisplay()
            
        case .toggleIcons:
            for set in chartView.data!.dataSets {
                set.drawIconsEnabled = !set.drawIconsEnabled
            }
            chartView.setNeedsDisplay()
            
        case .toggleHighlight:
            chartView.data!.highlightEnabled = !chartView.data!.isHighlightEnabled
            chartView.setNeedsDisplay()
            
        case .animateX:
            chartView.animate(xAxisDuration: 3)
            
        case .animateY:
            chartView.animate(yAxisDuration: 3)
            
        case .animateXY:
            chartView.animate(xAxisDuration: 3, yAxisDuration: 3)
            
        case .saveToGallery:
            UIImageWriteToSavedPhotosAlbum(chartView.getChartImage(transparent: false)!, nil, nil, nil)
            
        case .togglePinchZoom:
            let barLineChart = chartView as! BarLineChartViewBase
            barLineChart.pinchZoomEnabled = !barLineChart.pinchZoomEnabled
            chartView.setNeedsDisplay()
            
        case .toggleAutoScaleMinMax:
            let barLineChart = chartView as! BarLineChartViewBase
            barLineChart.autoScaleMinMaxEnabled = !barLineChart.isAutoScaleMinMaxEnabled
            chartView.notifyDataSetChanged()
            
        case .toggleData:
            shouldHideData = !shouldHideData
            updateChartData()
            
        case .toggleBarBorders:
            for set in chartView.data!.dataSets {
                if let set = set as? BarChartDataSet {
                    set.barBorderWidth = set.barBorderWidth == 1.0 ? 0.0 : 1.0
                }
            }
            chartView.setNeedsDisplay()
        default:
            break
        }
    }
    
    
    
    override func setup(pieChartView chartView: PieChartView) {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 10, top: 5, right: 10, bottom: 5)
        chartView.drawEntryLabelsEnabled = false
        
        
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "Charts\nby Daniel Cohen Gindi")
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!,
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        
        
        
        
        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
                                  .foregroundColor : UIColor.gray], range: NSRange(location: 10, length: centerText.length - 10))
        
        
        
        
        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
                                  .foregroundColor : UIColor.yellow], range: NSRange(location: centerText.length - 19, length: 19))
        
        //(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        chartView.centerAttributedText = centerText;
        
        chartView.drawHoleEnabled = false
        chartView.rotationAngle = 0
        chartView.rotationEnabled = false
        chartView.highlightPerTapEnabled = true
        
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 9
        l.yEntrySpace = 0
        l.yOffset = 4
        //        chartView.legend = l
    }
    
    override func setup(radarChartView chartView: RadarChartView) {
        chartView.chartDescription?.enabled = true
        
    }
    
    override func setup(barLineChartView chartView: BarLineChartViewBase) {
        chartView.chartDescription?.enabled = false
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = true
        
        // ChartYAxis *leftAxis = chartView.leftAxis;
        
        
        
        chartView.rightAxis.enabled = false
    }
    // TODO: Cannot override from extensions
    //extension DemoBaseViewController: ChartViewDelegate {
    override func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        //NSLog("chartValueSelected");
    }
    
    override func chartValueNothingSelected(_ chartView: ChartViewBase) {
        // NSLog("chartValueNothingSelected");
    }
    
    override func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    override func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
}

extension WalletsViewController: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return dataLabels[min(max(Int(value), 0), dataLabels.count - 1)]
    }
}




