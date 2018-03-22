//
//  RefilVC.swift
//  Alttex safe
//
//  Created by Vitaliy Chorpita on 12.03.18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import UIKit

class RefilVC: UIViewController,  UITableViewDelegate, UITableViewDataSource {
   
    
//    let imageCoin = [#imageLiteral(resourceName: "BTC"),#imageLiteral(resourceName: "ETH"),#imageLiteral(resourceName: "DASH"),#imageLiteral(resourceName: "ZEC"),#imageLiteral(resourceName: "MONA"),#imageLiteral(resourceName: "LISK"),#imageLiteral(resourceName: "LTC"),#imageLiteral(resourceName: "NEO"),#imageLiteral(resourceName: "XEM")]
//    let nameCoin = ["BTC 0.1","ETH 1","DASH 1","ZEC 1","MONERO 1","LISK 1","LITECOIN 1","NEO 1","NEM 1"]
//    let valueCoin = ["780","360","447.77","300.49","134.36","10.17","71.68","40.72","0.212"]
    
    let imageCoin = [#imageLiteral(resourceName: "bit_orange")]
    let nameCoin = ["BTC"]
    let valueCoin = [""]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Refill"
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       return imageCoin.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CriptoCell
        cell.pictureCoin.image = imageCoin[indexPath.row]
        cell.nameCoin.text = nameCoin[indexPath.row]
         return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
//            let ticket = NewTicket[indexPath.row]
//            let Storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let DVC = Storyboard.instantiateViewController(withIdentifier: "Detail") as! DetailViewController
//
//            DVC.getTrack = ticket.track!
//            DVC.getDueData = ticket.createdAt!
//            DVC.getStatus = ticket.status!
//            DVC.getMessage = ticket.message!
//            DVC.getSubject = ticket.subject!
//            DVC.getCategory = Int(ticket.category)
        
            //self.navigationController!.pushViewController(DVC, animated: true)
            
       
    }

}
