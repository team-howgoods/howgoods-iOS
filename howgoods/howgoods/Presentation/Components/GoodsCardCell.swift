//
//  GoodsCardCell.swift
//  howgoods
//
//  Created by 양원식 on 9/11/25.
//

import UIKit
import Combine

final class GoodsCardCell: UICollectionViewCell {
    static let identifier = "GoodsCardCell"
    var reuseBag = Set<AnyCancellable>()
    
    private var goods: [GoodsItem] = []
    private var expandedCount: Int = 4
    private var goodsHeightConstraint: NSLayoutConstraint!
    private var animationName: String?
    private var orderProvider: ((GoodsItem) -> Int?)?
    
    // MARK: - UI
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.setText("", style: .headlineMedium, color: .textDefault)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var goodsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.isScrollEnabled = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(GoodsCell.self, forCellWithReuseIdentifier: GoodsCell.identifier)
        return cv
    }()
    
    private let moreButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "chevronDown")
        config.baseForegroundColor = .textAlternative
        config.imagePadding = 4
        config.titlePadding = 4
        let btn = UIButton(configuration: config)
        btn.setText("더보기", style: .body1Semibold, color: .textAlternative)
        btn.semanticContentAttribute = .forceRightToLeft
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Publishers
    var moreButtonPublisher: AnyPublisher<String, Never> {
        moreButton.publisher(for: .touchUpInside)
            .compactMap { [weak self] _ in
                guard let self else { return nil }
                let total = goods.count
                let isExpanded = expandedCount >= total
                update(isExpanded: !isExpanded)
                return animationName
            }
            .eraseToAnyPublisher()
    }
    
    private let didSelectGoodsSubject = PassthroughSubject<GoodsItem, Never>()
    var didSelectGoodsPublisher: AnyPublisher<GoodsItem, Never> {
        didSelectGoodsSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) { fatalError() }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reuseBag.removeAll()
        goods = []
        animationName = nil
        orderProvider = nil
    }
    
    // MARK: - Public
    func configure(animationName: String,
                   goods: [GoodsItem],
                   expandedCount: Int,
                   orderProvider: ((GoodsItem) -> Int?)? = nil) {
        self.animationName = animationName
        self.goods = goods
        self.expandedCount = expandedCount
        self.orderProvider = orderProvider
        titleLabel.setText(animationName, style: .headlineMedium, color: .textDefault)
        goodsCollectionView.reloadData()
        
        moreButton.isHidden = goods.count <= 4
        update(isExpanded: expandedCount >= goods.count)
    }
    
    /// 셀이 자신의 높이를 계산하도록 오버라이드
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        setNeedsLayout()
        layoutIfNeeded()
        
        goodsHeightConstraint.constant = goodsCollectionView.collectionViewLayout.collectionViewContentSize.height
        
        let size = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        var newFrame = layoutAttributes.frame
        newFrame.size.height = size.height
        layoutAttributes.frame = newFrame
        return layoutAttributes
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
    
    func updateGoods(_ item: GoodsItem, order: Int?) {
        guard let index = goods.firstIndex(where: { $0.id == item.id }) else { return }
        let indexPath = IndexPath(item: index, section: 0)
        if let targetCell = goodsCollectionView.cellForItem(at: indexPath) as? GoodsCell {
            targetCell.configure(with: item, order: order)
        } else {
            goodsCollectionView.reloadItems(at: [indexPath])
        }
    }
}


// MARK: - Private
private extension GoodsCardCell {
    func configure() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        setHierarchy()
        setConstraints()
        goodsCollectionView.dataSource = self
        goodsCollectionView.delegate = self
    }
    
    func setHierarchy() {
        contentView.addSubviews(titleLabel, goodsCollectionView, moreButton)
    }
    
    func setConstraints() {
        goodsHeightConstraint = goodsCollectionView.heightAnchor.constraint(equalToConstant: 0)
        goodsHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            goodsCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            goodsCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            goodsCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            moreButton.topAnchor.constraint(equalTo: goodsCollectionView.bottomAnchor, constant: 8),
            moreButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            moreButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
}

// MARK: - CollectionView
extension GoodsCardCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(expandedCount, goods.count)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GoodsCell.identifier, for: indexPath
        ) as! GoodsCell
        let item = goods[indexPath.item]
        let order = orderProvider?(item)
        cell.configure(with: item, order: order)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectGoodsSubject.send(goods[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let interItemSpacing: CGFloat = 8
        let itemsPerRow: CGFloat = 2
        let availableWidth = collectionView.bounds.width - (itemsPerRow - 1) * interItemSpacing
        let itemWidth = availableWidth / itemsPerRow
        return CGSize(width: itemWidth, height: itemWidth + 48)
    }
}
