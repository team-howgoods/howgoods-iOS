//
//  SelectedGoodsCell.swift
//  howgoods
//
//  Created by 양원식 on 9/6/25.
//

import UIKit
import Combine

final class SelectedGoodsCell: UICollectionViewCell {
    // MARK: - Properties
    static let identifier = "SelectedGoodsCell"

    private var id: Int?

    /// 외부에서 구독할 퍼블리셔

    // MARK: - UI Components
    private let imageView = ImageView(cornerRadius: 8)

    private let goodsNameLabel: UILabel = {
        let label = UILabel()
        label.setText("", style: .captionSemibold11, color: .white)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let removeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: "xmark.circle.fill")
        config.baseForegroundColor = .iconDark

        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Public Methods
    func configure(with item: GoodsItem) {
        id = item.id
        goodsNameLabel.setText(item.name, style: .captionSemibold11, color: .white)
        imageView.setImage(urlOrName: item.imageUrl)
    }
}

// MARK: - Configure Methods
private extension SelectedGoodsCell {
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
        setBindings()
    }

    func setHierarchy() {
        contentView.addSubviews(
            imageView,
            goodsNameLabel,
            removeButton
        )
        contentView.bringSubviewToFront(removeButton)
    }

    func setStyles() {
        backgroundColor = .clear
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            goodsNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            goodsNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            goodsNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),

            removeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            removeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            removeButton.widthAnchor.constraint(equalToConstant: 20),
            removeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func setBindings() {
    }
}
