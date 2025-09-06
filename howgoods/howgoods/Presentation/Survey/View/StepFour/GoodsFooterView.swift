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

    // 푸터 재사용 시 구독 누적 방지
    var reuseBag = Set<AnyCancellable>()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reuseBag.removeAll()  // 재사용시 구독 초기화
    }

    // MARK: - UI
    private let moreButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "chevronDown") // 기본 이미지 설정
        config.baseForegroundColor = .textDefault
        config.imagePadding = 4  // 이미지와 텍스트 간격 설정
        config.titlePadding = 4  // 텍스트와 이미지 간격 설정
        
        let button = UIButton(configuration: config, primaryAction: nil)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.semanticContentAttribute = .forceRightToLeft // 아이콘을 오른쪽으로
        return button
    }()

    // MARK: - Publisher
    var moreButtonPublisher: AnyPublisher<Void, Never> {
        moreButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - Public
    /// total: 섹션 총 아이템 수, visibleCount: 현재 스냅샷에서 표시 중인 개수
    func configure(total: Int, visibleCount: Int) {
        guard total > 4 else {
            isHidden = true
            return
        }
        isHidden = false

        let isExpanded = visibleCount >= total
        update(isExpanded: isExpanded)
    }

    func update(isExpanded: Bool) {
        if isExpanded {
            moreButton.setText("닫기", style: .body1Semibold, color: .textAlternative)
            moreButton.setImage(UIImage(named: "chevronUp"), for: .normal)
        } else {
            moreButton.setText("더보기", style: .body1Semibold, color: .textAlternative)
            moreButton.setImage(UIImage(named: "chevronDown"), for: .normal)
        }
    }
}

// MARK: - Private
private extension GoodsFooterView {
    func configure() {
        addSubview(moreButton)
        backgroundColor = .white
        NSLayoutConstraint.activate([
            moreButton.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            moreButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            moreButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            moreButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

