import UIKit
import GoogleMaps

class ViewController: UIViewController {



  enum Option {
    case flipTracksViewChangesNoAnimation
    case updateWithoutAnimation
    case updateWithViewPropertyAnimation
    case updateWithViewAnimation
  }

  var testOption: Option = .flipTracksViewChangesNoAnimation

  // MARK: - Models

  let sydney = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
  var provider = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].makeIterator()


  // MARK: - Views

  lazy var segmentedControl: UISegmentedControl = {
    let actions = [
      UIAction(title: "Flip") { [weak self] _ in
        self?.testOption = .flipTracksViewChangesNoAnimation
      },
      UIAction(title: "NonAnim") { [weak self] _ in
        self?.testOption = .updateWithoutAnimation
      },
      UIAction(title: "PropertyAnim") { [weak self] _ in
        self?.testOption = .updateWithViewPropertyAnimation
      },
      UIAction(title: "UIViewAnim") { [weak self] _ in
        self?.testOption = .updateWithViewAnimation
      },
    ]
    let control = UISegmentedControl(frame: .zero, actions: actions)
    control.translatesAutoresizingMaskIntoConstraints = false
    return control
  }()
  lazy var iconView: AnnotationView = AnnotationView(.init(name: "InitialValue", size: .expanded))
  lazy var updatingView = UpdatingView()
  var content = UpdatingView.Content()

  func makeNextName() -> String {
    provider.next().flatMap(String.init) ?? "EOL"
  }

  lazy var mapView: GMSMapView = {

    GMSServices.provideAPIKey("YOUR_API_KEY")
    GMSServices.setMetalRendererEnabled(true)
    let mapView = GMSMapView()
    mapView.translatesAutoresizingMaskIntoConstraints = false
    return mapView
  }()

  lazy var sydneyMarker: GMSAdvancedMarker = {
    // Creates a marker in the center of the map.
    let marker = GMSAdvancedMarker()
    marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
    marker.groundAnchor = .init(x: 0.5, y: 0.5)
    marker.title = "Sydney"
    marker.snippet = "Australia"

    marker.iconView = iconView

    // Anchor to bottom of marker
    marker.appearAnimation = .pop

    return marker
  }()

  // Marker holding updatingView as iconView
  lazy var updatingMarker: GMSAdvancedMarker = {
    // Creates a marker in the center of the map.
    let marker = GMSAdvancedMarker()
    marker.position = CLLocationCoordinate2D(latitude: -32.2444, longitude: 148.6144)
    marker.groundAnchor = .init(x: 0.5, y: 0.5)
    marker.title = "Dubbo"
    marker.snippet = "Australia"

    marker.iconView = updatingView

    // Anchor to bottom of marker
    marker.appearAnimation = .pop

    return marker
  }()

  lazy var addButton: UIButton = {
    let action = UIAction(title: "Add") { [weak self] _ in
      guard let self = self else { return }
      self.addMarker(self.sydneyMarker)
      self.iconView.frame.size = self.iconView.intrinsicContentSize
    }
    let button = UIButton(type: .system, primaryAction: action)
    return button
  }()

  lazy var removeButton: UIButton = {
    let action = UIAction(title: "Remove") { [weak self] _ in
      guard let self = self else { return }
      self.removeMarker(self.sydneyMarker)
    }
    let button = UIButton(type: .system, primaryAction: action)
    return button
  }()

  lazy var resizeButton: UIButton = {
    let action = UIAction(title: "Resize") { [weak self] _ in
      guard let self = self else { return }
      self.resizeSydneyMarker(self.sydneyMarker)
    }
    let button = UIButton(type: .system, primaryAction: action)
    return button
  }()

  /// Changes Contents
  lazy var changeButton: UIButton = {
    let action = UIAction(title: "Update") { [weak self] _ in
      guard let self = self else { return }
      self.updateSydneyContent(self.sydneyMarker)
    }
    let button = UIButton(type: .system, primaryAction: action)
    return button
  }()

  lazy var addColorChangingView: UIButton = {
    let action = UIAction(title: "Add") { [weak self] _ in
      guard let self = self else { return }
      self.addMarker(self.updatingMarker)
    }
    let button = UIButton(type: .system, primaryAction: action)
    return button
  }()

  lazy var toggleColorChangingView: UIButton = {
    let action = UIAction(title: "Update") { [weak self] _ in
      guard let self = self else { return }
      self.updateDubboContent(self.updatingMarker)
    }
    let button = UIButton(type: .system, primaryAction: action)
    return button
  }()

  /// Contains Buttons
  lazy var controls: UIView = {
    let stackView = UIStackView(arrangedSubviews: [
      resizeButton,
      changeButton,
      addButton,
      removeButton,
    ])
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  lazy var updatingViewControls: UIView = {

    let stackView = UIStackView(arrangedSubviews: [UIView(), addColorChangingView, toggleColorChangingView])
    stackView.axis = .horizontal
    stackView.distribution = .fill
    stackView.spacing = 20
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()


  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(mapView)
    NSLayoutConstraint.activate([
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    view.addSubview(controls)
    NSLayoutConstraint.activate([
      controls.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
      controls.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      controls.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
    ])

    view.addSubview(updatingViewControls)
    NSLayoutConstraint.activate([
      updatingViewControls.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
      updatingViewControls.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      updatingViewControls.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
    ])

    view.addSubview(segmentedControl)
    segmentedControl.selectedSegmentIndex = 0
    NSLayoutConstraint.activate([
      segmentedControl.bottomAnchor.constraint(equalTo: updatingViewControls.topAnchor, constant: -8),
      segmentedControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      segmentedControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
    ])

    let camera = GMSCameraPosition(target: sydney, zoom: 6.0)
    mapView.animate(to: camera)
  }
}

// MARK: - Actions

extension ViewController {

  func addMarker(_ marker: GMSAdvancedMarker) {
    // Must occur outside of the animation block to receive SDK appear animation treatment
    marker.map = self.mapView
  }

  func updateSydneyContent(_ marker: GMSAdvancedMarker) {

    // Set outside for cleaner animations
    marker.tracksViewChanges = true

    // Update Model
    iconView.state.name = provider.next().flatMap(String.init) ?? "EOL"

    UIView.animate(
      withDuration: 0.2,
      delay: 0.0,
      options: [
        .layoutSubviews,
        .beginFromCurrentState,
      ],
      animations: {
        self.iconView.frame.size = self.iconView.intrinsicContentSize
      },
      completion: { completed in
        marker.tracksViewChanges = false
      })
  }

  // Easily Repro Flicker given GMSMarker (Legacy)
  private func demoUpdatingViewFlicker(_ marker: GMSAdvancedMarker) {
    // If using GMSMarker (Not Advanced Marker), this triggers the flicker every time
    marker.tracksViewChanges = true
    marker.tracksViewChanges = false
  }

  // Change content, but no animation
  private func demoUpdatingViewContentUpdateNoAnimation(_ marker: GMSAdvancedMarker) {
    marker.tracksViewChanges = true

    // Update Model, Apply model to view
    updateContent()
    updatingView.setContent(self.content)
    updatingView.layoutIfNeeded()

    // Tweak marker properties to better align with App updates.
    // If any of these values are touched, the Marker's iconView flickers
//    marker.zIndex += 1
//    marker.title = (marker.title ?? "") + " "
    marker.tracksViewChanges = false
  }

  // Change content, but no animation
  private func demoUpdatingViewContentUpdateWithViewPropertyAnimation(_ marker: GMSAdvancedMarker) {
    marker.tracksViewChanges = true

    let curve = UICubicTimingParameters(controlPoint1: .init(x: 0.2, y: 0), controlPoint2: .init(x: 0, y: 1))
    let animator = UIViewPropertyAnimator(duration: 0.2, timingParameters: curve)

    // Update Model
    self.updateContent()

    animator.addAnimations {
      // Apply model to view
      self.updatingView.setContent(self.content)
      self.updatingView.layoutIfNeeded()
    }
    animator.addCompletion { _ in
      marker.tracksViewChanges = false
    }

    // Tweak marker properties to better align with App updates.
    // Should this be inside or outside animation?
    // If any of these values are touched, the Marker's iconView flickers
    // If these are not touched, the marker does Not flicker
//    marker.zIndex += 1
//    marker.title = (marker.title ?? "") + " "
//    marker.groundAnchor = .init(x: 0.5, y: 0.5)

    animator.startAnimation()
  }

  private func demoUpdatingViewContentUpdateWithUIViewAnimation(_ marker: GMSAdvancedMarker) {
    marker.tracksViewChanges = true

    UIView.animate(
      withDuration: 0.2,
      delay: 0.0,
      options: [],
      animations: {
        self.updatingView.setContent(self.content)
        self.updatingView.layoutIfNeeded()
      },
      completion: { completed in
        marker.tracksViewChanges = false
      })

    // Tweak marker properties to better align with App updates.
    // Should this be inside or outside animation?
    // If these are not touched, the marker does Not flicker
//    marker.zIndex += 1
//    marker.title = (marker.title ?? "") + " "
//    marker.groundAnchor = .init(x: 0.5, y: 0.5)
  }


  // How to reproduce blink
  func updateDubboContent(_ marker: GMSAdvancedMarker) {

    switch testOption {
    case .flipTracksViewChangesNoAnimation:
      demoUpdatingViewFlicker(marker)
    case .updateWithoutAnimation:
      demoUpdatingViewContentUpdateNoAnimation(marker)
    case .updateWithViewPropertyAnimation:
      demoUpdatingViewContentUpdateWithViewPropertyAnimation(marker)
    case .updateWithViewAnimation:
      demoUpdatingViewContentUpdateWithUIViewAnimation(marker)
    }
  }

  func updateContent() {
    content.toggleColor()
    content.value += 1
  }

  func resizeSydneyMarker(_ marker: GMSAdvancedMarker) {

    // Set outside for cleaner animations
    marker.tracksViewChanges = true

    let newSize: AnnotationView.State.Size = {
      switch iconView.state.size {
      case .expanded: return .compact
      case .compact: return .expanded
      }
    }()

    iconView.state.size = newSize

    UIView.animate(
      withDuration: 0.2,
      delay: 0.0,
      options: [
        .layoutSubviews,
        .beginFromCurrentState,
      ],
      animations: {
        switch newSize {
        case .compact:
          self.iconView.frame.size = CGSize(width: 12, height: 12)
        case .expanded:
          self.iconView.frame.size = self.iconView.intrinsicContentSize
        }
      },
      completion: { completed in
        marker.tracksViewChanges = false
      })
  }

  func removeMarker(_ marker: GMSAdvancedMarker) {
    marker.map = nil
  }

}

