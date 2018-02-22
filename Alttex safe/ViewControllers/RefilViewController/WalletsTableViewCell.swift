//
//  WalletsTableViewCell.swift
//  Alttex safe
//
//  Created by Vlad Kovryzhenko on 2/8/18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//
import Foundation
import UIKit

class WalletsTableViewCell: UITableViewCell {

    static var Identifier = "CurrencyTableViewCell"
    

    
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceChangeUsd1hLabel: UILabel!
    @IBOutlet weak var valueUsdLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
   // @IBOutlet weak var checkbox: BEMCheckBox!
    
    
    var currency: Currency? {
        didSet {
            guard let currency = currency else { return }
            symbolLabel!.text = currency.Symbol
            nameLabel!.text = currency.Name
            valueUsdLabel!.text = "USD \(String(format: "%.2f", currency.PriceUsd))"
            priceChangeUsd1hLabel!.text = "\(String(format: "%.2f", currency.PercentChange1h)) %"
            if let icon = UIImage(named: currency.Symbol) {
                iconImageView!.image = icon
                iconImageView!.alpha = 1
            } else {
                iconImageView!.image = UIImage(named: "BTC")
                iconImageView!.alpha = 0.5
            }
        }
    }
    
}

