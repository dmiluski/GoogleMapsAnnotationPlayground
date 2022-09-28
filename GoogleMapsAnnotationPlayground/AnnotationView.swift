import UIKit

/// View supporting swap between two contents
///
/// - Note: Hacked together sizing to provide demonstration of functionality
class AnnotationView: UIView {

  enum State {
    case identifier(String)
    case name(String)
    case mini

    var value: String {
      switch self {
      case let .identifier(value):
        return value
      case let .name(value):
        return value
      case .mini:
        return ""
      }
    }

    var isLabelHidden: Bool {
      switch self {
      case .identifier, .name:
        return false
      case .mini:
        return true
      }
    }
  }

  var state: State = .identifier("1") {
    didSet {
      label.text = state.value
      label.isHidden = state.isLabelHidden
      invalidateIntrinsicContentSize()
    }
  }

  lazy var label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 1
    label.text = state.value
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

    switch state {
    case .name, .identifier:
      // Hack, consider other ways to provide sizing
      let size = label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
      let padded = CGSize(
        width: size.width + layoutMargins.left + layoutMargins.right,
        height: size.height + layoutMargins.top + layoutMargins.bottom
      )
      return padded
    case .mini:
      return CGSize(width: 12.0, height: 12.0)
    }
  }
}
