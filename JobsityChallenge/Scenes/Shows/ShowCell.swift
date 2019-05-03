//
//  ShowCell.swift
//  JobsityChallenge
//
//  Created by Ronny Libardo Bustos Jiménez on 4/29/19.
//  Copyright © 2019 Ronny Libardo Bustos Jiménez. All rights reserved.
//

import UIKit
import SDWebImage

class ShowCell: UITableViewCell {
    static let identifier = "ShowCell"
    
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        coverImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(with model: ShowCellViewModel) {
        self.nameLabel.text = model.name
        self.coverImageView.sd_setImage(with: model.cover, placeholderImage: UIImage(named: model.coverPlaceholder), completed: nil)
    }
}
