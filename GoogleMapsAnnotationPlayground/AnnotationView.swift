import UIKit

/// View supporting swap between two contents
///
/// - Note: Hacked together sizing to provide demonstration of functionality
class AnnotationView: UIView {

  // MARK: - Types
  struct State {

    /// Variants
    enum Size {
      case expanded
      case compact
    }

    var name: String
    var size: Size

    var isLabelHidden: Bool {
      switch size {
      case .compact: return true
      case .expanded: return false
      }
    }
  }

  var state: State = State(name: "Default", size: .expanded) {
    didSet {
      label.text = state.name
      label.isHidden = state.isLabelHidden
      invalidateIntrinsicContentSize()
    }
  }

  lazy var label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 1
    label.text = state.name
    label.adjustsFontSizeToFitWidth = true
    label.minimumScaleFactor = 0.6
    label.textAlignment = .center
    return label
  }()

  init(_ state: State) {
    self.state = state
    super.init(frame: .zero)
    setup()
  }

  required init?(coder: NSCoder) {
    fatalError()
  }

  private func setup() {
    addSubview(label)
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
      label.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
      label.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
      label.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
    ])
    backgroundColor = .white

    layer.cornerRadius = 6
    layer.masksToBounds = true
    insetsLayoutMarginsFromSafeArea = false
  }

  override var intrinsicContentSize: CGSize {

    switch state.size {
    case .expanded:
      // Hack, consider other ways to provide sizing
      let size = label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      let padded = CGSize(
        width: size.width + layoutMargins.left + layoutMargins.right,
        height: size.height + layoutMargins.top + layoutMargins.bottom
      )
      return padded
    case .compact:
      return CGSize(width: 12.0, height: 12.0)
    }
  }
}
