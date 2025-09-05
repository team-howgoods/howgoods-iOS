//
//  SurveyStepThreeViewController.swift
//  howgoods
//
//  Created by 양원식 on 8/28/25.
//

import UIKit
import Combine

final class SurveyStepThreeViewController: UIViewController {

    // MARK: - Properties
    private let surveyStepThreeView = SurveyStepThreeView()
    private var collectionView: UICollectionView { surveyStepThreeView.getCollectionView }
    private let viewModel: SurveyViewModel
    private var cancellables = Set<AnyCancellable>()


    // “전체 선택” + 일반 아이템
    private enum Item {
        case selectAll
        case goods(GoodsType)
    }
    private lazy var items: [Item] = []

    // 편의
    private var allIDs: [Int] {
        items.compactMap {
            if case .goods(let g) = $0 { return g.goodsTypeId }
            return nil
        }
    }
    private var selectedIDs: [Int] {
        viewModel.requestDTO.goodsTypeSurveyResults.map { $0.goodsTypeId }
    }

    // Coordinator 콜백
    var didTapNext: (() -> Void)?

    // MARK: - Init
    init(viewModel: SurveyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func loadView() {
        self.view = surveyStepThreeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension SurveyStepThreeViewController {
    func configure() {
        setCollectionView()
        setStyles()
        setActions()
        setBinding()
    }

    func setStyles() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    func setCollectionView() {
        // 세로 스크롤 그리드(레이아웃은 View가 제공)
        let layout = UICollectionViewCompositionalLayout { [weak self] _, _ in
            return self?.surveyStepThreeView.createGoodsTypeSection()
        }
        collectionView.collectionViewLayout = layout
        collectionView.allowsMultipleSelection = true // 수동 선택은 VM에서 3개 제한
        collectionView.dataSource = self
        collectionView.delegate   = self
    }

    func setActions() {
        // 다음
        surveyStepThreeView.nextButtonPublisher
            .sink { [weak self] in
                guard let self else { return }
                print("다음 클릭, requestDTO:", self.viewModel.requestDTO)
                viewModel.loadGoods()
                self.didTapNext?()
            }
            .store(in: &cancellables)

        // 뒤로가기
        surveyStepThreeView.getNavigationBar.backButtonPublisher
            .sink { [weak self] in
                self?.viewModel.reset(step: .character)
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }

    func setBinding() {
        // 선택 상태 변경 시 셀 동기화(버튼 타이틀 갱신 X)
        viewModel.selectedGoodsTypes
            .receive(on: RunLoop.main)
            .sink { [weak self] selected in
                guard let self else { return }
                
                let count = selected.count
                self.surveyStepThreeView.setNextButtonEnabled(count > 0)
                
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        // 굿즈 타입 리스트 바인딩
        viewModel.goodsTypes
            .receive(on: RunLoop.main)
            .sink { [weak self] list in
                guard let self else { return }
                self.items = [.selectAll] + list.map { .goods($0) }
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }

    // 현재 “모두 선택됨” 상태인지
    func isAllSelected() -> Bool {
        let setAll = Set(allIDs)
        let setSel = Set(selectedIDs)
        return setAll.isSubset(of: setSel) && !setAll.isEmpty
    }

    // 전체 선택/해제 (제한 무시)
    func toggleSelectAll() {
        if isAllSelected() {
            viewModel.clearAllGoodsTypes()
        } else {
            viewModel.selectAllGoodsTypes(allIDs)
        }
    }
}

// MARK: - DataSource
extension SurveyStepThreeViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        items.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        switch items[indexPath.item] {
        case .selectAll:
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SelectAllCell.identifier, for: indexPath
            ) as! SelectAllCell

            // 선택상태 동기화
            if isAllSelected() {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                cell.isSelected = true
            } else {
                collectionView.deselectItem(at: indexPath, animated: false)
                cell.isSelected = false
            }
            return cell

        case .goods(let model):
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: GoodsTypeCell.identifier, for: indexPath
            ) as! GoodsTypeCell
            cell.configure(goodsType: model)

            // 선택상태 동기화
            if selectedIDs.contains(model.goodsTypeId) {
                collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
                cell.isSelected = true
            } else {
                collectionView.deselectItem(at: indexPath, animated: false)
                cell.isSelected = false
            }
            return cell
        }
    }
}

// MARK: - Delegate
extension SurveyStepThreeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch items[indexPath.item] {
        case .selectAll:
            toggleSelectAll()
        case .goods(let model):
            viewModel.select(step: .goodsType, id: model.goodsTypeId)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        switch items[indexPath.item] {
        case .selectAll:
            toggleSelectAll() // 토글 성격
        case .goods(let model):
            viewModel.deselect(step: .goodsType, id: model.goodsTypeId)
        }
    }
}
