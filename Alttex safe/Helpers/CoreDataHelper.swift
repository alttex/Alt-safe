//
//  CoreDataHelper.swift
//  Alttex safe
//
//  Created by Vitaliy Chorpita on 18.03.18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class CoreDataHelper {
    
    
    
    static func saveTicketCoreData(name: [String], price: [String])  {
        DeleteAllData(entity: "CoinPrice")
        print("\nSave data into DataBase ", price)
       
        
        DispatchQueue.main.async {
        
            let context =  (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
            for value in 0...name.count - 1  {
                let authInfo = NSEntityDescription.insertNewObject(forEntityName: "CoinPrice", into: context)
                authInfo.setValue(name[value] as String , forKey: "name")
                authInfo.setValue(price[value] as String, forKey: "price")
              
            }
            do {
                try context.save()
            }
            catch {
                print("\n Error save to Core Data !", error)
            }
        }
    }
    
    
    
    static func DeleteAllData(entity: String){
        
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedContext = appDelegate.persistentContainer.viewContext
            let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: entity))
            do {
                try managedContext.execute(DelAllReqVar)
            }
            catch {
                print(error)
            }
        }
    }
    
}
