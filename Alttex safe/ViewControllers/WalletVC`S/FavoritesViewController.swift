

import UIKit
import Alamofire
import SwiftSpinner
import NotificationCenter
import SwiftTheme

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var favTableView: UITableView!
   
    @IBOutlet var tableViewBottom: NSLayoutConstraint!
    
    override func viewWillAppear(_ animated: Bool) {
        favTableView.delegate = self
        favTableView.dataSource = self
        favTableView.separatorColor = .none
        // MARK: Ad View
        //self.favTableView.backgroundColor = UIColor.rbg(r: 24, g: 24, b: 24)
   
        NotificationCenter.default.addObserver(self, selector: #selector(updateList), name: NSNotification.Name(rawValue: "reloadViews"), object: nil)
        
        if let selectionIndexPath = self.favTableView.indexPathForSelectedRow {
            self.favTableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
        
        self.favTableView.allowsSelectionDuringEditing = true
        favorites = defaults.object(forKey:"CoinAuditFavorites") as? [String] ?? [String]()
        favorites = favorites.sorted()
        self.favTableView.reloadData()
       
        updateTheme()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favTableView.separatorColor = .none
        
        
    }

    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if favorites.count != 0 && entries.count != 0 {
            return favorites.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Action to delete data
            favorites = favorites.sorted()
            // remove
            favorites.remove(at: indexPath.row)
            defaults.set(favorites, forKey: "CoinAuditFavorites")
            let cell = tableView.cellForRow(at: indexPath) as! FavCell
            print("Deleted: \(cell.nameLabel.text!) from favorites")
            self.favTableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "feedDetails") as! CoinsDetailsViewController
        favorites = favorites.sorted()
        controller.id = favorites[indexPath.row]
        self.show(controller, sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configure the cell...
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavCell
        favorites = favorites.sorted()
        guard let coin = entries.first(where: {$0.id == favorites[indexPath.row]}) else {
            cell.nameLabel.text = "Unknown"
            cell.symbolLabel.text = "Unk"
            cell.valueLabel.text = "0.0".formatUSD()
            return cell
        }
    
        cell.nameLabel.text = coin.name
        cell.symbolLabel.text = coin.symbol
        
        cell.rankLabel.text = "\(coin.rank)."
        
        if priceFormat == "USD" {
            cell.valueLabel.text = coin.priceUSD.formatUSD()
        } else {
            cell.valueLabel.text = "\(coin.priceBTC) BTC"
        }
        
       //  Theme Drawing code
        switch themeValue {
        case "dark":
            cell.backgroundColor = .white
            cell.nameLabel.textColor = .white
            cell.symbolLabel.textColor = .white
            cell.valueLabel.textColor = .white
            cell.rankLabel.textColor = .white
        default:
            cell.backgroundColor = .white
            cell.nameLabel.textColor = .white
            cell.symbolLabel.textColor = .white
            cell.valueLabel.textColor = .white
            cell.rankLabel.textColor = .white
        }

        return cell
    }
    
    @objc func updateList() {
      
        self.favTableView.reloadData()
    }
    
    @IBAction func updateCoins(_ sender: Any) {
        if Connectivity.isConnectedToInternet {
            SwiftSpinner.show(duration: 1.5, title: "Updating Data...")
            pullData()
        } else {
            SweetAlert().showAlert("No internet connection")
        }
    }
    
    func updateTheme() {

        self.navigationItem.leftBarButtonItem?.theme_tintColor = ["#FFF", "#000"]
        self.navigationItem.rightBarButtonItem?.theme_tintColor = ["#FFF", "#000"]
        self.navigationController?.navigationBar.theme_tintColor = ["#FFF", "#000"]
        self.navigationController?.navigationBar.theme_barTintColor = ["#000", "#FFF"]
        self.navigationController?.navigationBar.tintColor = UIColor.white

    }

}
