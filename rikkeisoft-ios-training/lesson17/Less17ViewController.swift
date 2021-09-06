//
//  ViewController.swift
//  lesson17
//
//  Created by Đại Nguyễn  on 8/27/21.
//

import UIKit
import MapKit
import CoreLocation

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

class Less17ViewController: UIViewController {
    @IBOutlet weak var showDirect: UIButton!
    
    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    private var currentPlace: MKPlacemark?
    
    var resultSearchController:UISearchController? = nil
    
    var selectedPlace:MKPlacemark? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapMap)))
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        configSearchControl()
    }
    
    @IBAction func locate_me(_ sender: Any) {
        guard let currentLocation = locationManager.location
        else { return }
        
        currentLocation.lookUpLocationName { (name) in
            self.updateLocationOnMap(to: currentLocation, with: name)
            
        }
        
        currentLocation.lookUpPlaceMark { (placemark) in
            guard let placemark = placemark,
                  let location = placemark.location else {
                return
            }
            self.currentPlace = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
        }
        
        
    }
    @IBAction func show_direct(_ sender: Any) {
        for overlay in mapView.overlays {
            mapView.removeOverlay(overlay)
        }
        
        guard let currentPlace = currentPlace,
              let selectedPlace = selectedPlace else {
            return
        }
        
        showRouterOnMap(currentPlace: currentPlace, destinationPlace: selectedPlace)
    }
    
    @objc func didTapMap(_ gesture: UITapGestureRecognizer) {
        
        for overlay in mapView.overlays {
            mapView.removeOverlay(overlay)
        }
        
        let locationInView = gesture.location(in: mapView)
        let coordinates = mapView.convert(locationInView, toCoordinateFrom: mapView)
        
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
        
        // drop a pin on that location
        let pin = MKPointAnnotation()
        
        pin.coordinate = coordinates
        
        
        mapView.addAnnotation(pin)
        
        let location = CLLocation(latitude: coordinates.latitude, longitude: coordinates.longitude)
        location.lookUpLocationName { (name) in
            self.updateLocationOnMap(to: location, with: name)
            
            pin.title = name
        }
        
        selectedPlace = MKPlacemark(coordinate: coordinates)
    }
    
    func configSearchControl() {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchViewController") as! LocationSearchViewController
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        locationSearchTable.mapView = mapView
        
        locationSearchTable.handleMapSearchDelegate = self
    }
    
    func updateLocationOnMap(to location: CLLocation, with title: String?) {
        let point = MKPointAnnotation()
        point.title = title
        point.coordinate = location.coordinate
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(point)
        
        let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 200, longitudinalMeters: 200)
        
        mapView.setRegion(viewRegion, animated: true)
        
    }
    
    func updatePlaceMark(to address: String) {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemark = placemarks?.first,
                let location = placemark.location
            else { return }
            
            self.updateLocationOnMap(to: location, with: placemark.name)
        }
    }
    
    func getAddress(latitude: Double, longitude: Double, handler: @escaping (String?) -> Void) {
        
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = latitude
        center.longitude = longitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude:center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            guard let placemarks = placemarks else {
                return
            }
            if placemarks.count > 0 {
                var addressString : String = ""
                
                if placemarks[0].name != nil {
                    addressString = addressString + placemarks[0].name! + ", "
                }
                
                if placemarks[0].subLocality != nil {
                    addressString = addressString + placemarks[0].subLocality! + ", "
                }
                if placemarks[0].locality != nil {
                    addressString = addressString + placemarks[0].locality!
                }
                
                handler(addressString)
            }
        })
    }
}

extension Less17ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            return
        }
        
        location.lookUpLocationName { (name) in
            self.updateLocationOnMap(to: location, with: name)
        }
        
        location.lookUpPlaceMark { (placemark) in
            guard let placemark = placemark,
                  let location = placemark.location else {
                return
            }
            self.currentPlace = MKPlacemark(coordinate: location.coordinate, addressDictionary: nil)
        }
    }
    
}

extension Less17ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "pin"
        var view: MKAnnotationView
        
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            dequeuedView.annotation = annotation
            view = dequeuedView
            
        } else {
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.image = UIImage(named: "pin")
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        // add name
        let annotationLabel = UILabel(frame: CGRect(x: -30, y: view.frame.height + 5, width: 105, height: 40))

        annotationLabel.numberOfLines = 3
        annotationLabel.textAlignment = .center
        annotationLabel.font = UIFont(name: "Rockwell", size: 10)
        
        annotationLabel.text = annotation.title ?? ""

        annotationLabel.backgroundColor = UIColor.gray
        annotationLabel.layer.cornerRadius = 5
        annotationLabel.clipsToBounds = true
        
        view.addSubview(annotationLabel)
        return view
        
    }
    
    func showRouterOnMap(currentPlace: MKPlacemark, destinationPlace: MKPlacemark) {
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: currentPlace)
        request.destination = MKMapItem(placemark: destinationPlace)
        request.requestsAlternateRoutes = true
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }
            
            for route in unwrappedResponse.routes {
                
                self.mapView.addOverlay(route.polyline)
                
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets.init(top: 80.0, left: 20.0, bottom: 100.0, right: 20.0), animated: true)
                
            }
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.green
        renderer.lineWidth = 5.0
        return renderer
    }
}

extension CLLocation {
    func lookUpPlaceMark(_ handler: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(self) { (placemarks, error) in
            if error == nil {
                let firstLocation = placemarks?[0]
                
                handler(firstLocation)
            }
            else {
                handler(nil)
            }
        }
    }
    
    func lookUpLocationName(_ handler: @escaping (String?) -> Void) {
        
        lookUpPlaceMark { (placemark) in
            guard let placemark = placemark else {
                return
            }
            var addressString : String = ""
            
            if placemark.name != nil {
                addressString = addressString + placemark.name! + ", "
            }
            if placemark.subLocality != nil {
                addressString = addressString + placemark.subLocality! + ", "
            }
            if placemark.locality != nil {
                addressString = addressString + placemark.locality!
            }
            
            handler(addressString)
        }
    }
}

extension Less17ViewController: HandleMapSearch {
    func dropPinZoomIn(placemark:MKPlacemark){
        // cache the pin
        selectedPlace = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        
        mapView.addAnnotation(annotation)
        
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
        
        let location = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        location.lookUpLocationName { (name) in
            self.updateLocationOnMap(to: location, with: name)
            
            annotation.title = name
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
