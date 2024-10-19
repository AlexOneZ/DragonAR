//
//  ViewController.swift
//  DragonsAR
//
//  Created by Алексей Кобяков on 09.01.2023.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var hasLocationPermisson = false
    
    let alert: UIAlertController = {
        let alert = UIAlertController(
            title: nil,
            message: """
            Для того, чтобы показать Вас
            и ближайших монстров, разрешите
            приложению доступ к вашей
            геопозиции
            """,
            preferredStyle: .alert)
        return alert
    }()
    
    lazy var backgroundImage: UIImageView = {
        let image = UIImage(named: "Background_1")
        let bgView = UIImageView(image: image)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.contentMode = .scaleToFill
        return bgView
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        
        view.addSubview(backgroundImage)
        setupConstraints()
        
        alert.addAction(UIAlertAction(title: "Разрешить",
                                      style: .default) {  _ in
            self.CheckLocationPermission()
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if(!self.hasLocationPermisson) {
                self.present(self.alert, animated: true, completion: nil)
            }
        }
    }
    
    private func setupConstraints() {
        backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -10).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    private func CheckLocationPermission() {
        locationManager?.requestAlwaysAuthorization()
    }

    // Метод делегата, который позволяет определить разрешение пользователя
    // на использование геопозиции
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            print("Permission has")
            hasLocationPermisson = true
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "mapStoryboard")
            present(vc, animated: true)
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    print("Permission has")
                }
            }
        }
        else if (status == .denied || status == .restricted) {
            hasLocationPermisson = false
            print("NO PERMISSION")
            //let vc: UIViewController = ViewController()
            present(ViewController3(), animated: true)
        }
        else {
            print("other")
        }
    }
}

