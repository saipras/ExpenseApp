import UIKit

final class TransactionsViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var addButton: UIButton!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var headingLbl: UILabel!

    // MARK: - Private UI Components
    private let emptyStateView = EmptyStateView()
    private let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        return table
    }()

    // MARK: - Data Source
    // Using a simple local array to manage the current UI state
    // and syncing with the Store separately to avoid "State Race Conditions"
    private var transactions: [Transaction] = [] {
        didSet {
            updateUIForState()
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        loadData()
    }

    // MARK: - Configuration
    private func configureView() {
        view.backgroundColor = .systemBackground
        setupHierarchy()
        setupConstraints()
        setupComponents()
    }

    private func setupHierarchy() {
        view.addSubview(tableView)
        view.addSubview(emptyStateView)
    }

    private func setupComponents() {
        // TableView
        tableView.dataSource = self
        tableView.delegate = self
        let nib = UINib(nibName: "TransactionCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TransactionCell")

        // SearchBar
        searchBar.placeholder = "Search transactions"
        searchBar.delegate = self // Best practice to handle search logic

        // Empty State
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateView.setAddButtonTarget(self, action: #selector(openAddTransaction))

        // Navigation Add Button
        addButton.addTarget(self, action: #selector(openAddTransaction), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // TableView
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Empty State
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 32),
            emptyStateView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -32)
        ])
    }

    // MARK: - Data Management
    private func loadData() {
        // Fetch from Store once
        self.transactions = TransactionStore.shared.transactions
        tableView.reloadData()
    }

    private func updateUIForState() {
        let isEmpty = transactions.isEmpty
        
        // Use Animations for smoother state transitions (Best Practice)
        UIView.animate(withDuration: 0.25) {
            self.emptyStateView.alpha = isEmpty ? 1 : 0
            self.tableView.alpha = isEmpty ? 0 : 1
            
            // Don't hide the search bar/heading usually, but if you must:
            self.searchBar.alpha = isEmpty ? 0 : 1
            self.headingLbl.alpha = isEmpty ? 0 : 1
            self.addButton.alpha = isEmpty ? 0 : 1
        }
        
        emptyStateView.isHidden = !isEmpty
        tableView.isHidden = isEmpty
    }

    // MARK: - Navigation
    @objc private func openAddTransaction() {
        // Use the Class-Based naming to avoid String errors
        let vc = AddTransactionsViewController(nibName: String(describing: AddTransactionsViewController.self), bundle: nil)
        vc.delegate = self
        vc.modalPresentationStyle = .pageSheet // Recommended for input forms
        present(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TransactionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell", for: indexPath) as? TransactionCell else {
            return UITableViewCell()
        }
        cell.configure(with: transactions[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            transactions.remove(at: indexPath.row)
            TransactionStore.shared.transactions = transactions // Sync back to store
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

// MARK: - UITableViewDelegate
extension TransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: - UISearchBarDelegate
extension TransactionsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Implementation for searching
    }
}

// MARK: - AddTransactionDelegate
extension TransactionsViewController: AddTransactionDelegate {
    func didAddTransaction(_ transaction: Transaction) {
        // 1. Update the Local State
        transactions.insert(transaction, at: 0)
        
        // 2. Sync to Persistent Store
        TransactionStore.shared.transactions = transactions
        
        // 3. Update UI
        // reloadData is safer here because the "isEmpty" state toggle
        // changes the view hierarchy visibility
        tableView.reloadData()
    }
}
