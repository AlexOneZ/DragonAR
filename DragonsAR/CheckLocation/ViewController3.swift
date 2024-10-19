//
//  ViewController3.swift
//  DragonsAR
//
//  Created by Алексей Кобяков on 09.01.2023.
//

import UIKit
import CoreLocation

class ViewController3: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    
    let alert: UIAlertController = {
        let alert = UIAlertController(
            title: nil,
            message: """
            Мы не знаем где Вы находитесь на карте,
            разрешите нам определить ваше местоположение, это делается
            в настройках устройства
            """,
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Перейти к настройкам",
                                      style: .default) {_ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
        })
        return alert
    }()
    
    lazy var backgroundImage: UIImageView = {
        let image = UIImage(named: "Background_3")
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
        DispatchQueue.main.async {
            self.present(self.alert, animated: true, completion: nil)
        }
    }
    
    private func setupConstraints() {
        backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -10).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    // Метод делегата, который позволяет определить разрешение пользователя
    // на использование геопозиции
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == .authorizedAlways || status == .authorizedWhenInUse) {
            print("Permission has")
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
            print("NO PERMISSION")
        }
        else {
            print("other")
        }
    }
}

