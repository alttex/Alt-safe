//
//  SettingsViewController.swift
//  Alttex safe
//
//  Created by Vlad Kovryzhenko on 1/17/18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import UIKit
import Foundation


class SettingsViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        let logo = UIImage(named: "logo.png")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    // forwarding to our site
    @IBAction func ContactUs(_ sender: Any) {
      let url = URL(string: "https://alttex.io/")
      UIApplication.shared.open(url!, options: [:])
    }


}
