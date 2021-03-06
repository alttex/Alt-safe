
import UIKit
import NotificationCenter
import SwiftSpinner
import Alamofire
import Sentry
import SwiftTheme

class CoinsDetailsViewController: UIViewController {
    
    @IBOutlet var marketCapLabel: UILabel!
    @IBOutlet var volumeLabel: UILabel!
    @IBOutlet var circulatingSupplyLabel: UILabel!
    @IBOutlet var maxSupplyLabel: UILabel!
    @IBOutlet var priceUSDLabel: UILabel!
    @IBOutlet var priceBTCLabel: UILabel!
    @IBOutlet var favButton: UIButton!
    @IBOutlet var percent1Label: UILabel!
    @IBOutlet var percent24Label: UILabel!
    @IBOutlet var percent7Label: UILabel!
    @IBOutlet var PercentChangeLabels: [UILabel]!
    @IBOutlet var supplyUsed: UILabel!
    @IBOutlet var lastUpdated: UILabel!
    @IBOutlet weak var favBottom: NSLayoutConstraint!
    
    var favorited: Bool = false
    var id: String = ""
    var url: String = ""
    var viewer: Bool = false
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load favorites
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        
        
        
        favorites = defaults.object(forKey:"CoinAuditFavorites") as? [String] ?? [String]()
        favorites = favorites.sorted()
        
        let updateButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(updateCoin))
        updateButton.image =  #imageLiteral(resourceName: "refresh") // #imageLiteral(resourceName: "SYNC")
        self.navigationItem.rightBarButtonItem = updateButton
        
        if favorites.contains(id) {
            self.favorited = true
            favButton.backgroundColor = UIColor(hexString: "68D432")
            favButton.setTitle("Remove Favorite", for: .normal)
        } else {
            self.favorited = false
            favButton.backgroundColor = UIColor.red
            favButton.setTitle("Favorite", for: .normal)
        }
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//
//
//        if entries.count != 0 && viewer == false {
//            self.formatData(coin: entries.first!) //first(where: {$0.id == id})!)
//
//
//            self.formatPercents(coin: entries.first!) //(where: {$0.id == id})
//            updateTheme()
//        }
//
//        if viewer {
//            let done = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneButton))
//            self.navigationItem.leftBarButtonItem = done
//            self.navigationController?.navigationItem.leftBarButtonItem = done
//
//            if Connectivity.isConnectedToInternet {
//                SwiftSpinner.show("Updating \(id)...")
//                // Pull Coin Data
//                Alamofire.request("https://api.coinmarketcap.com/v1/ticker/\(id)/?convert=USD").responseJSON { response in
//                    if (response.result.value as? [[String : AnyObject]])?.count == 0 {
//                        SweetAlert().showAlert("No coin data found")
//                        self.doneButton()
//                        return
//                    }
//                    for coinJSON in (response.result.value as? [[String : AnyObject]])! {
//                        if let coin = CoinEntry.init(json: coinJSON) {
//                            if entries.count != 0 {
//                                let index = entries.index(where: {$0.id == self.id})
//                                entries[index!] = coin
//                            } else {
//                                entries.append(coin)
//                            }
//                            self.formatData(coin: coin)
//                            self.formatPercents(coin: coin)
//                            self.updateTheme()
//                            SwiftSpinner.hide()
//                        }
//                    }
//                }
//            } else {
//                SweetAlert().showAlert("No internet connection")
//            }
//        }
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        viewer = false
    }

    @IBAction func favoriteButton(_ sender: Any) {
        if favorited == true {
            favorited = false
            favButton.backgroundColor = UIColor.red
            favButton.setTitle("Favorite", for: .normal)
            // remove
            if let index = favorites.index(of: id) {
                favorites.remove(at: index)
            }
            saveFavoriteSettings()
            print("Deleted: \(id) from favorites")
        } else {
            favorited = true
            favButton.backgroundColor = UIColor.green
            favButton.setTitle("Favorited", for: .normal)
            // save coin id to array
            favorites.append(id)
            favorites = favorites.sorted()
            saveFavoriteSettings()
            print("Added: \(id) from favorites")
        }
    }
    
    func formatData(coin: CoinEntry) {
        // set name of coin
        self.navigationItem.title = coin.name
        name = coin.name
        
        // format prices and set to labels
        priceUSDLabel.text = "Price USD: \(coin.priceUSD.formatUSD())"
        priceBTCLabel.text = "Price BTC: \(coin.priceBTC)"
        url = "https://coinmarketcap.com/currencies/\(coin.id)/?convert=USD"
        
        if coin.lastUpdated != "unknown" {
            //Jan 12, 2018 1:15 AM UTC
            let stamp = Double(coin.lastUpdated)!
            let date = Date(timeIntervalSince1970: stamp)
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC") //Set timezone that you want
            dateFormatter.locale = NSLocale.current
            dateFormatter.dateFormat = "MMM dd, yyyy h:mm a" //Specify your format that you want
            let strDate = dateFormatter.string(from: date)
            
            lastUpdated.text = "Last Updated: \(strDate) UTC"
            lastUpdated.textColor = .white
        } else {
            lastUpdated.text = "Last Updated: \(coin.lastUpdated)"
            lastUpdated.textColor = .white
        }
        
        if coin.marketCapUSD != "unknown" {
            marketCapLabel.text = "Market Cap: \(coin.marketCapUSD.formatUSD())"
            marketCapLabel.textColor = .white
        } else {
            marketCapLabel.text = "Market Cap: \(coin.marketCapUSD)"
            marketCapLabel.textColor = .white
        }
        
        if coin.volumeUSD != "unknown" {
            volumeLabel.text = "Volume (24h): \(coin.volumeUSD.formatUSD())"
            volumeLabel.textColor = .white
        } else {
            volumeLabel.text = "Volume (24h): \(coin.volumeUSD)"
            volumeLabel.textColor = .white
        }
        
        if coin.maxSupply != "unknown" {
            maxSupplyLabel.text = "Max Supply: \(coin.maxSupply.formatDecimal())"
            maxSupplyLabel.textColor = .white
        } else {
            maxSupplyLabel.text = "Max Supply: \(coin.maxSupply)"
            maxSupplyLabel.textColor = .white
        }
        
        if coin.availableSupply != "unknown" {
            circulatingSupplyLabel.text = "Circulating Supply: \(coin.availableSupply.formatDecimal())"
            
            if coin.maxSupply != "unknown" {
                let max = Double(coin.maxSupply)!
                let used = Double(coin.availableSupply)!
                
                let perCent = 100.0*used/max
                let perString = "\(perCent)".formatDecimal()
                
                if (perCent > 0.0) {
                    // do positive stuff
                    supplyUsed.textColor = UIColor(hexString: "63DB37")
                    supplyUsed.text = "\(perString)%"
                } else if (perCent == 0.0) {
                    // do zero stuff
                    supplyUsed.textColor = UIColor(hexString: "63DB37")
                    supplyUsed.text = "\(perString)%"
                } else {
                    // do negative stuff
                    supplyUsed.textColor = UIColor(hexString: "FF483E")
                    supplyUsed.text = "\(perString)%"
                }
            } else {
                supplyUsed.text = "Unknown"
                
                if themeValue == "dark" {
                    supplyUsed.textColor = UIColor.white
                } else {
                    supplyUsed.textColor = UIColor.black
                }
            }
        } else {
            circulatingSupplyLabel.text = "Circulating Supply: \(coin.availableSupply)"
        }
    }
    
    func formatPercents(coin: CoinEntry) {
        var percent1 = 0.0
        var percent24 = 0.0
        var percent7 = 0.0
        
        if coin.percentChange1 != "unknown" {
            percent1 = Double(coin.percentChange1)!
        } else {
            percent1 = 0.0
        }
        
        if coin.percentChange24 != "unknown" {
            percent24 = Double(coin.percentChange24)!
        } else {
            percent24 = 0.0
        }
        
        if coin.percentChange7 != "unknown" {
            percent7 = Double(coin.percentChange7)!
        } else {
            percent7 = 0.0
        }
        
        if (percent1 > 0.0) {
            // do positive stuff
            percent1Label.textColor = UIColor(hexString: "63DB37")
            percent1Label.text = "\(percent1)%"
        } else if (percent1 == 0.0) {
            // do zero stuff
            percent1Label.textColor = UIColor(hexString: "63DB37")
            percent1Label.text = "\(percent1)%"
        } else {
            // do negative stuff
            percent1Label.textColor = UIColor(hexString: "FF483E")
            percent1Label.text = "\(percent1)%"
        }
        
        if (percent24 > 0.0) {
            // do positive stuff
            percent24Label.textColor = UIColor(hexString: "63DB37")
            percent24Label.text = "\(percent24)%"
        } else if (percent24 == 0.0) {
            // do zero stuff
            percent24Label.textColor = UIColor(hexString: "63DB37")
            percent24Label.text = "\(percent24)%"
        } else {
            // do negative stuff
            percent24Label.textColor = UIColor(hexString: "FF483E")
            percent24Label.text = "\(percent24)%"
        }
        
        if (percent7 > 0.0) {
            // do positive stuff
            percent7Label.textColor = UIColor(hexString: "63DB37")
            percent7Label.text = "\(percent7)%"
        } else if (percent7 == 0.0) {
            // do zero stuff
            percent7Label.textColor = UIColor(hexString: "63DB37")
            percent7Label.text = "\(percent7)%"
        } else {
            // do negative stuff
            percent7Label.textColor = UIColor(hexString: "FF483E")
            percent7Label.text = "\(percent7)%"
        }
    }
    
    
    @objc func updateCoin() {
        
        
//        if Connectivity.isConnectedToInternet {
//            SwiftSpinner.show("Updating Data...")
//            // Pull Coin Data
//
//            Alamofire.request("https://api.coinmarketcap.com/v1/ticker/\(id)/convert=USD").responseJSON { response in
//                for coinJSON in (response.result.value as? [[String : AnyObject]])! {
//                    if let coin = CoinEntry.init(json: coinJSON) {
//                        let index = entries.index(where: {$0.id == self.id})
//                        entries[index!] = coin
//                        self.formatData(coin: coin)
//                        self.formatPercents(coin: coin)
//                        SwiftSpinner.hide()
//                    }
//                }
//            }
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadViews"), object: nil)
//        } else {
//            SweetAlert().showAlert("No internet connection")
//        }
        
        
          SwiftSpinner.show("Updating Data...")
        SwiftSpinner.hide()
        
    }
    
    
    
    @objc func doneButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewController(withIdentifier: "main")
        self.present(mainController, animated: true, completion: nil)
    }
    
    @IBAction func moreInfo(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "showWeb") as! WebViewController
        controller.url = url

        self.show(controller, sender: self)
        print("sorry")
    }
    
    
    func updateTheme() {
//        
//        self.tabBarController?.tabBar.theme_barTintColor = ["#000000", "#000"]
//        self.tabBarController?.tabBar.theme_tintColor = ["#FFF", "#01b207"]
//        
        
//
//        self.tabBarController?.tabBar.theme_barTintColor = ["#000000", "#FFF"]
//        self.tabBarController?.tabBar.theme_tintColor = ["#FFF", "#01b207"]
//        self.view.theme_backgroundColor = ["#343434", "#343434"]
//        self.navigationItem.leftBarButtonItem?.theme_tintColor = ["#000", "#fff"]
//        self.navigationItem.rightBarButtonItem?.theme_tintColor = ["#000", "#fff"]
//        self.navigationController?.navigationBar.theme_barTintColor = ["#000", "#FFF"]
//        self.navigationController?.navigationBar.theme_tintColor = ["#000", "#fff"]
//        self.navigationController?.navigationBar.theme_titleTextAttributes = [[NSAttributedStringKey.foregroundColor.rawValue : UIColor.black], [NSAttributedStringKey.foregroundColor.rawValue : UIColor.white]]
//        self.navigationController?.navigationBar.theme_largeTitleTextAttributes = [[NSAttributedStringKey.foregroundColor.rawValue : UIColor.black], [NSAttributedStringKey.foregroundColor.rawValue : UIColor.white]]
//        marketCapLabel.theme_textColor = ["#FFF", "#000"]
//        volumeLabel.theme_textColor = ["#FFF", "#000"]
//        circulatingSupplyLabel.theme_textColor = ["#FFF", "#000"]
//        maxSupplyLabel.theme_textColor = ["#FFF", "#000"]
//        priceUSDLabel.theme_textColor = ["#FFF", "#000"]
//        priceBTCLabel.theme_textColor = ["#FFF", "#000"]
//        for item in PercentChangeLabels {
//            item.theme_textColor = ["#FFF", "#fff"]
//        }
    }
    
}
