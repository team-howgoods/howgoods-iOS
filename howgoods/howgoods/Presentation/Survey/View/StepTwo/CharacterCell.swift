//
//  CharacterCell.swift
//  howgoods
//
//  Created by 양원식 on 8/23/25.
//

import UIKit
import Kingfisher

final class CharacterCell: UICollectionViewCell {
    static let identifier = "CharacterCell"
    
    private let characterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill // 이미지 크기를 맞추기 위해 설정
        return imageView
    }()
    
    private let shadowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = false // 그림자가 잘리지 않도록 설정
        imageView.contentMode = .scaleAspectFill // 그림자 이미지도 크기에 맞게 조정
        return imageView
    }()
    
    private let characterNameLabel: UILabel = {
        let label = UILabel()
        label.setText("", style: .label1Semibold20, color: .white)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var character: Character? {
        didSet {
            configureUI()
        }
    }

    override var isSelected: Bool {
        didSet {
            // 선택 시 테두리 스타일 변경
            layer.borderWidth = isSelected ? 5 : 0
            layer.borderColor = isSelected ? UIColor.primary.cgColor : UIColor.clear.cgColor
            layer.cornerRadius = 8 // 이미지와 동일한 cornerRadius를 적용
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()  // configure()를 사용하여 UI 세팅
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 이미지와 그림자 크기 맞추기
        shadowImageView.frame = contentView.bounds
    }

    func configure(character: Character) {
        self.character = character
    }
}

// MARK: - Configure Methods
private extension CharacterCell {
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
    }

    func setHierarchy() {
        contentView.addSubviews(
            characterImageView,
            shadowImageView,
            characterNameLabel
        )
    }
    
    func setStyles() {
        backgroundColor = .clear
        layer.cornerRadius = 8  // 셀에 cornerRadius 적용
        layer.masksToBounds = true  // 테두리 적용 시 셀의 모양이 유지됨
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            characterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            characterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            characterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            characterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            shadowImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shadowImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shadowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            shadowImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            characterNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            characterNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            characterNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}

// MARK: - UI Configuration Methods
private extension CharacterCell {
    func configureUI() {
        guard let character = character else { return }
        
        characterNameLabel.setText(character.name, style: .label1Semibold20, color: .white)
        
        // 이미지 로딩
        if let url = URL(string: character.imageUrl) {
            let placeholderImage = UIImage(named: "Sample")
            characterImageView.kf.setImage(with: url, placeholder: placeholderImage)
        } else {
            characterImageView.image = UIImage(named: "Sample")
        }
        
        // 그림자 이미지 설정
        if let shadowImage = UIImage(named: "shadow") {
            shadowImageView.image = shadowImage
        }
    }
}
