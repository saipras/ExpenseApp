//
//  SettingsTableViewCell.swift
//  ExpenseApp
//
//  Created by sai on 09/12/25.
//  Copyright © 2025 expensetracker. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    static let identifier = "MyTableViewCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "SettingsTableViewCell", bundle: nil)
    }
    
    public func configure(with title: String, imageName: String) {
        myLbl.text = title
        myImage.image = UIImage(systemName: imageName)
     }
    
    
    @IBOutlet weak var myImage : UIImageView!
    @IBOutlet weak var myLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        myImage.contentMode = .scaleAspectFit
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
