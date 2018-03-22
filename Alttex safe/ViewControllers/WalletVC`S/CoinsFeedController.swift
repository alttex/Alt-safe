

import UIKit
import NotificationCenter
import Alamofire
import SwiftSpinner
import OneSignal


import SwiftTheme

class CoinsFeedController: UITableViewController, UISearchResultsUpdating {
    
    let coinsURL: String = "https://api.coinmarketcap.com/v1/ticker/?limit=0"
    var filteredEntries: [CoinEntry] = []
    var searchActive: Bool = false
    var alertsLoaded: Bool = false
    var entriesLoaded: Bool = false

    
    //let searchController = UISearchController(searchResultsController: nil)
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorColor = .none
    
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateList), name: NSNotification.Name(rawValue: "reloadViews"), object: nil)
//        
//        searchController.searchResultsUpdater = self
//        searchController.searchBar.placeholder = "Search Coin Name" 
//        searchController.dimsBackgroundDuringPresentation = false
//        definesPresentationContext = true
//        navigationItem.searchController = searchController
        
        if Connectivity.isConnectedToInternet {
            self.updateData()
        }
        else {
            SweetAlert().showAlert("No internet connection" )
        }
    }
    

  
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        ///updateTheme()
        
        // Update Coin Data
        self.updateList()
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredEntries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            cell.backgroundColor = UIColor.black
            cell.nameLabel.textColor = UIColor.white
            cell.symbolLabel.textColor = UIColor.white
            cell.valueLabel.textColor = UIColor.white
            cell.rankLabel.textColor = UIColor.white
        default:
            cell.backgroundColor = UIColor.black
            cell.nameLabel.textColor = UIColor.black
            cell.symbolLabel.textColor = UIColor.black
            cell.valueLabel.textColor = UIColor.black
            cell.rankLabel.textColor = UIColor.black
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "feedDetails") as! CoinsDetailsViewController
        controller.id = self.filteredEntries[indexPath.row].id
        
        self.show(controller, sender: self)
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
        switch themeValue {
        case "dark":
            // TextField Color Customization
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.white]
            
            // set theme to dark mode
            ThemeManager.setTheme(index: 0)
        default:
            // TextField Color Customization
            UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.black]
            
            // set theme to light mode
            ThemeManager.setTheme(index: 1)
        }
        
        self.tabBarController?.tabBar.theme_barTintColor = ["#01b207", "#FFF"]
        self.tabBarController?.tabBar.theme_tintColor = ["#FFF", "#01b207"]
        self.tableView.theme_backgroundColor = ["#000", "#343434"]
        self.view.theme_backgroundColor = ["#000", "#343434"]
        self.navigationItem.leftBarButtonItem?.theme_tintColor = ["#FFF", "#000"]
        self.navigationItem.rightBarButtonItem?.theme_tintColor = ["#FFF", "#000"]
        self.navigationController?.navigationBar.theme_barTintColor = ["#000", "#FFF"]
        self.navigationController?.navigationBar.theme_titleTextAttributes = [[NSAttributedStringKey.foregroundColor.rawValue : UIColor.white], [NSAttributedStringKey.foregroundColor.rawValue : UIColor.black]]
        self.navigationController?.navigationBar.theme_largeTitleTextAttributes = [[NSAttributedStringKey.foregroundColor.rawValue : UIColor.white], [NSAttributedStringKey.foregroundColor.rawValue : UIColor.black]]

        UIApplication.shared.statusBarStyle = preferredStatusBarStyle
    }
}
