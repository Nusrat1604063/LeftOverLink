////
////  MapViewModel.swift
////  MapMonitoring
////
////  Created by Tabassum Akter Nusrat on 23/7/25.
////
//
//import Foundation
//import CoreLocation
//import MapKit
//import SwiftUICore
//
//final class MapViewModel :NSObject, ObservableObject, CLLocationManagerDelegate {
//    var locationManager: CLLocationManager?
//    
//    @Published  var region = MKCoordinateRegion(center:(CLLocationCoordinate2D(latitude: 23.8103, longitude: 90.4125)), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//    
//   
//    func checkIfLocationServicesEnabled() {
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager = CLLocationManager()
//            locationManager!.delegate = self // force unwrap as we're creating it here
//            checkLocationAuthorizationStatus()
//            //locationManager?.desiredAccuracy = kCLLocationAccuracyBest //accordng to activity type
//        }else {
//            print("Location services are not enabled")
//        }
//    }
//    
//    private func checkLocationAuthorizationStatus() {
//        guard let locationManager = locationManager else { return }
//        switch locationManager.authorizationStatus {
//        case . notDetermined:
//            locationManager.requestWhenInUseAuthorization()
//        case .restricted:
//            print("Location services are restricted")
//        case .denied:
//            print("Denied location access")
//        case .authorizedAlways, .authorizedWhenInUse:
//            region = MKCoordinateRegion(center:locationManager.location!.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
//            print(locationManager.location!.coordinate)
//            
//        @unknown default:
//            break
//        }
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        checkLocationAuthorizationStatus()
//    }
//}
