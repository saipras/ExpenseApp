//
//  DashboardUtility.swift
//  ExpenseApp
//
//  Created by sai on 28/12/25.
//  Copyright © 2025 expensetracker. All rights reserved.
//

import UIKit

final class DashboardAnalytics {
    
    // MARK: - Data Models
    struct Summary {
        let income: Double
        let expense: Double
        let balance: Double
        let spentPercentage: Float
    }
    
    // MARK: - Business Logic
    
    /// Calculates financial summary using a single-pass reduce for maximum efficiency.
    static func calculateSummary(from transactions: [Transaction]) -> Summary {
        // High-performance optimization: Calculate income and expense in one loop
        let totals = transactions.reduce(into: (income: 0.0, expense: 0.0)) { result, transaction in
            if transaction.type == .income {
                result.income += transaction.amount
            } else {
                result.expense += transaction.amount
            }
        }
        
        let balance = totals.income - totals.expense
        let percentage = totals.income > 0 ? Float(totals.expense / totals.income) : 0
        
        return Summary(
            income: totals.income,
            expense: totals.expense,
            balance: balance,
            spentPercentage: min(percentage, 1.0) // Clamp to 1.0 (100%) for UI safety
        )
    }
    
    /// Groups expenses by category and returns sorted segments for the Donut Chart.
    static func getDonutSegments(from transactions: [Transaction]) -> [DonutSegment] {
    let expenses = transactions.filter { $0.type == .expense }
    let groups = Dictionary(grouping: expenses) { $0.category }

    return groups
        .map { (category, list) in
            (category, list.reduce(0) { $0 + $1.amount })
        }
        .sorted { $0.1 > $1.1 }
        .enumerated()
        .map { index, item in
            DonutSegment(
                title: item.0,
                value: CGFloat(item.1),
                color: UIColor.generateColor(for: index)
            )
        }
    }
}


extension UIColor {

    static func generateColor(for index: Int) -> UIColor {

        // Brand-safe base palette (used first)
        let basePalette: [UIColor] = [
            .systemRed,
            .systemBlue,
            .systemGreen,
            .systemOrange,
            .systemPurple,
            .systemTeal,
            .systemPink,
            .systemIndigo
        ]

        // Use palette first
        if index < basePalette.count {
            return basePalette[index]
        }

        // Generate distinct colors using HSB color wheel
        let hue = CGFloat(index - basePalette.count) * 0.13
        return UIColor(
            hue: hue.truncatingRemainder(dividingBy: 1),
            saturation: 0.75,
            brightness: 0.9,
            alpha: 1.0
        )
    }
}
