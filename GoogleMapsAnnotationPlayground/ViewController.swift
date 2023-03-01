import UIKit
import GoogleMaps

class ViewController: UIViewController {

  // MARK: - Models

  let sydney = CLLocationCoordinate2D(latitude: -33.86, longitude: 151.20)
  var provider = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10].makeIterator()


  // MARK: - View

  let iconView: AnnotationView = {
    let state = AnnotationView.State.name("Ralph")
    return AnnotationView(state)
  }()

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

    // Anchor to center of marker
    marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
    marker.appearAnimation = .pop
    return marker
  }()

  lazy var addButton: UIButton = {
    let action = UIAction(title: "Add") { [weak self] _ in
      guard let self = self else { return }
      self.addMarker(self.sydneyMarker)
    }
    let button = UIButton(type: .system, primaryAction: action)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  lazy var removeButton: UIButton = {
    let action = UIAction(title: "Remove") { [weak self] _ in
      guard let self = self else { return }
      self.removeMarker(self.sydneyMarker)
    }
    let button = UIButton(type: .system, primaryAction: action)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()

  lazy var shrinkButton: UIButton = {
    let action = UIAction(title: "Shrink") { [weak self] _ in
      guard let self = self else { return }
      self.shrinkMarker(self.sydneyMarker)
    }
    let button = UIButton(type: .system, primaryAction: action)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()


  // MARK: - Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()

    GMSServices.provideAPIKey("YOUR_API_KEY")
    GMSServices.setMetalRendererEnabled(true)

    view.addSubview(mapView)
    NSLayoutConstraint.activate([
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    view.addSubview(removeButton)
    NSLayoutConstraint.activate([
      removeButton.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      removeButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
    ])

    view.addSubview(shrinkButton)
    NSLayoutConstraint.activate([
      shrinkButton.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
      shrinkButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
    ])

    view.addSubview(addButton)
    NSLayoutConstraint.activate([
      addButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      addButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
    ])

    let camera = GMSCameraPosition(target: sydney, zoom: 6.0)
    mapView.animate(to: camera)
  }

  func addMarker(_ marker: GMSMarker) {
    // Set outside for cleaner animations
    marker.tracksViewChanges = true
    marker.map = self.mapView

    UIView.animate(
      withDuration: 0.2,
      delay: 0.0,
      options: [
//        .layoutSubviews,
        .beginFromCurrentState,
      ],
      animations: {
        let identifier = self.provider.next().flatMap(String.init)
        let state: AnnotationView.State = identifier.flatMap { .identifier($0) } ?? .name("Empty")
        self.iconView.state = state
        self.iconView.frame.size = self.iconView.intrinsicContentSize
      },
      completion: { completed in
        marker.tracksViewChanges = false
      })
  }

  func shrinkMarker(_ marker: GMSMarker) {
    // Set outside for cleaner animations
    marker.tracksViewChanges = true

    UIView.animate(
      withDuration: 0.2,
      delay: 0.0,
      options: [
//        .layoutSubviews,
        .beginFromCurrentState,
      ],
      animations: {
        self.iconView.frame.size = CGSize(width: 12, height: 12)
      },
      completion: { completed in
        marker.tracksViewChanges = false
      })
  }

  func removeMarker(_ marker: GMSMarker) {
    marker.map = nil
  }
}

