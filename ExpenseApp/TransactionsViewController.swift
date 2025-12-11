//
//  TransactionsViewController.swift
//  ExpenseApp
//
//  Created by sai on 07/12/25.
//  Copyright © 2025 expensetracker. All rights reserved.
//

import UIKit

class TransactionsViewController: UIViewController {
    
    private let emptyStateView = EmptyStateView()
    
    private var transactions: [Transaction] = [] {
        didSet { updateUIForState() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigation()
        setupEmptyStateView()
        
        // connect button inside empty view
        emptyStateView.setAddButtonTarget(self, action: #selector(openAddTransaction))
        
        // start with no data
        transactions = []
    }
    
    // MARK: - Setup
    
    private func setupNavigation() {
        title = "Transactions"
        
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
    
    // MARK: - State Handling
    
    private func updateUIForState() {
        // later you’ll toggle tableView here
        emptyStateView.isHidden = !transactions.isEmpty
    }
    
    // MARK: - Actions
    
    @objc private func openAddTransaction() {
     let vc = AddTransactionsViewController()
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
    }
    
}


