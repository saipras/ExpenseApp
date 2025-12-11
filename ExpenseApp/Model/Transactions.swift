//
//  Transactions.swift
//  ExpenseApp
//
//  Created by sai on 07/12/25.
//  Copyright © 2025 expensetracker. All rights reserved.
//

import Foundation

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
}
