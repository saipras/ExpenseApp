//
//  Utility.swift
//  ExpenseApp
//
//  Created by sai on 09/12/25.
//  Copyright © 2025 expensetracker. All rights reserved.
//

import Foundation
import UIKit

enum SettingsSection: Int, CaseIterable {
    case appearance
    case preferences
    case data
    case appInfo
}

enum SettingsRow {
    case darkMode
    case currency
    case reset
    case export
    case version
    case terms
    case privacy
}

struct SettingsConfig {
    static let sections: [[SettingsRow]] = [
        [.darkMode],                 // Appearance
        [.currency],                 // Preferences
        [.reset, .export],           // Data
        [.version, .terms, .privacy] // App Info
    ]
    
    static func title(for section: Int) -> String? {
        switch section {
        case 0: return "Appearance"
        case 1: return "Preferences"
        case 2: return "Data"
        case 3: return "App Info"
        default: return nil
        }
    }
}
