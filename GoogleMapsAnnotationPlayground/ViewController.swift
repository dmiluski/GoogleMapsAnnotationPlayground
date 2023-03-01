import UIKit
import GoogleMaps

class ViewController: UIViewController {

  // MARK: - Models

  let sydney = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
  var provider = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10].makeIterator()


  // MARK: - Views

  lazy var iconView: AnnotationView = AnnotationView(.init(name: "InitialValue", size: .expanded))

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

  lazy var sydneyMarker: GMSMarker = {
    // Creates a marker in the center of the map.
    let marker = GMSMarker()
    marker.position = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
    marker.title = "Sydney"
    marker.snippet = "Australia"

    marker.iconView = iconView

    // Anchor to bottom of marker
    marker.appearAnimation = .pop

    return marker
  }()

  lazy var addButton: UIButton = {
    let action = UIAction(title: "Add") { [weak self] _ in
      guard let self = self else { return }
      self.addMarker(self.sydneyMarker)
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
      self.resizeMarker(self.sydneyMarker)
    }
    let button = UIButton(type: .system, primaryAction: action)
    return button
  }()

  /// Changes Contents
  lazy var changeButton: UIButton = {
    let action = UIAction(title: "Update") { [weak self] _ in
      guard let self = self else { return }
      self.updateContent(self.sydneyMarker)
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

    let camera = GMSCameraPosition(target: sydney, zoom: 6.0)
    mapView.animate(to: camera)
  }
}

// MARK: - Actions

extension ViewController {

  func addMarker(_ marker: GMSMarker) {

    // Must occur outside of the animation block to receive SDK appear animation treatment
    marker.map = self.mapView

    // Set outside for cleaner animations
//    marker.tracksViewChanges = true
//    self.iconView.frame.size = self.iconView.intrinsicContentSize

//    self.iconView.state = AnnotationView.State(name: makeNextName(), size: .expanded)
    self.iconView.frame.size = self.iconView.intrinsicContentSize
//    UIView.animate(
//      withDuration: 0.2,
//      delay: 0.0,
//      options: [
//        .layoutSubviews,
//        .beginFromCurrentState,
//      ],
//      animations: {
////        self.iconView.frame.size = self.iconView.intrinsicContentSize
//      },
//      completion: { completed in
//        marker.tracksViewChanges = false
//      })
  }

  func updateContent(_ marker: GMSMarker) {

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

  func resizeMarker(_ marker: GMSMarker) {

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

  func removeMarker(_ marker: GMSMarker) {
    marker.map = nil
  }

}

