//
//  SurveyStepFourViewController.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//
import UIKit
import Combine

final class SurveyStepFourViewController: UIViewController {
    // MARK: - Section / Item 정의
    enum Section: Hashable {
        case selected
        case goods(String) // animationName
    }

    enum Item: Hashable {
        case selected(Int)
        case goods(Int)
    }

    // MARK: - Properties
    private var collectionView: UICollectionView { surveyStepFourView.getCollectionView }
    private let surveyStepFourView = SurveyStepFourView()
    private let viewModel: SurveyViewModel
    private var cancellables = Set<AnyCancellable>()

    private var groupedGoods: [String: [GoodsItem]] = [:]  // animationName -> GoodsItem[]
    private var expandedSections: [String: Int] = [:] // 각 섹션별 현재 표시 개수
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!

    // 캐시된 Goods 조회용 (id -> GoodsItem)
    private var goodsLookup: [Int: GoodsItem] = [:]

    // 스냅샷 적용 중 중복탭 보정
    private var isApplyingSnapshot = false
    private var pendingToggle: String?

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

    // Coordinator 이벤트 클로저
    var didTapHome: (() -> Void)?
    var didTapSearch: (() -> Void)?
}

// MARK: - Configure
private extension SurveyStepFourViewController {
    func configure() {
        setupDataSource()

        // delegate & register
        collectionView.delegate = self
        collectionView.register(GoodsSectionHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: GoodsSectionHeader.identifier)
        collectionView.register(GoodsFooterView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: GoodsFooterView.identifier)
        collectionView.register(SelectedGoodsCell.self,
            forCellWithReuseIdentifier: SelectedGoodsCell.identifier)
        collectionView.register(GoodsCell.self,
            forCellWithReuseIdentifier: GoodsCell.identifier)

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
                self?.viewModel.reset(step: .goodsType)
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)

        surveyStepFourView.getTwoButton.primaryTapPublisher
            .sink { [weak self] in
                self?.viewModel.submitSurvey { result in
                    if case .success = result { self?.didTapHome?() }
                }
            }
            .store(in: &cancellables)

        surveyStepFourView.getTwoButton.skipButtonTapPublisher
            .sink { [weak self] in
                self?.viewModel.reset(step: .goods)
                self?.viewModel.submitSurvey { result in
                    if case .success = result { self?.didTapHome?() }
                }
            }
            .store(in: &cancellables)
    }

    func setBinding() {
        // 굿즈 데이터 바인딩
        viewModel.goods
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.bindGoods($0) }
            .store(in: &cancellables)

        // 선택된 굿즈 바인딩
        viewModel.selectedGoods
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.applySnapshot(isToggle: false) }
            .store(in: &cancellables)

        // 캐시 바인딩 (검색/목록 어떤 경로든 캐시에 합쳐짐)
        viewModel.goodsCache
            .receive(on: RunLoop.main)
            .sink { [weak self] dict in
                self?.goodsLookup = dict
                self?.applySnapshot(isToggle: false)
            }
            .store(in: &cancellables)
    }
}

// MARK: - Diffable Setup
private extension SurveyStepFourViewController {
    func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(
            collectionView: collectionView
        ) { [weak self] collectionView, indexPath, item in
            guard let self else { return UICollectionViewCell() }

            switch item {
            case .selected(let id):
                return self.createSelectedCell(for: collectionView, indexPath: indexPath, id: id)

            case .goods(let id):
                return self.createGoodsCell(for: collectionView, indexPath: indexPath, id: id)
            }
        }

        // Supplementary View (header/footer)
        dataSource.supplementaryViewProvider = { [weak self]
            (collectionView: UICollectionView, kind: String, indexPath: IndexPath) -> UICollectionReusableView? in
            guard let self else { return nil }
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]

            switch section {
            case .goods(let animationName):
                return self.createFooterOrHeader(collectionView: collectionView, kind: kind, indexPath: indexPath, animationName: animationName)

            default:
                return nil
            }
        }

        // 초기 레이아웃 적용
        collectionView.setCollectionViewLayout(
            surveyStepFourView.createLayout(dataSource: dataSource), animated: false
        )
    }

    // MARK: - Cell Creation Helpers
    private func createSelectedCell(for collectionView: UICollectionView, indexPath: IndexPath, id: Int) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: SelectedGoodsCell.identifier, for: indexPath
        ) as! SelectedGoodsCell
        if let it = goodsLookup[id] ?? groupedGoods.flatMap({ $0.value }).first(where: { $0.id == id }) {
            cell.configure(with: it)
        }
        cell.didTapRemoveButton
            .sink { [weak self] goodsId in
                self?.viewModel.deselect(step: .goods, id: goodsId)
            }
            .store(in: &cancellables)
        return cell
    }

    private func createGoodsCell(for collectionView: UICollectionView, indexPath: IndexPath, id: Int) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GoodsCell.identifier, for: indexPath
        ) as! GoodsCell
        if let it = goodsLookup[id] ?? groupedGoods.flatMap({ $0.value }).first(where: { $0.id == id }) {
            let selectedIds = self.viewModel.requestDTO.goodsSurveyResults.compactMap { $0.goodsId }
            let order = selectedIds.firstIndex(of: it.id).map { $0 + 1 }
            cell.configure(with: it, order: order)
        }
        return cell
    }

    private func createFooterOrHeader(collectionView: UICollectionView, kind: String, indexPath: IndexPath, animationName: String) -> UICollectionReusableView? {
        if kind == UICollectionView.elementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: GoodsSectionHeader.identifier, for: indexPath
            ) as! GoodsSectionHeader
            header.configure(title: animationName)
            return header
        } else {
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: GoodsFooterView.identifier, for: indexPath
            ) as! GoodsFooterView
            if let group = groupedGoods[animationName] {
                let total = group.count
                let current = expandedSections[animationName] ?? min(4, total)
                footer.isHidden = total <= 4
                footer.configure(total: total, visibleCount: current)
                footer.moreButtonPublisher
                    .sink { [weak self] in self?.toggleSection(animationName: animationName) }
                    .store(in: &footer.reuseBag)
            }
            return footer
        }
    }

    // MARK: - Snapshot Management
    private func applySnapshot(isToggle: Bool, sectionToReloads: [String]? = nil) {
        guard !isApplyingSnapshot else {
            if let name = sectionToReloads?.last { pendingToggle = name }
            return
        }
        isApplyingSnapshot = true

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()

        let selectedIds = viewModel.requestDTO.goodsSurveyResults.compactMap { $0.goodsId }
        let allGoodsIds = groupedGoods.flatMap { $0.value.map { $0.id } }

        if !selectedIds.isEmpty {
            snapshot.appendSections([.selected])
            snapshot.appendItems(selectedIds.map { Item.selected($0) }, toSection: .selected)
        }

        for (name, items) in groupedGoods {
            snapshot.appendSections([.goods(name)])
            let limit = expandedSections[name] ?? min(4, items.count)
            snapshot.appendItems(items.prefix(limit).map { Item.goods($0.id) }, toSection: .goods(name))
        }

        let reloadItems = allGoodsIds.map { Item.goods($0) }
        let existingItems = snapshot.itemIdentifiers.filter { reloadItems.contains($0) }
        snapshot.reloadItems(existingItems)

        let goodsSections = (sectionToReloads ?? Array(groupedGoods.keys))
            .map { Section.goods($0) }
        snapshot.reloadSections(goodsSections)

        dataSource.apply(snapshot, animatingDifferences: isToggle) { [weak self] in
            self?.isApplyingSnapshot = false
            if let name = self?.pendingToggle {
                self?.pendingToggle = nil
                self?.toggleSection(animationName: name)
            }
        }
    }
}

// MARK: - Helpers
private extension SurveyStepFourViewController {
    func bindGoods(_ list: [GoodsItem]) {
        // 데이터를 그룹핑하되, 원본 순서를 유지하도록 수정
        groupedGoods = [:]
        
        // 각 항목을 그룹에 추가하면서 원본 순서대로 그룹화
        for item in list {
            if groupedGoods[item.animationName] == nil {
                groupedGoods[item.animationName] = []
            }
            groupedGoods[item.animationName]?.append(item)
        }
        
        // 초기 표시할 개수는 최대 4개로 설정
        expandedSections = groupedGoods.reduce(into: [:]) { $0[$1.key] = min(4, $1.value.count) }
        
        applySnapshot(isToggle: false)
    }
    func toggleSection(animationName: String) {
        guard let group = groupedGoods[animationName] else { return }
        let total = group.count
        let current = expandedSections[animationName] ?? min(4, total)
        expandedSections[animationName] = current >= total ? 4 : min(current + 6, total)

        applySnapshot(isToggle: true, sectionToReloads: [animationName])
    }
}

// MARK: - Delegate
extension SurveyStepFourViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        switch item {
        case .selected(let id):
            viewModel.deselect(step: .goods, id: id)
        case .goods(let id):
            let selectedIds = viewModel.requestDTO.goodsSurveyResults.compactMap { $0.goodsId }
            if selectedIds.contains(id) {
                viewModel.deselect(step: .goods, id: id)
            } else {
                viewModel.select(step: .goods, id: id)
            }
        }
    }
}
