// Created by Dane Miluski on 3/14/23.
// Copyright © 2023 Airbnb Inc. All rights reserved.

import UIKit

class UpdatingView: UIView {

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

  var state: State = .red {
    didSet {
      backgroundColor = state.color
    }
  }

  init() {
    super.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
    setup()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setup()
  }

  func setup() {
    backgroundColor = state.color
  }

  override var intrinsicContentSize: CGSize {
    return CGSize(width: 44, height: 44)
  }

  func toggleColor() {
    switch state {
    case .purple:
      state = .red
    case .red:
      state = .purple
    }
  }


}
