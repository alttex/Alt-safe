//
//  CriptoCell.swift
//  Alttex safe
//
//  Created by Vitaliy Chorpita on 12.03.18.
//  Copyright © 2018 Vlad Kovryzhenko. All rights reserved.
//

import UIKit

class CriptoCell: UITableViewCell {

    @IBOutlet weak var pictureCoin: UIImageView!
    @IBOutlet weak var nameCoin: UILabel!

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
