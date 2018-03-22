//
//  DemoViewController.swift
//  Alttex_messager
//
//  Created by Vlad Kovryzhenko on 1/18/18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import UIKit
import NotificationCenter
import Alamofire
import SwiftSpinner
import OneSignal
import Charts
import SwiftTheme

enum Option {
    case toggleValues
    case toggleIcons
    case toggleHighlight
    case animateX
    case animateY
    case animateXY
    case saveToGallery
    case togglePinchZoom
    case toggleAutoScaleMinMax
    case toggleData
    case toggleBarBorders
    // CandleChart
    case toggleShadowColorSameAsCandle
    // CombinedChart
    case toggleLineValues
    case toggleBarValues
    case removeDataSet
    // CubicLineSampleFillFormatter
    case toggleFilled
    case toggleCircles
    case toggleCubic
    case toggleHorizontalCubic
    case toggleStepped
    // HalfPieChartController
    case toggleXValues
    case togglePercent
    case toggleHole
    case spin
    case drawCenter
    // RadarChart
    case toggleXLabels
    case toggleYLabels
    case toggleRotate
    case toggleHighlightCircle
    
    var label: String {
        switch self {
        case .toggleValues: return "Toggle Y-Values"
        case .toggleIcons: return "Toggle Icons"
        case .toggleHighlight: return "Toggle Highlight"
        case .animateX: return "Animate X"
        case .animateY: return "Animate Y"
        case .animateXY: return "Animate XY"
        case .saveToGallery: return "Save to Camera Roll"
        case .togglePinchZoom: return "Toggle PinchZoom"
        case .toggleAutoScaleMinMax: return "Toggle auto scale min/max"
        case .toggleData: return "Toggle Data"
        case .toggleBarBorders: return "Toggle Bar Borders"
        // CandleChart
        case .toggleShadowColorSameAsCandle: return "Toggle shadow same color"
        // CombinedChart
        case .toggleLineValues: return "Toggle Line Values"
        case .toggleBarValues: return "Toggle Bar Values"
        case .removeDataSet: return "Remove Random Set"
        // CubicLineSampleFillFormatter
        case .toggleFilled: return "Toggle Filled"
        case .toggleCircles: return "Toggle Circles"
        case .toggleCubic: return "Toggle Cubic"
        case .toggleHorizontalCubic: return "Toggle Horizontal Cubic"
        case .toggleStepped: return "Toggle Stepped"
        // HalfPieChartController
        case .toggleXValues: return "Toggle X-Values"
        case .togglePercent: return "Toggle Percent"
        case .toggleHole: return "Toggle Hole"
        case .spin: return "Spin"
        case .drawCenter: return "Draw CenterText"
        // RadarChart
        case .toggleXLabels: return "Toggle X-Labels"
        case .toggleYLabels: return "Toggle Y-Labels"
        case .toggleRotate: return "Toggle Rotate"
        case .toggleHighlightCircle: return "Toggle highlight circle"
        }
    }
}

class ChartsVC: UIViewController, ChartViewDelegate,UISearchResultsUpdating {
  
    @IBOutlet weak var tableView: UITableView!
    
    
    // Go to Favorites view
    @IBAction func favoritesBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "favoritesCurrency") as! FavoritesViewController
        self.show(controller, sender: self)
    }
    
    // Go to Wallets View
    @IBAction func walletsBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "feedDetails") as! CoinsDetailsViewController
        self.show(controller, sender: self)
    }
    
    
    let coinsURL: String = "https://api.coinmarketcap.com/v1/ticker/?limit=0"
    var filteredEntries: [CoinEntry] = []
    var searchActive: Bool = false
    var alertsLoaded: Bool = false
    var entriesLoaded: Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    var shouldHideData: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        //Change color tittle to white
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateList), name: NSNotification.Name(rawValue: "reloadViews"), object: nil)
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.backgroundColor = UIColor.rbg(r: 34, g: 34, b: 34)
        searchController.searchBar.placeholder = "Search Coin Name"
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barTintColor = .white
        searchController.dimsBackgroundDuringPresentation = true
        //definesPresentationContext = true
        navigationItem.searchController = searchController
        searchController.searchBar.setTextFieldColor(color: .white)
        searchController.searchBar.setTextColor(color: .white)
        searchController.searchBar.setPlaceholderTextColor(color: .white)
        
        
        
        if Connectivity.isConnectedToInternet {
            self.updateData()
        } else {
            SweetAlert().showAlert("No internet connection" )
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
       updateTheme()
        // Update Coin Data
        self.updateList()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.initialize()
    }
    
    private func initialize() {
        self.edgesForExtendedLayout = []
    }
    
    func optionTapped(_ option: Option) {}
    
    func handleOption(_ option: Option, forChartView chartView: ChartViewBase) {
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
 
    func updateChartData() {
        fatalError("updateChartData not overridden")
    }
    
    func setup(pieChartView chartView: PieChartView) {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.61
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 5)
        
        chartView.drawCenterTextEnabled = true
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        
        let centerText = NSMutableAttributedString(string: "Charts\nby Daniel Cohen Gindi")
        centerText.setAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 13)!,
                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
                                  .foregroundColor : UIColor.gray], range: NSRange(location: 10, length: centerText.length - 10))
        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
                                  .foregroundColor : UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)], range: NSRange(location: centerText.length - 19, length: 19))
        chartView.centerAttributedText = centerText;
        
        chartView.drawHoleEnabled = false
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 9
        l.yEntrySpace = 0
        l.yOffset = 4
        //        chartView.legend = l
    }
    
    func setup(radarChartView chartView: RadarChartView) {
        chartView.chartDescription?.enabled = true
        
    }
    
    func setup(barLineChartView chartView: BarLineChartViewBase) {
        chartView.chartDescription?.enabled = false
        
        chartView.dragEnabled = true
        chartView.setScaleEnabled(false)
        chartView.pinchZoomEnabled = true
        
        // ChartYAxis *leftAxis = chartView.leftAxis;
        
     
        
        chartView.rightAxis.enabled = false
    }
    // TODO: Cannot override from extensions
    //extension DemoBaseViewController: ChartViewDelegate {
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
       // NSLog("chartValueSelected");
    }
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
      //  NSLog("chartValueNothingSelected");
    }
    
    func chartScaled(_ chartView: ChartViewBase, scaleX: CGFloat, scaleY: CGFloat) {
        
    }
    
    func chartTranslated(_ chartView: ChartViewBase, dX: CGFloat, dY: CGFloat) {
        
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        // If we haven't typed anything into the search bar then do not filter the results
        if searchController.searchBar.text! == "" {
            filteredEntries = entries
        } else {
            // Filter the results
            filteredEntries = entries.filter { $0.name.lowercased().contains(searchController.searchBar.text!.lowercased()) }
        }
        
        self.tableView.reloadData()
    }
    
    @objc func updateList() {
        // update data
        self.tableView.reloadData()
    }
    
    @IBAction func updateButton(_ sender: Any) {
        if Connectivity.isConnectedToInternet {
            self.updateData()
        } else {
            SweetAlert().showAlert("No internet connection" )
        }
    }
    
    func updateData() {
        // reset alert and entries array
        alerts.removeAll()
        entries.removeAll()
        
        // load favorites
        favorites = defaults.object(forKey:"CoinAuditFavorites") as? [String] ?? [String]()
        favorites = favorites.sorted()
        
        
        // Provide loading spinner
        SwiftSpinner.show("Downloading Data..." , animated: true)
        
        // Pull Coin Data
        Alamofire.request(coinsURL).responseJSON { response in
            for coinJSON in (response.result.value as? [[String : AnyObject]])! {
                if let coin = CoinEntry.init(json: coinJSON) {
                    entries.append(coin)
                }
            }
            self.entriesLoaded = true
            self.filteredEntries = entries
            
            if self.alertsLoaded && self.entriesLoaded {
                SwiftSpinner.hide()
            }
            
            // Update Table Views
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadViews"), object: nil)
        }
        
        // MARK: Download Alert data
        // get id of user
        guard let id = notificationID else { return }
        
        // Pull Alert Data
        Alamofire.request("https://www.tyschenk.com/coinaudit/alerts/get.php?id=\(id)").responseJSON { response in
            for alertJSON in (response.result.value as? [[String : AnyObject]])! {
                if let alert = AlertEntry.init(json: alertJSON) {
                    // do something here
                    alerts.append(alert)
                }
            }
            self.alertsLoaded = true
            if self.alertsLoaded && self.entriesLoaded {
                SwiftSpinner.hide()
            }
        }
        
        // give ad a few seconds to load ad
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when) {
            // Your code with delay
            
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        switch themeValue {
        case "dark":
            return .lightContent
        default:
            return .default
        }
    }
    
    @objc func updateTheme() {
        
        
//        switch themeValue {
//        case "dark":
//            // TextField Color Customization
//            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black]
//
//            // set theme to dark mode
//            ThemeManager.setTheme(index: 0)
//        default:
//            // TextField Color Customization
//            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
//
//            // set theme to light mode
//            ThemeManager.setTheme(index: 1)
//        }
        
//        self.tabBarController?.tabBar.theme_barTintColor = ["#000000", "#000"]
//        self.tabBarController?.tabBar.theme_tintColor = ["#FFF", "#01b207"]
//        
//
        
        
//        self.tableView.theme_backgroundColor = ["#242424", "#242424"]
//        self.view.theme_backgroundColor = ["#242424", "#343434j"]
        
//        self.navigationItem.leftBarButtonItem?.theme_tintColor = ["#FFF", "#FFF"]
//        self.navigationItem.rightBarButtonItem?.theme_tintColor = ["#FFF", "#FFF"]
//        self.navigationController?.navigationBar.theme_barTintColor = ["#FFF", "#FFF"]
//        self.navigationController?.navigationBar.theme_titleTextAttributes = [[NSAttributedStringKey.foregroundColor.rawValue : UIColor.white], [NSAttributedStringKey.foregroundColor.rawValue : UIColor.black]]
//        self.navigationController?.navigationBar.theme_largeTitleTextAttributes = [[NSAttributedStringKey.foregroundColor.rawValue : UIColor.black], [NSAttributedStringKey.foregroundColor.rawValue : UIColor.white]]
//
        UIApplication.shared.statusBarStyle = preferredStatusBarStyle
    }
    
}

extension ChartsVC: UITableViewDelegate, UITableViewDataSource {
    
    
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredEntries.count
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell", for: indexPath) as! FeedCell
        
        // Configure the cell...
        let coin = self.filteredEntries[indexPath.row]
        cell.nameLabel.text = coin.name
        cell.symbolLabel.text = coin.symbol
        cell.rankLabel.text = "\(coin.rank)."
        
        if priceFormat == "USD" {
            cell.valueLabel.text = coin.priceUSD.formatUSD()
        } else {
            cell.valueLabel.text = "\(coin.priceBTC) BTC"
        }
        
        // Theme Drawing code
        switch themeValue {
        case "dark":
            cell.backgroundColor = UIColor.rbg(r: 34, g: 34, b: 34)
            cell.nameLabel.textColor = UIColor.rbg(r: 34, g: 34, b: 34)
            cell.symbolLabel.textColor = UIColor.rbg(r: 34, g: 34, b: 34)
            cell.valueLabel.textColor = UIColor.rbg(r: 34, g: 34, b: 34)
            cell.rankLabel.textColor = UIColor.rbg(r: 34, g: 34, b: 34)
        default:
            cell.backgroundColor = UIColor.rbg(r: 34, g: 34, b: 34)
            cell.nameLabel.textColor = UIColor.white
            cell.symbolLabel.textColor = UIColor.white
            cell.valueLabel.textColor = UIColor.white
            cell.rankLabel.textColor = UIColor.white
            
        }
        
        return cell
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "feedDetails") as! CoinsDetailsViewController
        controller.id = self.filteredEntries[indexPath.row].id
        
        self.show(controller, sender: self)
    }

    
  
}

