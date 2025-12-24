import UIKit

import UIKit

class AddTransactionsViewController: UIViewController,
                                     UITextFieldDelegate,
                                     UITextViewDelegate {

    @IBOutlet weak var notesEntry: UITextView!
    @IBOutlet weak var transactiontypeControl: UISegmentedControl!
    @IBOutlet weak var categoryEntry: UITextField!
    @IBOutlet weak var dateEntry: UITextField!
    @IBOutlet weak var amountEntry: UITextField!
    @IBOutlet weak var detailsEntry: UITextField!

    weak var delegate: AddTransactionDelegate?

    private let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        setupTextFields()
        setupTextView()
        setupDatePicker()
    }

    // MARK: - Setup

    private func setupTextFields() {
        [detailsEntry, categoryEntry, dateEntry, amountEntry].forEach {
            $0?.delegate = self
        }

        amountEntry.keyboardType = .decimalPad
    }

    private func setupTextView() {
        notesEntry.delegate = self
        notesEntry.layer.cornerRadius = 8
        notesEntry.layer.borderWidth = 0.5
        notesEntry.layer.borderColor = UIColor.systemGray4.cgColor
    }

    private func setupDatePicker() {
        datePicker.datePickerMode = .dateAndTime

        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        datePicker.addTarget(self,
                             action: #selector(dateChanged),
                             for: .valueChanged)

        // Date picker as input view
        dateEntry.inputView = datePicker

        // 🔹 Toolbar with Done button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        let doneButton = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneDatePicker)
        )

        toolbar.setItems([flexibleSpace, doneButton], animated: false)

        // Attach toolbar to text field
        dateEntry.inputAccessoryView = toolbar
    }
    
    @objc private func doneDatePicker() {
        dateChanged()          // set text
        view.endEditing(true)  // dismiss picker
    }



    // MARK: - Actions

    @IBAction func doneBtnTapped(_ sender: UIButton) {
        let type: TransactionType =
            transactiontypeControl.selectedSegmentIndex == 0 ? .expense : .income

        let transaction = Transaction(
            id: UUID(),
            type: type,
            title: detailsEntry.text ?? "",
            amount: Double(amountEntry.text ?? "") ?? 0,
            date: datePicker.date,
            category: categoryEntry.text ?? "",
            notes: notesEntry.text
        )

        delegate?.didAddTransaction(transaction)
        dismiss(animated: true)
    }

    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }

    // MARK: - Helpers

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func dateChanged() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateEntry.text = formatter.string(from: datePicker.date)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

