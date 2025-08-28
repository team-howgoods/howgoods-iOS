//
//  SurveyStepThreeView.swift
//  howgoods
//
//  Created by 양원식 on 8/28/25.
//

import UIKit
import Combine

final class SurveyStepThreeView: UIView {

    // MARK: - UI
    private let navigationBar: CustomNavigationBar = {
        let v = CustomNavigationBar()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let requiredLabel: UILabel = {
        let label = UILabel()
        label.setText("필수 선택", style: .captionSemibold12, color: .primary)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let headTitle: UILabel = {
        let label = UILabel()
        label.setText("거의 다 왔어요!\n소장하고 싶은 굿즈 형태를 골라주세요", style: .headlineSemibold, color: .textDefault)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let nextButton: SolidButton = {
        let button = SolidButton(frame: .zero, title: "다음", color: .primary)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityLabel = "다음"
        button.isEnabled = true
        return button
    }()

    // 세로 스크롤 그리드
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] _, _ in
            return self?.createGoodsTypeSection()
        }
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.alwaysBounceVertical = true       // 세로 스크롤
        cv.showsVerticalScrollIndicator = true
        cv.register(SelectAllCell.self, forCellWithReuseIdentifier: SelectAllCell.identifier)
        cv.register(GoodsTypeCell.self, forCellWithReuseIdentifier: GoodsTypeCell.identifier)
        cv.allowsMultipleSelection = true
        return cv
    }()

    // MARK: - Publishers
    var nextButtonPublisher: AnyPublisher<Void, Never> {
        nextButton.publisher(for: .touchUpInside).eraseToAnyPublisher()
    }
    var getNavigationBar: CustomNavigationBar { navigationBar }
    var getCollectionView: UICollectionView { collectionView }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    // MARK: - 레이아웃: 세로 그리드(3열), 가로 스크롤 없음
    func createGoodsTypeSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .absolute(108),
                              heightDimension: .absolute(108))
        )
        // 필요시 인셋 유지
        item.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(108)
        )

        // iOS16+는 repeatingSubitem 사용, 그 이하는 기존 API
        let group: NSCollectionLayoutGroup
        if #available(iOS 16.0, *) {
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                repeatingSubitem: item,
                count: 3
            )
        } else {
            group = NSCollectionLayoutGroup.horizontal(
                layoutSize: groupSize,
                subitem: item,
                count: 3
            )
        }
        group.interItemSpacing = .fixed(8)

        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .none
        section.interGroupSpacing = 28
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        return section
    }

}

private extension SurveyStepThreeView {
    func configure() {
        backgroundColor = .white
        addSubviews(navigationBar, requiredLabel, headTitle, collectionView, nextButton)

        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: trailingAnchor),

            requiredLabel.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 16),
            requiredLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),

            headTitle.topAnchor.constraint(equalTo: requiredLabel.bottomAnchor, constant: 16),
            headTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            headTitle.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),

            collectionView.topAnchor.constraint(equalTo: headTitle.bottomAnchor, constant: 50),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -16),

            nextButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            nextButton.heightAnchor.constraint(equalToConstant: 52),
            nextButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -11),
        ])
    }
}
