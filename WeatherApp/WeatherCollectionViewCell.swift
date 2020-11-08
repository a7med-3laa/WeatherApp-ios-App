//
//  WeatherCollectionViewCell.swift
//  WeatherApp
//
//  Created by ahmed on 11/8/20.
//  Copyright © 2020 ahmed. All rights reserved.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

   @IBOutlet weak var weatherIcon: UIImageView!
       @IBOutlet weak var dateLabel: UILabel!
       @IBOutlet weak var tempLabel: UILabel!
       override func awakeFromNib() {
           super.awakeFromNib()
           // Initialization code
       }

    
       override func layoutSubviews() {
            super.layoutSubviews()
            let bottomSpace = 10.0 // Let's assume the space you want is 10
           self.contentView.frame = self.contentView.frame.inset(by: UIEdgeInsets(top: 0, left: CGFloat(5), bottom: CGFloat(bottomSpace), right: CGFloat(5)))
       }
}
