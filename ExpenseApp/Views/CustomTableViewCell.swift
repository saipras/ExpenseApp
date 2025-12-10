//
//  CustomTableViewCell.swift
//  ExpenseApp
//
//  Created by sai on 10/12/25.
//  Copyright © 2025 expensetracker. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subHeadingLbl: UILabel!
    
   static let identifier = "mycustomcell"
      
      static func nib() -> UINib {
          return UINib(nibName: "CustomTableViewCell", bundle: nil)
      }
      
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
  public func configure(with title: String, subHeading: String) {
        titleLbl.text = title
        subHeadingLbl.text = subHeading   
    }

}
