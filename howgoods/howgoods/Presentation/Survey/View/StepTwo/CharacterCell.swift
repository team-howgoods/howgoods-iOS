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
    
    private let imageView = ImageView(cornerRadius: 8)
    
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
        didSet { configureUI() }
    }

    override var isSelected: Bool {
        didSet { updateSelectionUI() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()  // UI 세팅
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.prepareForReuse()                 // Kingfisher 취소 + 이미지 초기화
        characterNameLabel.text = nil
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
    }

    // 외부에서 character 주입용
    func configure(character: Character) { self.character = character }
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
            imageView,
            characterNameLabel
        )
    }
    
    func setStyles() {
        backgroundColor = .clear
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
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

        imageView.layoutIfNeeded()

        imageView.setImage(urlOrName: character.imageUrl)

        updateSelectionUI()
    }

    func updateSelectionUI() {
        layer.borderWidth = isSelected ? 5 : 0
        layer.borderColor = isSelected ? UIColor.primary.cgColor : UIColor.clear.cgColor
        layer.cornerRadius = 8
    }
}
