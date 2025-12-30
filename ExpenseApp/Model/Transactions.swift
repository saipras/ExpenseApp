//
//  Transactions.swift
//  ExpenseApp
//
//  Created by sai on 07/12/25.
//  Copyright © 2025 expensetracker. All rights reserved.
//

import Foundation

enum TransactionError: Error {
    case invalidAmount
    case emptyTitle
}

enum TransactionType: String {
    case expense
    case income
}

struct Transaction {
    let id: UUID
    let type: TransactionType
    let title: String
    let amount: Double
    let date: Date
    let category: String
    let notes: String?
    
    
    // Logic inside Model: Validates data before a Transaction is ever created
    static func create(typeIndex: Int, title: String?, amount: String?, date: Date, category: String?, notes: String?) throws -> Transaction {
        guard let title = title, !title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw TransactionError.emptyTitle
        }
        
        guard let amountStr = amount, let amountValue = Double(amountStr), amountValue > 0 else {
            throw TransactionError.invalidAmount
        }
        
        let type: TransactionType = (typeIndex == 0) ? .expense : .income
        
        return Transaction(
            id: UUID(),
            type: type,
            title: title,
            amount: amountValue,
            date: date,
            category: category ?? "General",
            notes: notes
        )
    }
}
