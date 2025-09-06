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
    
    private var groupedGoods: [(animationName: String, items: [GoodsItem])] = []
    private var expandedSections: [Int: Int] = [:]
    
    private var hasSelection: Bool {
        !viewModel.requestDTO.goodsSurveyResults.isEmpty
    }
    
    // MARK: - Lifecycle
    override func loadView() { self.view = surveyStepFourView }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Initializer
    init(viewModel: SurveyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    var didTapSearch: (() -> Void)?
}

// MARK: - Helpers
private extension SurveyStepFourViewController {
    func adjustedGroupIndex(for section: Int) -> Int {
        return section - (hasSelection ? 1 : 0)
    }
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
        collectionView.register(
            SelectedGoodsCell.self,
            forCellWithReuseIdentifier: SelectedGoodsCell.identifier
        )
        
        setStyles()
        setActions()
        setBinding()
    }
    
    func setStyles() {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func setActions() {
        surveyStepFourView.searchBarTapPublisher
            .sink { [weak self] in self?.didTapSearch?() }
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
            .sink { [weak self] list in self?.bindGoods(list) }
            .store(in: &cancellables)
        
        // 선택 상태 바인딩
        viewModel.selectedGoods
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                guard let self else { return }
                surveyStepFourView.hasSelection = self.hasSelection
                collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    func bindGoods(_ list: [GoodsItem]) {
        groupedGoods = Dictionary(grouping: list, by: { $0.animationName })
            .map { (key, value) in (animationName: key, items: value) }
            .sorted { $0.animationName < $1.animationName }
        
        expandedSections = [:]
        for (i, group) in groupedGoods.enumerated() {
            expandedSections[i] = min(4, group.items.count)
        }
        collectionView.reloadData()
    }
    
    func toggleSection(_ section: Int) {
        let groupIndex = adjustedGroupIndex(for: section)
        let total = groupedGoods[groupIndex].items.count
        let current = expandedSections[groupIndex] ?? min(4, total)
        expandedSections[groupIndex] = current >= total
            ? min(4, total)
            : min(current + 6, total)
        
        collectionView.reloadSections([section])
    }
}

// MARK: - DataSource & Delegate
extension SurveyStepFourViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (hasSelection ? 1 : 0) + groupedGoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if hasSelection && section == 0 {
            return viewModel.requestDTO.goodsSurveyResults.count
        } else {
            let groupIndex = adjustedGroupIndex(for: section)
            let total = groupedGoods[groupIndex].items.count
            return expandedSections[groupIndex] ?? min(4, total)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if hasSelection && indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SelectedGoodsCell.identifier,
                for: indexPath
            ) as! SelectedGoodsCell
            
            let selectedIds = viewModel.requestDTO.goodsSurveyResults.map { $0.goodsId }
            guard indexPath.item < selectedIds.count else { return cell }
            
            let id = selectedIds[indexPath.item]
            if let item = groupedGoods.flatMap({ $0.items }).first(where: { $0.id == id }) {
                cell.configure(with: item)
            }
            
            return cell
        } else {
            let groupIndex = adjustedGroupIndex(for: indexPath.section)
            let item = groupedGoods[groupIndex].items[indexPath.item]
            
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GoodsCell.identifier,
                for: indexPath
            ) as! GoodsCell
            cell.configure(with: item)
            
            let selectedIds = viewModel.requestDTO.goodsSurveyResults.map { $0.goodsId }
            if let order = selectedIds.firstIndex(of: item.id) {
                cell.updateSelectionOrder(order + 1)
            } else {
                cell.updateSelectionOrder(nil)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !(hasSelection && indexPath.section == 0) else { return }
        let groupIndex = adjustedGroupIndex(for: indexPath.section)
        let item = groupedGoods[groupIndex].items[indexPath.item]
        
        let selectedIds = viewModel.requestDTO.goodsSurveyResults.map { $0.goodsId }
        
        if selectedIds.contains(item.id) {
            // 이미 선택됨 → 해제
            viewModel.deselect(step: .goods, id: item.id)
            collectionView.deselectItem(at: indexPath, animated: true)
            
            if let cell = collectionView.cellForItem(at: indexPath) as? GoodsCell {
                cell.updateSelectionOrder(nil)
            }
        } else {
            // 새로 선택됨
            viewModel.select(step: .goods, id: item.id)
            
            if let cell = collectionView.cellForItem(at: indexPath) as? GoodsCell {
                let newSelectedIds = viewModel.requestDTO.goodsSurveyResults.map { $0.goodsId }
                if let order = newSelectedIds.firstIndex(of: item.id) {
                    cell.updateSelectionOrder(order + 1)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        // 선택된 굿즈 섹션(0번)이 있을 때만 헤더/푸터 제거
        if hasSelection && indexPath.section == 0 {
            return UICollectionReusableView()
        }
        
        let groupIndex = adjustedGroupIndex(for: indexPath.section)
        
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: GoodsSectionHeader.identifier,
                for: indexPath
            ) as! GoodsSectionHeader
            header.configure(title: groupedGoods[groupIndex].animationName)
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: GoodsFooterView.identifier,
                for: indexPath
            ) as! GoodsFooterView
            
            let total = groupedGoods[groupIndex].items.count
            if total <= 4 {
                footer.isHidden = true
                return footer
            }
            footer.isHidden = false
            let current = expandedSections[groupIndex] ?? min(4, total)
            footer.update(isExpanded: current >= total)
            
            footer.moreButtonPublisher
                .sink { [weak self] in
                    self?.toggleSection(indexPath.section)
                }
                .store(in: &cancellables)
            
            return footer
        }
    }
}
