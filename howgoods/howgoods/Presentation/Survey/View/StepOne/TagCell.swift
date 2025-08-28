//
//  TagCell.swift
//  howgoods
//
//  Created by 양원식 on 8/22/25.
//
import UIKit

final class TagCell: UICollectionViewCell {
    static let identifier = "TagCell"
    
    // MARK: - UI Components
    private let iconView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "plus")
        image.tintColor = .gray
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setText("", style: .label1Semibold20, color: .textDefault)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.setContentHuggingPriority(.defaultLow, for: .horizontal)   // 넓게 늘어날 수 있게
        label.setContentCompressionResistancePriority(.required, for: .horizontal) // 잘리지는 않게
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 4
        stack.alignment = .center
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.frame.height / 2
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    // MARK: - Public Methods
    func configure(title: String, isSelected: Bool) {
        titleLabel.setText(title, style: .label1Semibold20, color: .textDefault)
        applySelectionStyle(isSelected: isSelected)
    }
}

// MARK: - Private Methods
private extension TagCell {
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
    }
    
    func setHierarchy() {
        contentView.addSubview(hStack)
    }
    
    func setStyles() {
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.gray400.cgColor
        contentView.backgroundColor = .white
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            hStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            hStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            hStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            hStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            iconView.widthAnchor.constraint(equalToConstant: 12),
            iconView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    func applySelectionStyle(isSelected: Bool) {
        if isSelected {
            contentView.layer.borderWidth = 2
            contentView.layer.borderColor = UIColor.primary.cgColor
            iconView.image = UIImage(systemName: "minus")
            iconView.tintColor = .primary
        } else {
            contentView.layer.borderWidth = 1
            contentView.layer.borderColor = UIColor.gray400.cgColor
            iconView.image = UIImage(systemName: "plus")
            iconView.tintColor = .gray
        }
    }
}
