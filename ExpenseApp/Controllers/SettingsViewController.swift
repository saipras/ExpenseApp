//
//  SettingsViewController.swift
//  ExpenseApp
//
//  Created by sai on 09/12/25.
//  Copyright © 2025 expensetracker. All rights reserved.
//

import UIKit
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var settingLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let sections = SettingsConfig.sections
    private var isDarkModeOn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        
        tableView.register(SettingsTableViewCell.nib(),
                           forCellReuseIdentifier: SettingsTableViewCell.identifier)
        
        tableView.register(CustomTableViewCell.nib(),
                           forCellReuseIdentifier: CustomTableViewCell.identifier)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // MARK: - Actions / Handlers
    
    @objc private func didChangeDarkModeSwitch(_ sender: UISwitch) {
        isDarkModeOn = sender.isOn
        print("Dark mode is now: \(isDarkModeOn)")
        // apply theme here
    }
    
    private func showCurrencyPicker() {
        // if you ever want a separate screen/modal picker
    }
    
    private func confirmResetAllData() {
        // TODO
    }
    
    private func exportData() {
        // TODO
    }
    
    private func showTermsAndConditions() {
        let termsText = """
        These are the sample Terms & Conditions for the ExpenseApp.

        • Use this app at your own risk.
        • Your data is stored locally on this device.
        • By continuing to use this app, you agree to these terms.
        """

        showAlert(title: "Terms & Conditions", message: termsText)
    }
    
    private func showPrivacyPolicy() {
        let privacyText = """
        This is a sample Privacy Policy.

        • Your expense data is not shared with anyone.
        • You are responsible for backing up your data.
        """

        showAlert(title: "Privacy Policy", message: privacyText)
    }
    
    // MARK: - Alert Helper
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK",
                                      style: .default,
                                      handler: nil))
        present(alert, animated: true, completion: nil)
    }
}



extension SettingsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return SettingsConfig.title(for: section)
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rowType = sections[indexPath.section][indexPath.row]
        
        switch rowType {
        case .darkMode:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                     for: indexPath)
            cell.textLabel?.text = "Dark Mode"
            
            let toggle = UISwitch()
            toggle.isOn = isDarkModeOn
            toggle.addTarget(self,
                             action: #selector(didChangeDarkModeSwitch(_:)),
                             for: .valueChanged)
            cell.accessoryView = toggle
            cell.selectionStyle = .none
            return cell
            
        case .currency:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CustomTableViewCell.identifier,
                for: indexPath
            ) as! CustomTableViewCell
            
            cell.configure(with: "Currency", subHeading: "INR")
            return cell
            
        case .reset:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingsTableViewCell.identifier,
                for: indexPath
            ) as! SettingsTableViewCell
            cell.configure(with: "Reset All Data", imageName: "trash.fill")
            return cell
            
        case .export:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SettingsTableViewCell.identifier,
                for: indexPath
            ) as! SettingsTableViewCell
            cell.configure(with: "Export", imageName: "square.and.arrow.up")
            return cell
            
        case .version:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: CustomTableViewCell.identifier,
                for: indexPath
            ) as! CustomTableViewCell
            cell.configure(with: "Version", subHeading: "1.0.0")
            cell.selectionStyle = .none
            return cell
            
        case .terms:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                     for: indexPath)
            cell.textLabel?.text = "Terms and Conditions"
            cell.textLabel?.textColor = UIColor.blue
            return cell
            
        case .privacy:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
                                                     for: indexPath)
            cell.textLabel?.text = "Privacy Policy"
            cell.textLabel?.textColor = UIColor.blue
            return cell
        }
    }
}



extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        
        let rowType = sections[indexPath.section][indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
       
        switch rowType {
        case .currency:
            showCurrencyPicker()
        case .reset:
            confirmResetAllData()
        case .export:
            exportData()
        case .terms:
            showTermsAndConditions()
        case .privacy:
            showPrivacyPolicy()
        default:
            break
        }
    }
}
