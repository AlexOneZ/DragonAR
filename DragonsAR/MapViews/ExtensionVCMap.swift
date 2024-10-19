//
//  ExtensionVCMap.swift
//  DragonsAR
//
//  Created by Алексей Кобяков on 12.01.2023.
//

import CoreLocation
import MapKit

extension ViewControllerMap: MKMapViewDelegate {
    @objc func didTapLocationButton() {
        showUserOnMap()
    }
    
    // Показывает пользователя на карте
    func showUserOnMap() {
        if(latitude > 0.1) {
            latitude = latitude / 8192
            longitude = longitude / 8192
        }
        locationManager.startUpdatingLocation()
        mapView.setUserTrackingMode(.follow, animated: true)
    }
    
    @objc func didTapZoomMinesButton() {
        var region = mapView.region

        if(latitude < 124) {
            latitude = latitude * 2
            longitude = longitude * 2
            region.span.latitudeDelta = latitude
            region.span.longitudeDelta = longitude
        }
        print("mines \(longitude) \(latitude)")
        mapView.setRegion(region, animated: true)
    }
    
    @objc func didTapZoomPlusButton() {
        var region = mapView.region
        if(latitude > 0.01) {
            longitude = longitude / 2
            latitude = latitude / 2
            region.span.latitudeDelta = latitude
            region.span.longitudeDelta = longitude
        }
        print("plus\(longitude)")
        mapView.setRegion(region, animated: true)
    }
    
    // Добавляет монстров на карту
    func setMonstersToMap() {
        let annotations = mapView.annotations
        if(annotations.count > 0) {
            mapView.removeAnnotations(annotations)
        }
        if(monstersAnnotationList.count > 0) {
            for index in 0...(monstersAnnotationList.count - 1){
                //print(monstersAnnotationList.count)
                let annotation: MKPointAnnotation = MKPointAnnotation()
                annotation.coordinate.latitude = monstersAnnotationList[index].coordinate.coordinate.latitude
                annotation.coordinate.longitude = monstersAnnotationList[index].coordinate.coordinate.longitude
                annotation.title = monstersAnnotationList[index].monster.name
                annotation.subtitle = String(index)
                mapView.addAnnotation(annotation)
            }
        }
    }

    // Удаляет монстра из списка
    func removeMonster(index: String) {
        let id = Int(index) ?? 0
        monstersAnnotationList.remove(at: id)
        setMonstersToMap()
    }
    
    // Проверяет растояние от пользователя до монстра
    func checkDistanceToAnnotation(annotation: MKAnnotation) -> Double {
        let distance = userLocation.distance(from: CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude))
        
        return distance
    }
    
    // Метод делегата, который позволяет отслеживать изменение позиции
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        if(!isChange) {
            isChange = true
            userLocation = location
            setMonstersToMap()
            
            mapView.setRegion(MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: latitude, longitudeDelta: longitude)),
                              animated: false)
        }
    }
    
    // Метод делегата, который позволяет добавить view к аннотации
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        
        if(annotationView == nil) {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            annotationView?.canShowCallout = true
        }
        else {
            annotationView?.annotation = annotation
        }
        switch annotation.title {
        case ConstantMonstersName.dinoName:
            annotationView?.image = UIImage(named: ConstantMonstersName.dinoName)
        case ConstantMonstersName.dragoName:
            annotationView?.image = UIImage(named: ConstantMonstersName.dragoName)
        case ConstantMonstersName.sleptName:
            annotationView?.image = UIImage(named: ConstantMonstersName.sleptName)
        case ConstantMonstersName.serpName:
            annotationView?.image = UIImage(named: ConstantMonstersName.serpName)
        case ConstantMonstersName.rexName:
            annotationView?.image = UIImage(named: ConstantMonstersName.rexName)
        case ConstantMonstersName.morderName:
            annotationView?.image = UIImage(named: ConstantMonstersName.morderName)
        case ConstantMonstersName.grizlName:
            annotationView?.image = UIImage(named: ConstantMonstersName.grizlName)
        case ConstantMonstersName.grizlforceName:
            annotationView?.image = UIImage(named: ConstantMonstersName.grizlforceName)
        case ConstantMonstersName.tinaName:
            annotationView?.image = UIImage(named: ConstantMonstersName.tinaName)
        case ConstantMonstersName.hipeName:
            annotationView?.image = UIImage(named: ConstantMonstersName.hipeName)
        case ConstantMonstersName.grayName:
            annotationView?.image = UIImage(named: ConstantMonstersName.grayName)
        default:
            annotationView?.image = UIImage(named: ConstantMonstersName.dinoName)
        }
        let transfrom = CGAffineTransform(scaleX: 0.045, y: 0.045)
        annotationView?.transform = transfrom
        let distance = checkDistanceToAnnotation(annotation: annotation)
        if (distance > 300) {
            annotationView?.isHidden = true
        }
        return annotationView
    }
    
    // Метод делегата, который позволяет реагировать на нажатия по
    // аннотации
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }
        let distance = checkDistanceToAnnotation(annotation: annotation)
        //print(distance)
        if(distance <= 100) {
            //print("100")
            removeMonster(index: annotation.subtitle! ?? "0")
            
            let name: String = (annotation.title ?? ConstantMonstersName.dinoName)!
            let storyboard = UIStoryboard(name: "ARScreen", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "arStoryboard") as! ViewControllerAR
            vc.monsterName = name
            present(vc, animated: true)
        }
        else {
            //print("> 100")
            let alert = UIAlertController(title: "",
                                          message: "Вы находитесь слишком далеко о монстра -  \(distance) метров",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
