//
//  SelectAllCell.swift
//  howgoods
//
//  Created by 양원식 on 8/28/25.
//

// SelectAllCell.swift
import UIKit

final class SelectAllCell: UICollectionViewCell {
    static let identifier = "SelectAllCell"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setText("전체 선택", style: .body1Semibold, color: .white)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    override var isSelected: Bool {
        didSet { updateSelectionUI() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func configure() {
        contentView.addSubview(titleLabel)
        backgroundColor = .primary   // 초록 배경
        layer.cornerRadius = 16
        layer.masksToBounds = true

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        updateSelectionUI()
    }

    private func updateSelectionUI() {
        // TODO: 초록 배경이라 테두리는 흰색으로 추후 변경
        layer.borderWidth  = isSelected ? 5 : 0
        layer.borderColor  = isSelected ? UIColor.white.cgColor : UIColor.clear.cgColor
        layer.cornerRadius = 16
    }
}
