//
//  TransactionsViewController.swift
//  ExpenseApp
//
//  Created by sai on 07/12/25.
//  Copyright © 2025 expensetracker. All rights reserved.
//

import UIKit

import UIKit

protocol AddTransactionDelegate: AnyObject {
    func didAddTransaction(_ transaction: Transaction)
}

class TransactionsViewController: UIViewController {

    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var headingLbl: UILabel!

    private let emptyStateView = EmptyStateView()
    private let tableView = UITableView()

  private var transactions: [Transaction] {
        get { TransactionStore.shared.transactions }
        set {
            TransactionStore.shared.transactions = newValue
            updateUIForState()
        }
    }


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupAddButton()
        setupSearchBar()
        setupTableView()
        setupEmptyStateView()

        emptyStateView.setAddButtonTarget(
            self,
            action: #selector(openAddTransaction)
        )

        updateUIForState()
    }

    // MARK: - Setup

    private func setupAddButton() {
        addButton.addTarget(
            self,
            action: #selector(openAddTransaction),
            for: .touchUpInside
        )
    }

    private func setupSearchBar() {
        searchBar.placeholder = "Search transactions"
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self

        let nib = UINib(nibName: "TransactionCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TransactionCell")

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
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

    // MARK: - UI State

    private func updateUIForState() {
        let isEmpty = transactions.isEmpty

        emptyStateView.isHidden = !isEmpty
        emptyStateView.isUserInteractionEnabled = isEmpty

        addButton.isHidden = isEmpty
        headingLbl.isHidden = isEmpty
        searchBar.isHidden = isEmpty
        tableView.isHidden = isEmpty
    }

    // MARK: - Navigation

    @objc private func openAddTransaction() {
        let vc = AddTransactionsViewController(
            nibName: "AddTransactionsViewController",
            bundle: nil
        )
        vc.delegate = self
        vc.modalPresentationStyle = .automatic
        present(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TransactionsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
   func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {

        guard editingStyle == .delete else { return }

        transactions.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }


    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "TransactionCell",
            for: indexPath
        ) as! TransactionCell

        cell.configure(with: transactions[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension TransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

// MARK: - AddTransactionDelegate
extension TransactionsViewController: AddTransactionDelegate {
   func didAddTransaction(_ transaction: Transaction) {

        let wasEmpty = transactions.isEmpty

        transactions.insert(transaction, at: 0)

        if wasEmpty {
            // First item → show table
            tableView.reloadData()
        } else {
            // Normal insert
            tableView.insertRows(
                at: [IndexPath(row: 0, section: 0)],
                with: .automatic
            )
        }
    }

}
