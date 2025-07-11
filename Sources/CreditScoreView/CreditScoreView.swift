
import UIKit

public class CreditScoreView: UIView {

    // MARK: - Public Configurable Properties

    public var segments: [(start: Int, end: Int, color: UIColor, label: String)] = [
        (300, 580, .red, "Poor"),
        (580, 670, .orange, "Fair"),
        (670, 740, .yellow, "Good"),
        (740, 800, .green.withAlphaComponent(0.6), "Very Good"),
        (800, 850, .green, "Excellent")
    ] {
        didSet {
            reloadArcLayers()
        }
    }

    public var segmentWidth: CGFloat = 8 {
        didSet { reloadArcLayers() }
    }

    public var segmentSpacing: CGFloat = 0.08 {
        didSet { reloadArcLayers() }
    }

    public var markerSize: CGFloat = 20 {
        didSet { updateMarkerAppearance() }
    }

    // MARK: - Label Visibility and Style

    public var isScoreLabelVisible: Bool = true {
        didSet { scoreLabel.isHidden = !isScoreLabelVisible }
    }

    public var isMinLabelVisible: Bool = true {
        didSet { minLabel.isHidden = !isMinLabelVisible }
    }

    public var isMaxLabelVisible: Bool = true {
        didSet { maxLabel.isHidden = !isMaxLabelVisible }
    }

    public var scoreLabelFont: UIFont = UIFont.systemFont(ofSize: 32, weight: .bold) {
        didSet { scoreLabel.font = scoreLabelFont }
    }

    public var scoreLabelTextColor: UIColor = .label {
        didSet { scoreLabel.textColor = scoreLabelTextColor }
    }

    public var minLabelFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet { minLabel.font = minLabelFont }
    }

    public var minLabelTextColor: UIColor = .secondaryLabel {
        didSet { minLabel.textColor = minLabelTextColor }
    }

    public var maxLabelFont: UIFont = UIFont.systemFont(ofSize: 14) {
        didSet { maxLabel.font = maxLabelFont }
    }

    public var maxLabelTextColor: UIColor = .secondaryLabel {
        didSet { maxLabel.textColor = maxLabelTextColor }
    }

    // MARK: - Private Properties

    private let scoreLabel = UILabel()
    private let markerLayer = CALayer()
    private var arcPath: UIBezierPath?
    private var arcLayers: [CAShapeLayer] = []

    private let minLabel = UILabel()
    private let maxLabel = UILabel()

    // MARK: - Init

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupBaseView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBaseView()
    }

    // MARK: - Setup

    private func setupBaseView() {
        backgroundColor = .clear

        // Marker
        markerLayer.backgroundColor = UIColor.white.cgColor
        markerLayer.borderWidth = 2
        markerLayer.borderColor = UIColor.white.cgColor
        updateMarkerAppearance()
        layer.addSublayer(markerLayer)

        // Score label
        scoreLabel.textAlignment = .center
        scoreLabel.font = scoreLabelFont
        scoreLabel.textColor = scoreLabelTextColor
        scoreLabel.text = "0"
        scoreLabel.isHidden = !isScoreLabelVisible
        addSubview(scoreLabel)

        // Min label
        minLabel.font = minLabelFont
        minLabel.textColor = minLabelTextColor
        minLabel.textAlignment = .left
        minLabel.isHidden = !isMinLabelVisible
        addSubview(minLabel)

        // Max label
        maxLabel.font = maxLabelFont
        maxLabel.textColor = maxLabelTextColor
        maxLabel.textAlignment = .right
        maxLabel.isHidden = !isMaxLabelVisible
        addSubview(maxLabel)
    }

    private func updateMarkerAppearance() {
        markerLayer.bounds = CGRect(x: 0, y: 0, width: markerSize, height: markerSize)
        markerLayer.cornerRadius = markerSize / 2
    }

    private func reloadArcLayers() {
        arcLayers.forEach { $0.removeFromSuperlayer() }
        arcLayers.removeAll()

        guard segments.count > 0 else { return }

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2.5
        let adjustedRadius = radius - segmentWidth / 2
        let startAngle = CGFloat.pi
        let totalRange = CGFloat((segments.last!.end - segments.first!.start))

        for segment in segments {
            let rawStart = CGFloat(segment.start - segments.first!.start) / totalRange * .pi
            let rawEnd = CGFloat(segment.end - segments.first!.start) / totalRange * .pi

            let segmentStartAngle = startAngle + rawStart + segmentSpacing / 2
            let segmentEndAngle = startAngle + rawEnd - segmentSpacing / 2

            // Draw arc
            let path = UIBezierPath(arcCenter: center,
                                    radius: adjustedRadius,
                                    startAngle: segmentStartAngle,
                                    endAngle: segmentEndAngle,
                                    clockwise: true)

            let arcLayer = CAShapeLayer()
            arcLayer.path = path.cgPath
            arcLayer.strokeColor = segment.color.cgColor
            arcLayer.fillColor = UIColor.clear.cgColor
            arcLayer.lineWidth = segmentWidth
            arcLayer.lineCap = .round
            layer.insertSublayer(arcLayer, below: markerLayer)
            arcLayers.append(arcLayer)

            // Add label for this segment
            let midAngle = (segmentStartAngle + segmentEndAngle) / 2
            let labelRadius = adjustedRadius * 0.85
            let labelCenter = pointOnCircle(center: center, radius: labelRadius, angle: midAngle)
        }

        // Marker at arc start
        let dotStart = pointOnCircle(center: center, radius: adjustedRadius, angle: startAngle)
        markerLayer.position = dotStart

        // Score label
        scoreLabel.frame = CGRect(x: 0,
                                  y: bounds.midY - radius * 0.5,
                                  width: bounds.width,
                                  height: 50)

        // Min/Max Labels
        if let minScore = segments.first?.start,
           let maxScore = segments.last?.end {

            minLabel.text = "\(minScore)"
            maxLabel.text = "\(maxScore)"

            let labelY = bounds.midY
            minLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
            minLabel.center = CGPoint(x: labelY - radius + 20, y: labelY + 20)

            maxLabel.frame = CGRect(x: 0, y: 0, width: 60, height: 20)
            maxLabel.center = CGPoint(x: labelY + radius - 20, y: labelY + 20)
        }
    }

    // MARK: - Set Score

    public func setScore(_ score: Int) {
        scoreLabel.text = "\(score)"

        guard let minScore = segments.first?.start,
              let maxScore = segments.last?.end else { return }

        let totalRange = CGFloat(maxScore - minScore)
        let normalized = CGFloat(score - minScore) / totalRange

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2.5
        let adjustedRadius = radius - segmentWidth / 2
        let startAngle = CGFloat.pi
        let finalAngle = startAngle + normalized * .pi

        let finalPosition = pointOnCircle(center: center, radius: adjustedRadius, angle: finalAngle)

        // Animate marker
        let animationPath = UIBezierPath()
        animationPath.addArc(withCenter: center,
                             radius: adjustedRadius,
                             startAngle: startAngle,
                             endAngle: finalAngle,
                             clockwise: true)

        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = animationPath.cgPath
        animation.duration = 1.2
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)

        markerLayer.add(animation, forKey: "moveDot")

        // Sync position
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        markerLayer.position = finalPosition
        CATransaction.commit()

        // Change marker color
        markerLayer.borderColor = colorForScore(score).cgColor
    }

    // MARK: - Helpers

    private func pointOnCircle(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        CGPoint(
            x: center.x + radius * cos(angle),
            y: center.y + radius * sin(angle)
        )
    }

    private func colorForScore(_ score: Int) -> UIColor {
        for segment in segments {
            if score >= segment.start && score < segment.end {
                return segment.color
            }
        }
        return segments.last?.color ?? .black
    }
}
