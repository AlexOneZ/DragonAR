//
//  MyTeamViewController.swift
//  DragonsAR
//
//  Created by Алексей Кобяков on 17.01.2023.
//

import UIKit

class MyTeamViewController: UIViewController {
    
    let tableViewID = "myTeam"
    var monsters: [MonsterCellViewModel] = []
    let defaults = UserDefaults.standard
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = UIColor.clear
        tableView.rowHeight = 200
        tableView.separatorColor = .white
        tableView.allowsSelection = false
        return tableView
    }()
    
    lazy var backgroundImage: UIImageView = {
        let image = UIImage(named: "Background_3")
        let bgView = UIImageView(image: image)
        bgView.translatesAutoresizingMaskIntoConstraints = false
        bgView.contentMode = .scaleToFill
        return bgView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        let icon = UIImage(named: "back")
        button.setImage(icon!, for: .normal)
        
        //make circle
        button.widthAnchor.constraint(equalToConstant: 55).isActive = true
        button.heightAnchor.constraint(equalToConstant: 55).isActive = true
        button.layer.cornerRadius = 25
        button.clipsToBounds = true
        
        button.addTarget(self, action: #selector(openMap), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        label.textColor = .systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        
        label.widthAnchor.constraint(equalToConstant: 150).isActive = true
        label.heightAnchor.constraint(equalToConstant: 55).isActive = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(MonsterCell.self, forCellReuseIdentifier: tableViewID)
        tableView.dataSource = self
        
        view.addSubview(tableView)
        view.addSubview(backgroundImage)
        view.addSubview(backButton)
        view.addSubview(titleLabel)
        titleLabel.text = "Моя команда"
        view.bringSubviewToFront(tableView)
        SetupConstraints()
        
        readSaveData()
    }
    
    private func readSaveData() {
        let defaults = UserDefaults.standard
        let names: [String] = defaults.stringArray(forKey: SaveKey.saveKeyName) ?? []
        let levels: [Int] = defaults.array(forKey: SaveKey.saveKeyLevel) as? [Int] ?? []
        if (names.count > 0) {
            for index in 0...(names.count - 1) {
                monsters.append(MonsterCellViewModel(
                    name: names[index],
                    level: levels[index]))
            }
        }
        
        print("Monster \(monsters.count)")
        tableView.reloadData()
    }
    
    @objc private func openMap() {
        dismiss(animated: true)
    }
    
    private func SetupConstraints() {
        //For background
        backgroundImage.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        backgroundImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor, constant: -10).isActive = true
        backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: -15).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 35).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        //
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent // .default
    }
}

extension MyTeamViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return monsters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewID, for: indexPath) as? MonsterCell
        
        let viewModel = monsters[indexPath.row]
        cell?.configure(viewModel)
        cell?.backgroundColor = UIColor.clear

        return cell ?? UITableViewCell()
    }
    
}
