//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by ahmed on 11/6/20.
//  Copyright © 2020 ahmed. All rights reserved.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func layoutSubviews() {
         super.layoutSubviews()
         let bottomSpace = 10.0 // Let's assume the space you want is 10
        self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: CGFloat(bottomSpace), right: 0))
    }
    
    
}
