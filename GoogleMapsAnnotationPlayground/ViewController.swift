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
  let region = Region(
    southwest: CLLocationCoordinate2D(latitude: -41.094738152514914, longitude: 146.91533032804728),
    southEast: CLLocationCoordinate2D(latitude: -41.094738152514914, longitude: 155.48466760665178),
    northWest: CLLocationCoordinate2D(latitude: -25.699533074519202, longitude: 146.91533032804728),
    northEast: CLLocationCoordinate2D(latitude: -25.699533074519202, longitude: 155.48466760665178))

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
  lazy var slider: UISlider = {

    let action = UIAction(title: "Slider") { [weak self] _ in
      guard let self else { return }
      self.didUpdateSlider(self.slider)
    }
    let slider = UISlider(frame: .zero, primaryAction: action)
    slider.translatesAutoresizingMaskIntoConstraints = false
    return slider
  }()
  lazy var updatingView = UpdatingView()
  var content = UpdatingView.Content()

  func makeNextName() -> String {
    provider.next().flatMap(String.init) ?? "EOL"
  }

  lazy var mapView: GMSMapView = {
    GMSServices.provideAPIKey("YOUR_KEY")
    GMSServices.setMetalRendererEnabled(true)
    let mapView = GMSMapView()
    mapView.translatesAutoresizingMaskIntoConstraints = false
    return mapView
  }()

  // Marker holding updatingView as iconView
  lazy var updatingMarker: GMSAdvancedMarker = {
    // Creates a marker in the center of the map.
    let marker = GMSAdvancedMarker()
    marker.position = CLLocationCoordinate2D(latitude: -32.2444, longitude: 148.6144)
//    marker.groundAnchor = .init(x: 0.5, y: 0.5)
    marker.title = "Dubbo"
    marker.snippet = "Australia"

    marker.iconView = updatingView

    // Anchor to bottom of marker
    marker.appearAnimation = .pop

    return marker
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

    view.addSubview(slider)
    NSLayoutConstraint.activate([
      slider.bottomAnchor.constraint(equalTo: segmentedControl.topAnchor, constant: -8),
      slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
    ])

    setRegion(region, edgeInsets:  .zero)
  }
}

// MARK: - Actions

extension ViewController {

  func addMarker(_ marker: GMSAdvancedMarker) {
    // Must occur outside of the animation block to receive SDK appear animation treatment
    marker.map = self.mapView
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

    // Update Model
    self.updateContent()

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
    // Change Color
    content.toggleColor()

    // Change Text content
    content.value += 1
  }

  func removeMarker(_ marker: GMSAdvancedMarker) {
    marker.map = nil
  }

  public func didUpdateSlider(_ slider: UISlider) {

    // Use Slider position to adjust bottom insets
    let insets = UIEdgeInsets(
      top: 0,
      left: 0,
      bottom: CGFloat(slider.value) * mapView.frame.size.height,
      right: 0)
    setRegion(region, edgeInsets: insets)
  }

  public func setRegion(_ region: Region, edgeInsets: UIEdgeInsets) {
    // Convert to Bounds using (Southwest, NorthEast Coordinates)
    let bounds = GMSCoordinateBounds(coordinate: region.southwest, coordinate: region.northEast)

    // `GMSCameraUpdate.fit` automatically includes `map.padding`,
    // so we need to subtract out the padding from the given `edgeInsets`.
    let adjustedInsets = edgeInsets - mapView.padding
    let cameraUpdate = GMSCameraUpdate.fit(bounds, with: adjustedInsets)

    mapView.moveCamera(cameraUpdate)
  }

}

struct Region {
  let southwest: CLLocationCoordinate2D
  let southEast: CLLocationCoordinate2D
  let northWest: CLLocationCoordinate2D
  let northEast: CLLocationCoordinate2D
}

extension GMSCoordinateBounds {
  convenience init(_ region: Region) {
    self.init(coordinate: region.southwest, coordinate: region.northEast)
  }
}

extension GMSVisibleRegion {
  init(_ region: Region) {
    self.init(
      nearLeft: region.southwest,
      nearRight: region.southEast,
      farLeft: region.northWest,
      farRight: region.northEast
    )
  }
}

func -(lhs: UIEdgeInsets, rhs: UIEdgeInsets) -> UIEdgeInsets {
  UIEdgeInsets(
    top: lhs.top - rhs.top,
    left: lhs.left - rhs.left,
    bottom: lhs.bottom - rhs.bottom,
    right: lhs.right - rhs.right)
}
