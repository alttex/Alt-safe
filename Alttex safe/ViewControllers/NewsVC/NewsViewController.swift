//
//  HistoryViewController.swift
//  Alttex safe
//
//  Created by Vlad Kovryzhenko on 1/17/18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import ObjectMapper



class NewsViewController:UITableViewController{
    
    var articlesArray = [Articles]()
    
    var myRefreshControl = UIRefreshControl()
    
    
    
    var loadedAd:Bool = false
    
   
    
 
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        // Get messages from service
        ArticlesService.sharedInstance.getArticles(completion: { (articles) in
            self.articlesArray = articles
            if self.self.articlesArray.count > 0 {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.tableView.reloadData()
                    refreshControl.endRefreshing()
                }
                
            }
        }) { (code, error) in
            self.showMessage(message: error)
        }
    }
    
 
    
  
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        UserDefaults.standard.set("yes", forKey: "loaded")
        
        self.navigationItem.title = "Top Cryptocurrency Headlines"
        
        self.view.backgroundColor = UIColor.lightGray
        
        //        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
        //            AnalyticsParameterItemID: "id-\(self.navigationItem.title!)" as NSObject,
        //            AnalyticsParameterItemName: self.navigationItem.title! as NSObject,
        //            AnalyticsParameterContentType: "launch" as NSObject
        //            ])
        
        
     
        
      
        
        // Setting tableView
        // Configure Refresh Control
        
        self.myRefreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        self.myRefreshControl.tintColor = UIColor.white
        
        let attributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        self.myRefreshControl.attributedTitle = NSAttributedString(string: "Fetching Latest Headlines ...", attributes: attributes)
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            self.tableView.refreshControl = myRefreshControl
        } else {
            self.tableView.addSubview(self.myRefreshControl)
        }
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 197.0
        self.tableView.separatorStyle = .none
        self.tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "NewsCell")
        
        // Get messages from service
        ArticlesService.sharedInstance.getArticles(completion: { (articles) in
            self.articlesArray = articles
            if self.self.articlesArray.count > 0 {
                self.tableView.reloadData()
            }
        }) { (code, error) in
            self.showMessage(message: error)
        }
        
    }
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let article = self.articlesArray[indexPath.row]
        
        let cell = Bundle.main.loadNibNamed("NewsTableViewCell", owner: self, options: nil)?.first as! NewsTableViewCell
        cell.titleLabel.text = article.title
        cell.newsImageView.loadImageUsingCache(withUrl: article.urlToImage!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let article = self.articlesArray[indexPath.row]
        let webVC = SwiftWebVC(urlString: article.url!)
        webVC.delegate = self
        self.navigationController?.pushViewController(webVC, animated: true)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articlesArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260.0
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
    
    fileprivate func showMessage(message : String) {
        let alert = UIAlertController(title: "Alert",
                                      message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
                
            }}))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension NewsViewController: SwiftWebVCDelegate {
    
    func didStartLoading() {
        print("Started loading.")
    }
    
    func didFinishLoading(success: Bool) {
        print("Finished loading. Success: \(success).")
    }
}

let imageCache = NSCache<NSString, AnyObject>()

extension UIImageView {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    imageCache.setObject(image, forKey: urlString as NSString)
                    self.image = image
                }
            }
            
        }).resume()
    }
}



