//
//  ViewControllerMap.swift
//  DragonsAR
//
//  Created by Алексей Кобяков on 11.01.2023.
//

import UIKit
import CoreLocation
import MapKit

class ViewControllerMap: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    @IBOutlet var mapView: MKMapView!
    var latitude: Double = 124.0
    var longitude: Double = 81.0
    var userLocation: CLLocation = CLLocation() {
        didSet {
            if(!isMonsterSpawn) {
                //print("change position")
                monstersAnnotationList = monsterListGenerate(
                    countOfMonsters: 30,
                    userLocation: userLocation)
                setMonstersToMap()
                isMonsterSpawn = true
            }
        }
    }
    var isMonsterSpawn = false
    var monstersAnnotationList: [MonsterAnnotation] = []
    var timerChangeMonster: Timer?
    var timerChangePosition: Timer?
    var isChange: Bool = false
    
    // MARK: - Buttons
    private lazy var myteamButton: UIButton = {
        let button = UIButton(type: .custom)
        
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        button.backgroundColor = color
        button.setTitle("Моя команда", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.widthAnchor.constraint(equalToConstant: 270).isActive = true
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.layer.cornerRadius = 15
        
        button.addTarget(self, action: #selector(openMyTeam), for: .touchUpInside)
        return button
    }()
    
    private lazy var locationButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let icon = UIImage(named: "locationimage")
        button.setImage(icon!, for: .normal)
        
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        button.backgroundColor = color
        
        button.widthAnchor.constraint(equalToConstant: 55).isActive = true
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(didTapLocationButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var minesZoomButton: UIButton = {
        let button = UIButton(type: .custom)
        
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        button.backgroundColor = color
        button.setTitle("-", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.widthAnchor.constraint(equalToConstant: 55).isActive = true
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.layer.cornerRadius = 15
        
        button.addTarget(self, action: #selector(didTapZoomMinesButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var plusZoomButton: UIButton = {
        let button = UIButton(type: .custom)
        
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        button.backgroundColor = color
        button.setTitle("+", for: .normal)
        button.setTitleColor(.white, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.widthAnchor.constraint(equalToConstant: 55).isActive = true
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.layer.cornerRadius = 15
        
        button.addTarget(self, action: #selector(didTapZoomPlusButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - functions
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        mapView.delegate = self
        
        view.addSubview(locationButton)
        view.addSubview(myteamButton)
        view.addSubview(minesZoomButton)
        view.addSubview(plusZoomButton)
        
        setupConstraints()
        view.bringSubviewToFront(locationButton)
        view.bringSubviewToFront(myteamButton)
        view.bringSubviewToFront(minesZoomButton)
        view.bringSubviewToFront(plusZoomButton)
        
        showUserOnMap()
        
        // Таймер, который раз в 5 минут меняет монстров
        timerChangeMonster = Timer.scheduledTimer(
         timeInterval: 300,
         target: self,
         selector: #selector(monsterChange),
         userInfo: nil,
         repeats: true)
        
        // Таймер, который проверяет изменение позиции пользователя через 15 секунд
        timerChangePosition = Timer.scheduledTimer(
         timeInterval: 15,
         target: self,
         selector: #selector(positionChanged),
         userInfo: nil,
         repeats: true)
    }
    
    @objc private func positionChanged() {
        isChange = false
        print("change pos")
    }
    
    // Открывает экран с командой
    @objc private func openMyTeam() {
        let vc = MyTeamViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func setupConstraints() {
        // my team button
        myteamButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myteamButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35).isActive = true
        
        //location button
        locationButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        locationButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -175).isActive = true
        
        //mines button
        minesZoomButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        minesZoomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -415).isActive = true
        
        //plus button
        plusZoomButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true
        plusZoomButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -475).isActive = true
    }
}
