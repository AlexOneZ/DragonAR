//
//  Monsters.swift
//  DragonsAR
//
//  Created by Алексей Кобяков on 13.01.2023.
//

import MapKit

struct Monster {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

struct MonsterAnnotation {
    let monster: Monster
    let coordinate: CLLocation
    
    init(monster: Monster, coordinate: CLLocation) {
        self.monster = monster
        self.coordinate = coordinate
    }
}

struct AllMonsters {
    let monsters: [Monster] = [
        Monster(name: ConstantMonstersName.dinoName),
        Monster(name: ConstantMonstersName.tinaName),
        Monster(name: ConstantMonstersName.dragoName),
        Monster(name: ConstantMonstersName.grayName),
        Monster(name: ConstantMonstersName.grizlName),
        Monster(name: ConstantMonstersName.grizlforceName),
        Monster(name: ConstantMonstersName.hipeName),
        Monster(name: ConstantMonstersName.morderName),
        Monster(name: ConstantMonstersName.rexName),
        Monster(name: ConstantMonstersName.serpName),
        Monster(name: ConstantMonstersName.sleptName),
    ]
}
