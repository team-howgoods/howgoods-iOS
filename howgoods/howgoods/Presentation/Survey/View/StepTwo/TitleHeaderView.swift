//
//  TitleHeaderView.swift
//  howgoods
//
//  Created by 양원식 on 8/23/25.
//

import UIKit

class TitleHeaderView: UICollectionReusableView {
    static let identifier = "TitleHeaderView"

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setText("", style: .body1Semibold, color: .textDefault)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateTitle(title: String) {
        titleLabel.setText(title, style: .body1Semibold, color: .textDefault)
    }
}
