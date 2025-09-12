//
//  SurveyStepFourViewController.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//
import UIKit
import Combine

final class SurveyStepFourViewController: UIViewController {
    enum Section: Hashable {
        case selected
        case goods(String)
    }

    enum Item: Hashable {
        case selected(Int)
        case goodsCard(String)
    }

    private var collectionView: UICollectionView { surveyStepFourView.getCollectionView }
    private let surveyStepFourView = SurveyStepFourView()
    private let viewModel: SurveyViewModel
    private var cancellables = Set<AnyCancellable>()

    private var groupedGoods: [String: [GoodsItem]] = [:]
    private var expandedSections: [String: Int] = [:]
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var goodsLookup: [Int: GoodsItem] = [:]

    private var isApplyingSnapshot = false
    private var pendingToggle: String?

    override func loadView() { self.view = surveyStepFourView }
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    init(viewModel: SurveyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented.") }

    var didTapHome: (() -> Void)?
    var didTapSearch: (() -> Void)?
}

// MARK: - Configure
private extension SurveyStepFourViewController {
    func configure() {
        setupDataSource()

        collectionView.delegate = self
        collectionView.register(SelectedGoodsCell.self,
            forCellWithReuseIdentifier: SelectedGoodsCell.identifier)
        collectionView.register(GoodsCardCell.self,
            forCellWithReuseIdentifier: GoodsCardCell.identifier)

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
        viewModel.goods
            .receive(on: RunLoop.main)
            .sink { [weak self] in self?.bindGoods($0) }
            .store(in: &cancellables)

        viewModel.selectedGoods
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in self?.applySnapshot(isToggle: false) }
            .store(in: &cancellables)

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

            case .goodsCard(let animationName):
                return self.createGoodsCardCell(for: collectionView, indexPath: indexPath, animationName: animationName)
            }
        }

        collectionView.setCollectionViewLayout(
            surveyStepFourView.createLayout(dataSource: dataSource), animated: false
        )
    }

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

    private func createGoodsCardCell(for collectionView: UICollectionView, indexPath: IndexPath, animationName: String) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GoodsCardCell.identifier,
            for: indexPath
        ) as! GoodsCardCell

        guard let goods = groupedGoods[animationName] else { return cell }
        let expandedCount = expandedSections[animationName] ?? min(4, goods.count)

        cell.configure(animationName: animationName,
                       goods: goods,
                       expandedCount: expandedCount) { [weak self] item in
            guard let self else { return nil }
            let selectedIds = self.viewModel.requestDTO.goodsSurveyResults.compactMap { $0.goodsId }
            return selectedIds.firstIndex(of: item.id).map { $0 + 1 }
        }

        cell.didSelectGoodsPublisher
            .sink { [weak self, weak cell] item in
                guard let self, let cell else { return }
                let selectedIds = self.viewModel.requestDTO.goodsSurveyResults.compactMap { $0.goodsId }

                if selectedIds.contains(item.id) {
                    cell.updateGoods(item, order: nil)
                    self.viewModel.deselect(step: .goods, id: item.id)
                } else {
                    let order = selectedIds.count + 1
                    cell.updateGoods(item, order: order)
                    self.viewModel.select(step: .goods, id: item.id)
                }
            }
            .store(in: &cell.reuseBag)

        cell.moreButtonPublisher
            .sink { [weak self] animationName in
                self?.toggleSection(animationName: animationName)
            }
            .store(in: &cell.reuseBag)

        return cell
    }
}

// MARK: - Snapshot Management
private extension SurveyStepFourViewController {
    private func applySnapshot(isToggle: Bool, sectionToReloads: [String]? = nil) {
        guard !isApplyingSnapshot else {
            if let name = sectionToReloads?.last { pendingToggle = name }
            return
        }
        isApplyingSnapshot = true

        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        let selectedIds = viewModel.requestDTO.goodsSurveyResults.compactMap { $0.goodsId }

        if !selectedIds.isEmpty {
            snapshot.appendSections([.selected])
            snapshot.appendItems(selectedIds.map { Item.selected($0) }, toSection: .selected)
        }

        for (name, _) in groupedGoods {
            snapshot.appendSections([.goods(name)])
            snapshot.appendItems([.goodsCard(name)], toSection: .goods(name))
        }

        // 항상 reloadItems 보장
        let reloadTargets = sectionToReloads ?? Array(groupedGoods.keys)
        let reloadItems = reloadTargets.map { Item.goodsCard($0) }
        snapshot.reloadItems(reloadItems)

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
        groupedGoods = [:]
        for item in list {
            if groupedGoods[item.animationName] == nil {
                groupedGoods[item.animationName] = []
            }
            groupedGoods[item.animationName]?.append(item)
        }

        // expandedSections 초기값 보장
        expandedSections = groupedGoods.reduce(into: [:]) { result, element in
            result[element.key] = min(4, element.value.count)
        }

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
        case .goodsCard:
            break
        }
    }
}
