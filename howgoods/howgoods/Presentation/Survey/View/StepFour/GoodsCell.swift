//
//  GoodsCell.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//

import UIKit
import Kingfisher
import Combine

final class GoodsCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "GoodsCell"
    
    // MARK: - UI Components
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 16
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
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
        label.isHidden = true
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()

    // MARK: - State
    private var cancellables = Set<AnyCancellable>()
    private var currentId: Int?

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        nameLabel.text = nil
        updateSelectionOrder(nil)
    }
    
    @available(*, unavailable, message: "storyboard is not supported.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: - Public Methods
    func configure(with goods: GoodsItem, order: Int? = nil) {
        currentId = goods.id
        imageView.kf.setImage(with: URL(string: goods.imageUrl))
        nameLabel.setText(goods.name, style: .label1Medium22, color: .textDefault)
        updateSelectionOrder(order)
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

// MARK: - Configure
private extension GoodsCell {
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
    }
    
    func setHierarchy() {
        contentView.addSubviews(
            imageView,
            nameLabel,
            badgeLabel
        )
    }
    
    func setStyles() {
        backgroundColor = .white
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -48),
            
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
}
