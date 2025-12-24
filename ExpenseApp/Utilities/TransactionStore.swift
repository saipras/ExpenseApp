//
//  TransactionStore.swift
//  ExpenseApp
//
//  Created by sai on 24/12/25.
//  Copyright © 2025 expensetracker. All rights reserved.
//

import Foundation
final class TransactionStore {
    static let shared = TransactionStore()
    private init() {}

    var transactions: [Transaction] = []
}
