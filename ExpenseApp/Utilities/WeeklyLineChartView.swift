import UIKit

// MARK: - Model
struct DonutSegment: Equatable {
    let id = UUID()
    let title: String
    let value: CGFloat
    let color: UIColor
}

import UIKit

final class DonutChartView: UIView {

    // MARK: - Style
    struct Style {
        let lineWidth: CGFloat = 18
        let donutSize: CGFloat = 200
        let donutTopSpacing: CGFloat = 10
        let padding: CGFloat = 20
        let legendWidth: CGFloat = 100
    }

    var style = Style() {
        didSet { setNeedsLayout() }
    }

    // MARK: - State
    private var segments: [DonutSegment] = []
    private var donutLayers: [CAShapeLayer] = []
    private let backgroundLayer = CAShapeLayer()

    // MARK: - UI
    private let donutContainerView = UIView()
    private let legendStack = UIStackView()
    private let centerStack = UIStackView()
    private let titleLabel = UILabel()
    private let valueLabel = UILabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        setupHierarchy()
        setupStyles()
        setupConstraints()
    }

    private func setupHierarchy() {
        addSubview(donutContainerView)
        addSubview(legendStack)

        donutContainerView.addSubview(centerStack)
        centerStack.addArrangedSubview(titleLabel)
        centerStack.addArrangedSubview(valueLabel)
    }

    private func setupStyles() {
        donutContainerView.translatesAutoresizingMaskIntoConstraints = false
        legendStack.translatesAutoresizingMaskIntoConstraints = false
        centerStack.translatesAutoresizingMaskIntoConstraints = false

        legendStack.axis = .vertical
        

        centerStack.axis = .vertical
        centerStack.alignment = .center
       
        titleLabel.text = "TOTAL"
        titleLabel.font = .systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .secondaryLabel

        valueLabel.font = .systemFont(ofSize: 16, weight: .bold)
        valueLabel.adjustsFontSizeToFitWidth = true
    }

    // MARK: - Constraints (NO overlap)
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            donutContainerView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: -20),
            donutContainerView.topAnchor.constraint(equalTo: topAnchor,constant: style.padding),
           donutContainerView.widthAnchor.constraint(equalToConstant: style.donutSize),
            donutContainerView.heightAnchor.constraint(equalToConstant: style.donutSize),

            centerStack.centerXAnchor.constraint(equalTo: donutContainerView.centerXAnchor),
            centerStack.centerYAnchor.constraint(equalTo: donutContainerView.centerYAnchor),

           legendStack.leadingAnchor.constraint(equalTo: donutContainerView.trailingAnchor,constant:  -15),
            legendStack.centerYAnchor.constraint(equalTo: donutContainerView.centerYAnchor,constant: 5),
            legendStack.trailingAnchor.constraint(
                lessThanOrEqualTo: trailingAnchor,
                constant: -style.padding
            ),


            bottomAnchor.constraint(
                greaterThanOrEqualTo: donutContainerView.bottomAnchor,
                constant: style.padding
            )
        ])
    }

    // MARK: - Public API
    func configure(with segments: [DonutSegment], centerText: String?) {
        guard !segments.isEmpty else {
            clearChart()
            return
        }

        self.segments = segments
        valueLabel.text = centerText ?? "—"

        rebuildLegend()
        prepareLayers()

        setNeedsLayout()
        layoutIfNeeded()
    }

    // MARK: - Layers
    private func prepareLayers() {
        donutLayers.forEach { $0.removeFromSuperlayer() }
        donutLayers.removeAll()

        backgroundLayer.removeFromSuperlayer()
        backgroundLayer.fillColor = UIColor.clear.cgColor
        backgroundLayer.strokeColor = UIColor.systemGray5.cgColor
        backgroundLayer.lineWidth = style.lineWidth
        backgroundLayer.lineCap = .butt
        donutContainerView.layer.insertSublayer(backgroundLayer, at: 0)

        for segment in segments {
            let layer = CAShapeLayer()
            layer.fillColor = UIColor.clear.cgColor
            layer.strokeColor = segment.color.cgColor
            layer.lineWidth = style.lineWidth
            layer.lineCap = .butt
            donutContainerView.layer.addSublayer(layer)
            donutLayers.append(layer)
        }
    }

    // MARK: - Drawing
    override func layoutSubviews() {
        super.layoutSubviews()

        guard !segments.isEmpty else { return }

        let total = segments.reduce(0) { $0 + $1.value }
        guard total > 0 else { return }

        let side = min(donutContainerView.bounds.width,
                       donutContainerView.bounds.height)
        debugPrint("The side of the donnut is\(donutContainerView.bounds.width)")

        let radius = (side - style.lineWidth) / 2 - 1
        let center = CGPoint(
            x: donutContainerView.bounds.midX,
            y: donutContainerView.bounds.midY
        )

        backgroundLayer.path = UIBezierPath(
            arcCenter: center,
            radius: radius,
            startAngle: 0,
            endAngle: 2 * .pi,
            clockwise: true
        ).cgPath

        var startAngle = -CGFloat.pi / 2

        for (index, segment) in segments.enumerated() {
            let endAngle = startAngle + (segment.value / total) * 2 * .pi

            let path = UIBezierPath(
                arcCenter: center,
                radius: radius,
                startAngle: startAngle,
                endAngle: endAngle,
                clockwise: true
            )

            donutLayers[index].path = path.cgPath
            startAngle = endAngle
        }
    }

    // MARK: - Legend
    private func rebuildLegend() {
        legendStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let total = segments.reduce(0) { $0 + $1.value }

        segments.forEach {
            let percent = Int(($0.value / total) * 100)
            let row = LegendRowView(
                color: $0.color,
                title: $0.title,
                value: "\(percent)%"
            )
            legendStack.addArrangedSubview(row)
        }
    }

    private func clearChart() {
        donutLayers.forEach { $0.removeFromSuperlayer() }
        donutLayers.removeAll()
        backgroundLayer.removeFromSuperlayer()
        legendStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        valueLabel.text = "—"
    }
}
