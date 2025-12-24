//
//  DashboardViewController.swift
//  ExpenseApp
//
//  Created by sai on 07/12/25.
//  Copyright © 2025 expensetracker. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var headingLbl: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var currentBalanceLbl: UILabel!
    @IBOutlet weak var balanceLbl: UILabel!
    @IBOutlet weak var balanceprogressBar: UIProgressView!
    @IBOutlet weak var seperatorView: UIView!
    @IBOutlet weak var icomeIcon: UIImageView!
    @IBOutlet weak var expenseIcon: UIImageView!
    @IBOutlet weak var incomeLbl: UILabel!
    @IBOutlet weak var expenseLbl: UILabel!
    @IBOutlet weak var icomeValue: UILabel!
    @IBOutlet weak var expenseValue: UILabel!
    @IBOutlet weak var percentageLbl: UILabel! 
    private let emptyStateView = EmptyStateView()
    
    private var totalIncome: Double {
        transactions
            .filter { $0.type == .income }
            .reduce(0) { $0 + $1.amount }
    }

    private var totalExpense: Double {
        transactions
            .filter { $0.type == .expense }
            .reduce(0) { $0 + $1.amount }
    }

    private var balance: Double {
        totalIncome - totalExpense
    }

    private var spentPercentage: Float {
        guard totalIncome > 0 else { return 0 }
        return Float(totalExpense / totalIncome)
    }

    
    private var transactions: [Transaction] {
        get { TransactionStore.shared.transactions }
        set {
            TransactionStore.shared.transactions = newValue
            updateUIForState()
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmptyStateView()
        updateUIForState()
        emptyStateView.setAddButtonTarget(
            self,
            action: #selector(openAddTransaction)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIForState()
    }

    
    
    private func setupEmptyStateView() {
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(emptyStateView)
        
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
            emptyStateView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32)
        ])
    }
    
    
   private func updateUIForState() {
        let isEmpty = transactions.isEmpty

        emptyStateView.isHidden = !isEmpty
        emptyStateView.isUserInteractionEnabled = isEmpty

        headingLbl.isHidden = isEmpty
        containerView.isHidden = isEmpty

        guard !isEmpty else { return }

        updateDashboardContent()
    }
    
    private func updateProgressBar() {
        let progress = spentPercentage

        balanceprogressBar.setProgress(progress, animated: true)

        switch progress {
        case 0.0..<0.6:
            balanceprogressBar.progressTintColor = .systemBlue
        case 0.6..<0.8:
            balanceprogressBar.progressTintColor = .systemYellow
        default:
            balanceprogressBar.progressTintColor = .systemRed
        }
    }

    
    private func updateDashboardContent() {

        
        icomeValue.text = "+₹\(totalIncome)"
        expenseValue.text = "-₹\(totalExpense)"

        // 2️⃣ Balance
        balanceLbl.text = "₹\(balance)"
       

        // 3️⃣ Progress bar
        updateProgressBar()

        // 4️⃣ Percentage label
        let percent = Int(spentPercentage * 100)
        balanceLbl.text = "₹\(balance)"
        percentageLbl.text = "\(percent)% of income spent"
    }


    
    @objc private func openAddTransaction() {
        let vc = AddTransactionsViewController(
            nibName: "AddTransactionsViewController",
            bundle: nil
        )
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
    }
}
