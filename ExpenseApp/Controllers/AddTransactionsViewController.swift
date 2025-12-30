import UIKit

import UIKit

protocol AddTransactionDelegate: AnyObject {
    func didAddTransaction(_ transaction: Transaction)
}

final class AddTransactionsViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var notesEntry: UITextView!
    @IBOutlet private weak var transactiontypeControl: UISegmentedControl!
    @IBOutlet private weak var categoryEntry: UITextField!
    @IBOutlet private weak var dateEntry: UITextField!
    @IBOutlet private weak var amountEntry: UITextField!
    @IBOutlet private weak var detailsEntry: UITextField!

    // MARK: - Properties
    weak var delegate: AddTransactionDelegate?

    private let datePicker = UIDatePicker()
    private let categoryPicker = UIPickerView()

    private let categories = [
        "Housing",
        "Transportation",
        "Food",
        "Utilities",
        "Insurance",
        "Debt Payments",
        "Savings",
        "Salary"
    ]

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
        configureInteractions()
        configureDatePicker()
        configureCategoryPicker()
    }

    // MARK: - Configuration
    private func configureAppearance() {
        view.backgroundColor = .systemBackground
        notesEntry.layer.cornerRadius = 8
        notesEntry.layer.borderWidth = 0.5
        notesEntry.layer.borderColor = UIColor.systemGray4.cgColor
    }

    private func configureInteractions() {
        [detailsEntry, categoryEntry, dateEntry, amountEntry].forEach {
            $0?.delegate = self
            $0?.isUserInteractionEnabled = true
        }

        notesEntry.delegate = self
        amountEntry.keyboardType = .decimalPad

        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    private func configureDatePicker() {
        datePicker.datePickerMode = .dateAndTime
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)

        dateEntry.inputView = datePicker
        dateEntry.inputAccessoryView = makeToolbar(selector: #selector(doneDatePicker))
    }

    private func configureCategoryPicker() {
        categoryPicker.dataSource = self
        categoryPicker.delegate = self

        categoryEntry.inputView = categoryPicker
        categoryEntry.inputAccessoryView = makeToolbar(selector: #selector(doneCategoryPicker))
    }

    private func makeToolbar(selector: Selector) -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: selector
        )

        toolbar.setItems([flexSpace, doneButton], animated: false)
        return toolbar
    }

    // MARK: - Actions
    @IBAction func doneBtnTapped(_ sender: UIButton) {
        do {
            let transaction = try Transaction.create(
                typeIndex: transactiontypeControl.selectedSegmentIndex,
                title: detailsEntry.text,
                amount: amountEntry.text,
                date: datePicker.date,
                category: categoryEntry.text,
                notes: notesEntry.text
            )

            delegate?.didAddTransaction(transaction)
            dismiss(animated: true)

        } catch TransactionError.emptyTitle {
            showAlert(message: "Please enter a transaction title.")
        } catch TransactionError.invalidAmount {
            showAlert(message: "Please enter a valid amount greater than zero.")
        } catch {
            showAlert(message: "An unexpected error occurred.")
        }
    }

    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    @objc private func dateChanged() {
        dateEntry.text = dateFormatter.string(from: datePicker.date)
    }

    @objc private func doneDatePicker() {
        dateChanged()
        view.endEditing(true)
    }

    @objc private func doneCategoryPicker() {
        let selectedRow = categoryPicker.selectedRow(inComponent: 0)
        categoryEntry.text = categories[selectedRow]
        view.endEditing(true)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UIPickerView DataSource & Delegate
extension AddTransactionsViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        categories.count
    }

    func pickerView(_ pickerView: UIPickerView,
                    titleForRow row: Int,
                    forComponent component: Int) -> String? {
        categories[row]
    }
}

// MARK: - UITextFieldDelegate
extension AddTransactionsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITextViewDelegate
extension AddTransactionsViewController: UITextViewDelegate {}

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Notice",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
