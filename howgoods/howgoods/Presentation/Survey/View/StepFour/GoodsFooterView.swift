//
//  GoodsFooterView.swift
//  howgoods
//
//  Created by 양원식 on 9/5/25.
//

import UIKit
import Combine

final class GoodsFooterView: UICollectionReusableView {
    static let identifier = "GoodsFooterView"
    
    // MARK: - UI Components
    private let moreButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.layer.cornerRadius = 8
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.systemGray4.cgColor
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.semanticContentAttribute = .forceRightToLeft // 아이콘을 오른쪽으로
        btn.tintColor = .textDefault
        return btn
    }()
    
    // MARK: - Public Publisher
    var moreButtonPublisher: AnyPublisher<Void, Never> {
        moreButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    
    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    func update(isExpanded: Bool) {
        if isExpanded {
            moreButton.setText("닫기", style: .body1Semibold, color: .textAlternative)
            moreButton.tintColor = .lineDefault
            moreButton.setImage(UIImage(named: "chevronUp"), for: .normal)
        } else {
            moreButton.setText("더보기", style: .body1Semibold, color: .textAlternative)
            moreButton.tintColor = .lineDefault
            moreButton.setImage(UIImage(named: "chevronDown"), for: .normal)
        }
    }
}

// MARK: - Private Methods
private extension GoodsFooterView {
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
    }
    
    func setHierarchy() {
        addSubviews(moreButton)
    }
    
    func setStyles() {
        backgroundColor = .white
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            moreButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            moreButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            moreButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
