//
//  NewsTableViewCell.swift
//  Alttex safe
//
//  Created by Vlad Kovryzhenko on 2/7/18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsImageView.layer.cornerRadius = 10
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        let customColorView = UIView()
        customColorView.backgroundColor = UIColor.darkGray
        
        self.selectedBackgroundView =  customColorView
        // Configure the view for the selected state
    }
    
}
