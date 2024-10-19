//
//  MonsterCell.swift
//  DragonsAR
//
//  Created by Алексей Кобяков on 17.01.2023.
//

import UIKit

struct MonsterCellViewModel: Codable {
    let name: String
    let level: Int
}

class MonsterCell: UITableViewCell {
    private lazy var monsterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textAlignment = .left
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var levelLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 50
        
        stackView.addArrangedSubview(monsterImage)
        stackView.addArrangedSubview(nameLabel)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        //contentView.addSubview(stackView)
        contentView.addSubview(monsterImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(levelLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ viewModel: MonsterCellViewModel) {
        monsterImage.image = UIImage(named: viewModel.name)
        nameLabel.text = String(viewModel.name)
        levelLabel.text = "Уровень: \(viewModel.level)"
    }
    
    private func setupConstraints() {
//        stackView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
//        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 10).isActive = true
//
//        stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
//        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        monsterImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        monsterImage.heightAnchor.constraint(equalToConstant: 150).isActive = true
        monsterImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        monsterImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
        
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: monsterImage.rightAnchor, constant: 15).isActive = true
        nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        
        levelLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        levelLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        levelLabel.leftAnchor.constraint(equalTo: monsterImage.rightAnchor, constant: 15).isActive = true
        levelLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 30).isActive = true
        
    }
}
