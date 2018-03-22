//
//  ApiHelper.swift
//  Alttex safe
//
//  Created by Vitaliy Chorpita on 17.03.18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import Foundation
import UIKit

public class ApiHelper {
    

static func getCoinValue() -> [String] {
    

    
    var name = [String]()
    var price = [String]()
    var isFinish = false

    let urlString = "https://api.coinmarketcap.com/v1/ticker/?limit=6"
    let requestUrl = URL(string:urlString)
    var request = URLRequest(url:requestUrl!)
    let semaphore = DispatchSemaphore(value: 0)
    
    request.httpMethod = "GET"
    URLSession.shared.dataTask(with: (request), completionHandler: {(data, response, error) -> Void in
        if let data = data {
            if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSArray {
                for actor in jsonObj!{
                    if let actorDict = actor as? NSDictionary {
                        if let id = actorDict.value(forKey: "id") {
                            name.append(id as! String)
                        }
                        if let priceUsd = actorDict.value(forKey: "price_usd") {
                            price.append(priceUsd as! String)
                        }
                    }
                }
                print ("\nData get from API:", price)
            }
        }
        semaphore.signal()
    }).resume()
    
    let signal = semaphore.wait(timeout: DispatchTime.distantFuture)
    
    if signal.hashValue == 0 { // return 0 after DONE url ssesion
        if name.isEmpty == false {
            
            CoreDataHelper.saveTicketCoreData(name: name, price: price)
            isFinish = true
        }
  
    }else {
        if signal.hashValue == 1 { // return 1 after DROP url ssesion
            print("Url is failed (soryy)")
            isFinish = false

            
        }
    }
    print ("is finish: ", isFinish)
    return price
  
}





}
