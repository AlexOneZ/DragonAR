//
//  ExtensionVCMapMonsters.swift
//  DragonsAR
//
//  Created by Алексей Кобяков on 13.01.2023.
//

import UIKit
import MapKit

extension ViewControllerMap {
    
    // Создает монстров нужен для следующего метода
    private func monstersGenerate(countOfmonsters: Int) -> [Monster] {
        let allMonsters = AllMonsters()
        var monsters: [Monster] = []
        
        for _ in 0...(countOfmonsters - 1) {
            let monster = allMonsters.monsters[Int.random(in: 0...(allMonsters.monsters.count - 1))]
            monsters.append(monster)
        }
        
        return monsters
    }
    
    // Создает случайных монстров и задает их позицию
    func monsterListGenerate(countOfMonsters: Int, userLocation: CLLocation) -> [MonsterAnnotation] {
        let monsters: [Monster] = monstersGenerate(countOfmonsters: countOfMonsters)
        print("spawn monsters \(monsters.count)")
        var monstersAnnotation: [MonsterAnnotation] = []
        print("user \(userLocation.coordinate.longitude)")
        for index in 0...(monsters.count - 1) {
            //print(monsters.count - 1)
            var monsterLocation = CLLocation()
            let trigger = Float.random(in: 0...1)
            //print(trigger)
            if(trigger <= 0.25) {
                monsterLocation = CLLocation(latitude: userLocation.coordinate.latitude + Double.random(in: 0...0.00705), longitude: userLocation.coordinate.longitude + Double.random(in: 0...0.00705))
            }
            else if(trigger >= 0.25 && trigger <= 0.5) {
                monsterLocation = CLLocation(latitude: userLocation.coordinate.latitude - Double.random(in: 0...0.00705), longitude: userLocation.coordinate.longitude - Double.random(in: 0...0.00705))
            }
            else if (trigger >= 0.5 && trigger <= 0.75) {
                monsterLocation = CLLocation(latitude: userLocation.coordinate.latitude - Double.random(in: 0...0.00705), longitude: userLocation.coordinate.longitude + Double.random(in: 0...0.00705))
            }
            else {
                monsterLocation = CLLocation(latitude: userLocation.coordinate.latitude + Double.random(in: 0...0.00705), longitude: userLocation.coordinate.longitude - Double.random(in: 0...0.00705))
            }
            //print("coordinate \(monsterLocation.coordinate.longitude) ")
            monstersAnnotation.append(MonsterAnnotation(
                monster: monsters[index],
                coordinate: monsterLocation))
        }
        
        return monstersAnnotation
    }
    
    // Этот метод убирает монстра с вероятностью 0.2 и добавляет 6 случайных монстров
    @objc func monsterChange() {
        var monsters = monstersAnnotationList
        monsters = monsters.filter { element in
            if (Float.random(in: 0...1) >= 0.2) {
                //print("yes")
                return true
            }
            else {
                //print("no")
                return false
            }
        }
        let newMonsters = monsterListGenerate(countOfMonsters: 6, userLocation: userLocation)
        monstersAnnotationList = monsters + newMonsters
        setMonstersToMap()
    }
}

