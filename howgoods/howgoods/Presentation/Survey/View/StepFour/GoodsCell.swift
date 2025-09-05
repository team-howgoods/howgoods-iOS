//
//  GoodsCell.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//

import UIKit

final class GoodsCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "GoodsCell"
    
    // MARK: - UI Components
    private var imageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let badgeLabel: UILabel = {
        let label = UILabel()
        label.setText("1", style: .body1Semibold, color: .white)
        label.backgroundColor = .primary
        label.textAlignment = .center
        label.layer.cornerRadius = 4
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true // 기본은 숨김
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
    }
    
    override var isSelected: Bool {
        didSet {
            badgeLabel.isHidden = !isSelected
        }
    }
    
    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: - Public Methods
    func configure(with goods: GoodsItem) {
        imageView.kf.setImage(with: URL(string: goods.imageUrl))
        nameLabel.setText(goods.name, style: .label1Medium22, color: .textDefault)
    }
    
    func updateSelectionOrder(_ order: Int?) {
        if let order = order {
            badgeLabel.setText("\(order)", style: .body1Semibold, color: .white)
            badgeLabel.isHidden = false
            imageView.layer.borderWidth = 5
            imageView.layer.borderColor = UIColor.primary.cgColor
        } else {
            badgeLabel.isHidden = true
            imageView.layer.borderWidth = 0
        }
    }
}

private extension GoodsCell {
    // MARK: - configure
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
        setBindings()
    }
    
    // MARK: - setHierarchy
    func setHierarchy() {
        contentView.addSubviews(
            imageView,
            nameLabel,
            badgeLabel
        )
    }
    
    // MARK: - setStyles
    func setStyles() {
        backgroundColor = .white
    }
    
    // MARK: - setConstraints
    func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            badgeLabel.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 12),
            badgeLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 12),
            badgeLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 26),
            badgeLabel.heightAnchor.constraint(equalToConstant: 26),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ])
        
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
    }
    
    // MARK: - setBindings
    func setBindings() {
        
    }
}


