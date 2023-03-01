import UIKit

/// View supporting swap between two contents
class AnnotationView: UIView {

  enum State {
    case identifier(String)
    case name(String)

    var value: String {
      switch self {
      case let .identifier(value):
        return value
      case let .name(value):
        return value
      }
    }
  }

  var state: State = .identifier("1") {
    didSet {
      label.text = state.value
      invalidateIntrinsicContentSize()
    }
  }

  lazy var label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = state.value
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
    backgroundColor = .purple
  }

  override var intrinsicContentSize: CGSize {
    // Hack, consider other ways to provide sizing
    let size = label.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    let padded = CGSize(
      width: size.width + layoutMargins.left + layoutMargins.right,
      height: size.height + layoutMargins.top + layoutMargins.bottom
    )
    return padded
  }
}
