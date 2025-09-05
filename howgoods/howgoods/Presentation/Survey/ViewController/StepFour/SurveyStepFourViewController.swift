//
//  SurveyStepFourViewController.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//
import UIKit
import Combine

final class SurveyStepFourViewController: UIViewController {
    
    // MARK: - Properties
    private var collectionView: UICollectionView { surveyStepFourView.getCollectionView }
    private let surveyStepFourView = SurveyStepFourView()
    private let viewModel: SurveyViewModel
    private var cancellables = Set<AnyCancellable>()
    
    /// 애니메이션 단위로 그룹핑된 굿즈
    private var groupedGoods: [(animationName: String, items: [GoodsItem])] = []
    /// 섹션별 확장 상태 (몇 개를 보여줄지)
    private var expandedSections: [Int: Int] = [:]
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = surveyStepFourView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Initializer
    init(viewModel: SurveyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable, message: "compile error")
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    var didTapSearch: (() -> Void)?
}

// MARK: - UI Methods
private extension SurveyStepFourViewController {
    func configure() {
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.register(
            GoodsSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: GoodsSectionHeader.identifier
        )
        collectionView.register(
            GoodsFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: GoodsFooterView.identifier
        )
        
        setHierarchy()
        setStyles()
        setConstraints()
        setActions()
        setBinding()
    }
    
    func setHierarchy() { }
    
    func setStyles() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func setConstraints() { }
    
    func setActions() {
        surveyStepFourView.searchBarTapPublisher
            .sink { [weak self] in
                self?.didTapSearch?()
            }
            .store(in: &cancellables)
        
        surveyStepFourView.getNavigationBar.backButtonPublisher
            .sink { [weak self] in
                self?.viewModel.reset(step: .character)
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
    
    func setBinding() {
        // 굿즈 리스트 바인딩
        viewModel.goods
            .receive(on: RunLoop.main)
            .sink { [weak self] list in
                guard let self else { return }
                self.bindGoods(list)
            }
            .store(in: &cancellables)
        
        // 선택 상태 바인딩 → 셀 업데이트
        viewModel.selectedGoods
            .receive(on: RunLoop.main)
            .sink { [weak self] selectedIds in
                guard let self else { return }
                for (sectionIdx, group) in groupedGoods.enumerated() {
                    for (rowIdx, item) in group.items.enumerated() {
                        let indexPath = IndexPath(item: rowIdx, section: sectionIdx)
                        if let cell = collectionView.cellForItem(at: indexPath) as? GoodsCell {
                            if let order = selectedIds.firstIndex(of: item.id) {
                                cell.updateSelectionOrder(order + 1)
                            } else {
                                cell.updateSelectionOrder(nil)
                            }
                        }
                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func bindGoods(_ list: [GoodsItem]) {
        let grouped = Dictionary(grouping: list, by: { $0.animationName })
        groupedGoods = grouped.map { (key, value) in
            (animationName: key, items: value)
        }
        groupedGoods.sort { $0.animationName < $1.animationName }
        
        // 각 섹션별 초기값 세팅
        expandedSections = [:]
        for (i, group) in groupedGoods.enumerated() {
            expandedSections[i] = min(4, group.items.count)
        }
        
        collectionView.reloadData()
    }

    
    func toggleSection(_ section: Int) {
        let total = groupedGoods[section].items.count
        let current = expandedSections[section] ?? min(4, total)
        
        if current >= total {
            expandedSections[section] = min(4, total)
        } else {
            expandedSections[section] = min(current + 6, total)
        }
        
        collectionView.reloadSections(IndexSet(integer: section))
    }
}

// MARK: - DataSource & Delegate
extension SurveyStepFourViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        groupedGoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let total = groupedGoods[section].items.count
        return expandedSections[section] ?? min(4, total)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GoodsCell.identifier, for: indexPath) as! GoodsCell
        let item = groupedGoods[indexPath.section].items[indexPath.item]
        cell.configure(with: item)
        
        let selectedIds = viewModel.requestDTO.goodsSurveyResults.map { $0.goodsId }
        if let order = selectedIds.firstIndex(of: item.id) {
            cell.updateSelectionOrder(order + 1)
        } else {
            cell.updateSelectionOrder(nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = groupedGoods[indexPath.section].items[indexPath.item].id
        viewModel.select(step: .goods, id: id)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let id = groupedGoods[indexPath.section].items[indexPath.item].id
        viewModel.deselect(step: .goods, id: id)
    }
    
    // 헤더 & 푸터
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: GoodsSectionHeader.identifier,
                for: indexPath
            ) as! GoodsSectionHeader
            header.configure(title: groupedGoods[indexPath.section].animationName)
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: GoodsFooterView.identifier,
                for: indexPath
            ) as! GoodsFooterView
            
            let total = groupedGoods[indexPath.section].items.count
            // 4개 이하라면 숨기기
            if total <= 4 {
                footer.isHidden = true
                return footer
            }
            footer.isHidden = false
            let current = expandedSections[indexPath.section] ?? min(4, total)
            let isExpanded = current >= total
            footer.update(isExpanded: isExpanded)
            
            footer.moreButtonPublisher
                .sink { [weak self] in
                    self?.toggleSection(indexPath.section)
                }
                .store(in: &cancellables)
            
            return footer
        }
    }

}

// MARK: - FlowLayout
extension SurveyStepFourViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let interItemSpacing: CGFloat = 8
        let itemsPerRow: CGFloat = 2
        
        let totalSpacing = (itemsPerRow - 1) * interItemSpacing
        let availableWidth = collectionView.bounds.width - totalSpacing
        let itemWidth = availableWidth / itemsPerRow
        
        return CGSize(width: itemWidth, height: itemWidth + 48)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForHeaderInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 44)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        referenceSizeForFooterInSection section: Int
    ) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 8
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 12
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAt section: Int
    ) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

