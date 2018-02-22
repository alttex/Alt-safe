//
//  WalletsViewController.swift
//  Alttex safe
//
//  Created by Vlad Kovryzhenko on 1/17/18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import UIKit
import UserNotifications

class WalletsViewController: UIViewController {

    @IBAction func bntNotifications(_ sender: UIButton) {
        let content = UNMutableNotificationContent()
        content.title = "Change balance"
        //content.subtitle = "Total USD: 11 463| Total BTC 3.62 + 5%(+ 1148$ + 0.18 BTC)"
        content.body = "Total USD: 11 463| Total BTC 3.62 + 5%(+ 1148$ + 0.18 BTC)"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let reqest = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(reqest, withCompletionHandler: nil)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge], completionHandler: { didAllow, error in
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
