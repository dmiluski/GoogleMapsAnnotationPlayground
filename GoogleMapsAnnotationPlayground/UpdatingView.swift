// Created by Dane Miluski on 3/14/23.
// Copyright © 2023 Airbnb Inc. All rights reserved.

import UIKit

class UpdatingView: UIView {

  struct Content {
    var state: State = .red
    var value: Int = 0

    mutating func toggleColor() {
      switch state {
      case .purple:
        state = .red
      case .red:
        state = .purple
      }
    }
  }

  enum State {
    case red
    case purple

    var color: UIColor {
      switch self {
      case .red:
        return .red
      case .purple:
        return .purple
      }
    }
  }

  func setContent(_ content: Content) {
    backgroundColor = content.state.color
    label.text = "\(content.value)"
    invalidateIntrinsicContentSize()
  }

  init() {
    super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
    setup()
  }

  private lazy var label: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 50)
    label.setContentCompressionResistancePriority(.required, for: .horizontal)
    label.setContentCompressionResistancePriority(.required, for: .vertical)

    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }

  func setup() {
    backgroundColor = .red
    label.text = "0"
    addSubview(label)

    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: leadingAnchor),
      label.trailingAnchor.constraint(equalTo: trailingAnchor),
      label.topAnchor.constraint(equalTo: topAnchor),
      label.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }
}
