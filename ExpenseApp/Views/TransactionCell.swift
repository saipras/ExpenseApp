//
//  TransactionCell.swift
//  ExpenseApp
//
//  Created by sai on 23/12/25.
//  Copyright © 2025 expensetracker. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {

    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var expenseTitle: UILabel!
    @IBOutlet weak var expenseIcon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        expenseIcon.contentMode = .scaleAspectFit
    }

    func configure(with transaction: Transaction) {
        expenseTitle.text = transaction.title
        descriptionLbl.text = transaction.category
        dateLbl.text = formattedDate(transaction.date)

        if transaction.type == .expense {
            expenseIcon.image = UIImage(systemName: "arrow.up.circle.fill")
            expenseIcon.tintColor = .systemRed
            amountLbl.textColor = .systemRed
            amountLbl.text = "-₹\(transaction.amount)"
        } else {
            expenseIcon.image = UIImage(systemName: "arrow.down.circle.fill")
            expenseIcon.tintColor = .systemBlue
            amountLbl.textColor = .systemBlue
            amountLbl.text = "+₹\(transaction.amount)"
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
    }
}
