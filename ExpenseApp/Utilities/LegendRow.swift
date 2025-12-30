import UIKit

final class LegendRowView: UIView {

    private let contentStack = UIStackView()

    init(color: UIColor, title: String, value: String) {
        super.init(frame: .zero)
        setup(color: color, title: title, value: value)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup(color: UIColor, title: String, value: String) {
        let dot = UIView()
        dot.backgroundColor = color
        dot.layer.cornerRadius = 6
        dot.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dot.widthAnchor.constraint(equalToConstant: 12),
            dot.heightAnchor.constraint(equalToConstant: 12)
        ])
        
      


        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 14)

        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 12, weight: .medium)
        valueLabel.textColor = .secondaryLabel
        valueLabel.setContentHuggingPriority(.required, for: .horizontal)

          let spacer = UIView()

        contentStack.axis = .horizontal
        contentStack.alignment = .center
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        contentStack.addArrangedSubview(dot)
        contentStack.addArrangedSubview(titleLabel)
        contentStack.addArrangedSubview(spacer)   // 🔑 THIS
        contentStack.addArrangedSubview(valueLabel)
        
        
        valueLabel.setContentCompressionResistancePriority(.required, for: .horizontal)


        addSubview(contentStack)

        NSLayoutConstraint.activate([
            contentStack.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            contentStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            contentStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentStack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

