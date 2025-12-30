//
//  DashboardViewController.swift
//  ExpenseApp
//

import UIKit

final class DashboardViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var headingLbl: UILabel!
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var currentBalanceLbl: UILabel!
    @IBOutlet private weak var balanceLbl: UILabel!
    @IBOutlet private weak var percentageLbl: UILabel!
    @IBOutlet private weak var balanceprogressBar: UIProgressView!
    @IBOutlet private weak var icomeIcon: UIImageView!
    @IBOutlet private weak var expenseIcon: UIImageView!
    @IBOutlet private weak var incomeLbl: UILabel!
    @IBOutlet private weak var expenseLbl: UILabel!
    @IBOutlet private weak var icomeValue: UILabel!
    @IBOutlet private weak var expenseValue: UILabel!
    @IBOutlet private weak var reportSegmentControl: UISegmentedControl!
    @IBOutlet private weak var categoryBreakdownLbl: UILabel!
    @IBOutlet private weak var currencyIcon: UIImageView!
    @IBOutlet private weak var containerStackView: UIStackView!
    @IBOutlet private weak var containerScrollView: UIScrollView!
    @IBOutlet private weak var donutChartView: DonutChartView!
    
    // MARK: - Properties
    private let emptyStateView = EmptyStateView()
    private var transactions: [Transaction] = []
    


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh data every time the dashboard appears (MVC Standard)
        refreshData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupEmptyStateView()
        
        // Setup initial interaction
        emptyStateView.setAddButtonTarget(self, action: #selector(openAddTransaction))
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

    // MARK: - Data Management
    private func refreshData() {
        self.transactions = TransactionStore.shared.transactions
        updateUIState()
    }

    private func updateUIState() {
        let isEmpty = transactions.isEmpty
        
        // Toggle visibility with smooth transition
        UIView.animate(withDuration: 0.3) {
            self.emptyStateView.alpha = isEmpty ? 1 : 0
            self.containerScrollView.alpha = isEmpty ? 0 : 1
        }
        
        emptyStateView.isHidden = !isEmpty
        containerScrollView.isHidden = isEmpty
        
        guard !isEmpty else { return }
        updateDashboardContent()
    }

   private func updateDashboardContent() {
        let summary = DashboardAnalytics.calculateSummary(from: transactions)

        // 1. Textual Data
        icomeValue.text = "+₹\(summary.income.formattedWithSeparator)"
        expenseValue.text = "-₹\(summary.expense.formattedWithSeparator)"
        balanceLbl.text = "₹\(summary.balance.formattedWithSeparator)"

        // 2. Progress & Percentage
        let percentInt = Int(summary.spentPercentage * 100)
        percentageLbl.text = "\(percentInt)% of income spent"
        updateProgressBar(with: summary.spentPercentage)

        // 3. Chart Data
        let segments = DashboardAnalytics.getDonutSegments(from: transactions)
        donutChartView.configure(
            with: segments,
            centerText: "₹\(summary.expense.formattedWithSeparator)"
        )
    }

    private func updateProgressBar(with progress: Float) {
        balanceprogressBar.setProgress(progress, animated: true)
        
        // Strategy pattern for color coding
        switch progress {
        case 0.0..<0.6:  balanceprogressBar.progressTintColor = .systemBlue
        case 0.6..<0.8:  balanceprogressBar.progressTintColor = .systemYellow
        default:         balanceprogressBar.progressTintColor = .systemRed
        }
    }

    // MARK: - Navigation
    @objc private func openAddTransaction() {
        let vc = AddTransactionsViewController(nibName: "AddTransactionsViewController", bundle: nil)
        // Note: Assign delegate if you want immediate dashboard refresh on add
        vc.modalPresentationStyle = .pageSheet
        present(vc, animated: true)
    }
}

// MARK: - Extensions for Utility
extension Double {
    var formattedWithSeparator: String {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
