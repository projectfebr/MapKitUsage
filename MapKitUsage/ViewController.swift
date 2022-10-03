//
//  ViewController.swift
//  MapKitUsage
//
//  Created by Aleksandr Bolotov on 29.09.2022.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    private var places: [Place] = []

    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.isZoomEnabled = true
            mapView.isRotateEnabled = true
            mapView.showsUserLocation = true
        }
    }

    private let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        askUserLocation()
        loadInitialData()
        mapView.addAnnotations(places)
    }

    override func viewDidAppear(_ animated: Bool) {
        if let location = locationManager.location {
            lookForLatestLocation(location: location)
        }
    }

    func askUserLocation(){
        locationManager.requestWhenInUseAuthorization()
    }

    func lookForLatestLocation(location: CLLocation){

        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1_000_000, longitudinalMeters: 1_000_000)
        mapView.setCenter(location.coordinate, animated: true)
        mapView.setRegion(region, animated: true)
    }

    private func loadInitialData() {
      guard
        let fileName = Bundle.main.url(forResource: "map", withExtension: "geojson"),
        let placeData = try? Data(contentsOf: fileName)
        else {
          return
      }

      do {
        let features = try MKGeoJSONDecoder()
          .decode(placeData)
          .compactMap { $0 as? MKGeoJSONFeature }
        let validWorks = features.compactMap(Place.init)
        places.append(contentsOf: validWorks)
      } catch {
        print("Unexpected error: \(error).")
      }
    }




    //    private func showLocationAccessAlert() {
    //        let alert = UIAlertController(title: "Выключена службу геолокации", message: "Включить службу геолокации?", preferredStyle: .alert)
    //        let settingsAction = UIAlertAction(title: "Настройки", style: .default) { (action) in
    //            if let url = URL(string: "App-Prefs:root=LOCATION_SERVICES") {
    //                UIApplication.shared.open(url)
    //            }
    //        }
    //        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
    //        alert.addAction(settingsAction)
    //        alert.addAction(cancelAction)
    //        present(alert, animated: true)
    //    }
    //
    //    private func setupLocationManager() {
    //        locationManager.delegate = self
    //        locationManager.requestWhenInUseAuthorization()
    //        switch locationManager.authorizationStatus {
    //        case .denied, .restricted : showLocationAccessAlert()
    //        default: locationManager.requestLocation()
    //        }
    //
    //    }
}

extension ViewController: CLLocationManagerDelegate {


    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = manager.location {
                lookForLatestLocation(location: location)
            }
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            lookForLatestLocation(location: location)
        }
    }
}

extension ViewController: MKMapViewDelegate{

//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        if annotation is MKUserLocation { return nil }
//        let view = MKMarkerAnnotationView()
//        view.animatesWhenAdded = true
//        view.annotation = annotation
//        return view
//    }
//
//    func mapView(_ mapView: MKMapView, didSelect annotation: MKAnnotation) {
//        if annotation is MKUserLocation { return }
//        if annotation is MKMapFeatureAnnotation { return }
//        //        selectedAnnotation = annotation
//        //        presentWithSheet(item: annotation)
//    }
}

extension CLLocationCoordinate2D : Equatable{
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return (lhs.latitude == rhs.latitude) && (lhs.longitude == rhs.longitude)
    }
}



/*
 Новороссийск
 44.728336134753995, 37.76452884667245

 Анапа
 44.88663281948941, 37.32893816794553

 Раевская
 44.83482858301943, 37.55493036950672

 Крымск
 44.92480256976325, 37.98986634912673
 */



//            mapView.showsUserLocation = true
//            var annotation = MKPointAnnotation()
//            var centerCoordinate = CLLocationCoordinate2D(latitude: 44.728336134753995, longitude:37.76452884667245)
//            annotation.coordinate = centerCoordinate
//            annotation.title = "Новороссийск"
//            mapView.addAnnotation(annotation)
//
//            annotation = MKPointAnnotation()
//             centerCoordinate = CLLocationCoordinate2D(latitude: 44.88663281948941, longitude:37.32893816794553)
//            annotation.coordinate = centerCoordinate
//            annotation.title = "Анапа"
//            mapView.addAnnotation(annotation)
//
//            annotation = MKPointAnnotation()
//             centerCoordinate = CLLocationCoordinate2D(latitude: 44.83482858301943, longitude:37.55493036950672)
//            annotation.coordinate = centerCoordinate
//            annotation.title = "Раевская"
//            mapView.addAnnotation(annotation)
//
//            annotation = MKPointAnnotation()
//             centerCoordinate = CLLocationCoordinate2D(latitude: 44.92480256976325, longitude:37.98986634912673)
//            annotation.coordinate = centerCoordinate
//            annotation.title = "Крымск"
//            mapView.addAnnotation(annotation)

