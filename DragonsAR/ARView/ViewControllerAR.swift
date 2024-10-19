//
//  ViewControllerAR.swift
//  DragonsAR
//
//  Created by Алексей Кобяков on 16.01.2023.
//

import UIKit
import ARKit

class ViewControllerAR: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    var monsterName: String?
    var monsterLevel: Int = 0
    let configuration = ARWorldTrackingConfiguration()
    
    var monsterNode = SCNNode()
    var titleMonsterTextNode = SCNNode()
    var levelMonsterTextNode = SCNNode()
    var planeMonsterInfoNode = SCNNode()
    
    var catchPlaneNode = SCNNode()
    var titleCatchTextNode = SCNNode()
    var messageCatchTextNode = SCNNode()
    
    private lazy var catchButton: UIButton = {
        let button = UIButton(type: .custom)
        
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        button.backgroundColor = color
        button.setTitle("Попробовать поймать", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.widthAnchor.constraint(equalToConstant: 270).isActive = true
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.layer.cornerRadius = 15
        
        button.addTarget(self, action: #selector(tryCatchMonter), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("VDL AR")
        monsterLevel = Int.random(in: 5...20)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(showPreviousScreen))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        view.addSubview(catchButton)
        view.bringSubviewToFront(catchButton)
        setupConstraints()
        
        //self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        
        self.sceneView.session.run(configuration)
        
        let image = UIImage(named: monsterName ?? ConstantMonstersName.dinoName)
        monsterNode.geometry = SCNPlane(width: 0.37, height: 0.45)
        
        monsterNode.geometry?.firstMaterial?.diffuse.contents = image
        monsterNode.geometry?.firstMaterial?.isDoubleSided = true
        monsterNode.position = SCNVector3(0, 0, -1.25)
        
        
        let plane = SCNPlane(width: 0.2, height: 0.15)
        plane.cornerRadius = 0.05
        plane.firstMaterial?.diffuse.contents = UIColor.black
        
        planeMonsterInfoNode.geometry = plane
        planeMonsterInfoNode.opacity = 0.7
        planeMonsterInfoNode.position = SCNVector3(0.1, 0.25, -1.25)
        //labelNode.position = SCNVector3(0, 0.5, 0)
 
        let title = "\(monsterName ?? "Name")"
        let level = "Уровень: \(monsterLevel)"
        
        
        let titleText = SCNText(string: title, extrusionDepth: 0.0)
        titleText.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.white
        titleText.materials = [material]
        
        titleMonsterTextNode.position = SCNVector3(x: 0.05, y:0.25, z:-1.249)
        titleMonsterTextNode.scale = SCNVector3(x:0.004, y:0.004, z:0.004)
        titleMonsterTextNode.geometry = titleText
        
        let levelText = SCNText(string: level, extrusionDepth: 0.0)
        levelText.font = UIFont.systemFont(ofSize: 6)
        let material2 = SCNMaterial()
        material2.diffuse.contents = UIColor.white
        levelText.materials = [material2]
        
        levelMonsterTextNode.position = SCNVector3(x: 0.025, y:0.2, z:-1.249)
        levelMonsterTextNode.scale = SCNVector3(x:0.004, y:0.004, z:0.004)
        levelMonsterTextNode.geometry = levelText
        
        self.sceneView.autoenablesDefaultLighting = true
        
        self.sceneView.scene.rootNode.addChildNode(monsterNode)
        self.sceneView.scene.rootNode.addChildNode(planeMonsterInfoNode)
        self.sceneView.scene.rootNode.addChildNode(titleMonsterTextNode)
        self.sceneView.scene.rootNode.addChildNode(levelMonsterTextNode)
        
       // node3.removeFromParentNode()
        self.sceneView.session.run(configuration)

    }
    
    private func setupConstraints() {
        catchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        catchButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35).isActive = true
    }
    
    @objc func tryCatchMonter() {
        let probabilityCatch = Double.random(in: 0...1)
        
        if(probabilityCatch <= 0.2) {
            succesCatch()
        }
        else {
            let probabilityRunAway = Double.random(in: 0...1)
            if(probabilityRunAway <= 0.3) {
                monsterRunAway()
            }
            else {
                notSuccesCatch()
            }
        }
    }
    
    private func succesCatch() {
        let title = "Ура!"
        let message = "Вы поймали монстра \(monsterName ?? "Name") \n в свою команду"
        setMessage(title: title, message: message)
        
        self.sceneView.scene.rootNode.addChildNode(titleCatchTextNode)
        self.sceneView.scene.rootNode.addChildNode(messageCatchTextNode)
        self.sceneView.scene.rootNode.addChildNode(catchPlaneNode)
        
        readAndSave()
        changeButtonAction()
    }
    
    private func monsterRunAway() {
        changeButtonAction()
        let title = "Не вышло :("
        let message = "Монстр убежал"
        setMessage(title: title, message: message)
        
        monsterNode.removeFromParentNode()
        planeMonsterInfoNode.removeFromParentNode()
        titleMonsterTextNode.removeFromParentNode()
        levelMonsterTextNode.removeFromParentNode()
    }
    
    private func notSuccesCatch() {
        let title = "Не вышло :("
        let message = "Попробуйте поймать \nеще раз"
        setMessage(title: title, message: message)
    }
    
    private func setMessage(title: String, message: String) {
        let plane = SCNPlane(width: 0.4, height: 0.2)
        plane.cornerRadius = 0.05
        plane.firstMaterial?.diffuse.contents = UIColor.black
        catchPlaneNode.geometry = plane
        catchPlaneNode.opacity = 0.7
        catchPlaneNode.position = SCNVector3(0, 0.525, -1.25)
        
        let titleText = SCNText(string: title, extrusionDepth: 0.0)
        titleText.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        
        let materialTitle = SCNMaterial()
        materialTitle.diffuse.contents = UIColor.white
        titleText.materials = [materialTitle]
        
        let messageText = SCNText(string: message, extrusionDepth: 0.0)
        messageText.font = UIFont.systemFont(ofSize: 6)
        
        let materialMessage = SCNMaterial()
        materialMessage.diffuse.contents = UIColor.white
        messageText.materials = [materialMessage]
        
        titleCatchTextNode.position = SCNVector3(x: -0.1, y:0.55, z:-1.24999)
        titleCatchTextNode.scale = SCNVector3(x:0.004, y:0.004, z:0.004)
        titleCatchTextNode.geometry = titleText
        
        messageCatchTextNode.position = SCNVector3(x: -0.15, y:0.475, z:-1.24999)
        messageCatchTextNode.scale = SCNVector3(x:0.004, y:0.004, z:0.004)
        messageCatchTextNode.geometry = messageText
        
        self.sceneView.scene.rootNode.addChildNode(titleCatchTextNode)
        self.sceneView.scene.rootNode.addChildNode(messageCatchTextNode)
        self.sceneView.scene.rootNode.addChildNode(catchPlaneNode)
    }
    
    private func changeButtonAction() {
        catchButton.setTitle("Вернуться на карту", for: .normal)
        catchButton.removeTarget(self, action: #selector(tryCatchMonter), for: .touchUpInside)
        catchButton.addTarget(self, action: #selector(showPreviousScreen), for: .touchUpInside)
    }
    
    @objc func showPreviousScreen() {
        self.dismiss(animated: true)
    }

    private func readAndSave() {
        let defaults = UserDefaults.standard
        var names: [String] = defaults.stringArray(forKey: SaveKey.saveKeyName) ?? []
        var levels: [Int] = defaults.array(forKey: SaveKey.saveKeyLevel) as? [Int] ?? []
        names.append(monsterName ?? "Name")
        levels.append(monsterLevel)
        
        defaults.set(names, forKey: SaveKey.saveKeyName)
        defaults.set(levels, forKey: SaveKey.saveKeyLevel)
    }
}
