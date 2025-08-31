//
//  GoodsTypeCell.swift
//  howgoods
//
//  Created by 양원식 on 8/28/25.
//

// GoodsTypeCell.swift
import UIKit

final class GoodsTypeCell: UICollectionViewCell {
    static let identifier = "GoodsTypeCell"

    private let imageView = ImageView(cornerRadius: 8)

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.setText("", style: .captionSemibold12, color: .white)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var goodsType: GoodsType? {
        didSet { configureUI() }
    }

    override var isSelected: Bool {
        didSet { updateSelectionUI() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.prepareForReuse()
        nameLabel.text = nil
        layer.borderWidth = 0
        layer.borderColor = UIColor.clear.cgColor
    }

    func configure(goodsType: GoodsType) { self.goodsType = goodsType }
}

private extension GoodsTypeCell {
    func configure() {
        contentView.addSubviews(imageView, nameLabel)
        backgroundColor = .clear
        layer.cornerRadius = 8
        layer.masksToBounds = true

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),

            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    func configureUI() {
        guard let goodsType = goodsType else { return }
        nameLabel.setText(goodsType.name, style: .captionSemibold12, color: .white)
        imageView.setImage(urlOrName: goodsType.imageUrl)
        updateSelectionUI()
    }

    func updateSelectionUI() {
        layer.borderWidth = isSelected ? 5 : 0
        layer.borderColor = isSelected ? UIColor.primary.cgColor : UIColor.clear.cgColor
        layer.cornerRadius = 8
    }
}
