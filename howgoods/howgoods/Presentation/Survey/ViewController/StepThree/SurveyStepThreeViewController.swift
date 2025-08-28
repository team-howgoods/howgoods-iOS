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
    private let contentView = SurveyStepThreeView()
    private var collectionView: UICollectionView { contentView.getCollectionView }
    private let viewModel: SurveyViewModel
    private var cancellables = Set<AnyCancellable>()

    private let demoGoodsTypes: [GoodsType] = [
        GoodsType(goodsTypeId: 1, name: "아크릴 스탠드", imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
        GoodsType(goodsTypeId: 2, name: "티셔츠",       imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
        GoodsType(goodsTypeId: 3, name: "키링",         imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
        GoodsType(goodsTypeId: 4, name: "마스코트",     imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
        GoodsType(goodsTypeId: 5, name: "문구류",       imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
        GoodsType(goodsTypeId: 6, name: "포토카드",     imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
        GoodsType(goodsTypeId: 7, name: "인형",         imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
        GoodsType(goodsTypeId: 8, name: "기타",         imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
    ]

    // “전체 선택” + 일반 아이템
    private enum Item {
        case selectAll
        case goods(GoodsType)
    }
    private lazy var items: [Item] = [.selectAll] + demoGoodsTypes.map { .goods($0) }

    // 편의
    private var allIDs: [Int] { demoGoodsTypes.map(\.goodsTypeId) }
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
    override func loadView() { self.view = contentView }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension SurveyStepThreeViewController {
    func configure() {
        setCollectionView()
        setActions()
        setBinding()
    }

    func setCollectionView() {
        // 세로 스크롤 그리드(레이아웃은 View가 제공)
        let layout = UICollectionViewCompositionalLayout { [weak self] _, _ in
            return self?.contentView.createGoodsTypeSection()
        }
        collectionView.collectionViewLayout = layout
        collectionView.allowsMultipleSelection = true // 수동 선택은 VM에서 3개 제한
        collectionView.dataSource = self
        collectionView.delegate   = self
    }

    func setActions() {
        // 다음
        contentView.nextButtonPublisher
            .sink { [weak self] in
                guard let self else { return }
                print("다음 클릭, requestDTO:", self.viewModel.requestDTO)
                self.didTapNext?()
            }
            .store(in: &cancellables)

        // 뒤로가기
        contentView.getNavigationBar.backButtonPublisher
            .sink { [weak self] in
                self?.viewModel.reset(step: .goodsType)
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }

    func setBinding() {
        // 선택 상태 변경 시 셀 동기화(버튼 타이틀 갱신 X)
        viewModel.selectedGoodsTypes
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
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
            viewModel.select(step: .goodsType, id: model.goodsTypeId) // 수동 선택(최대 3개)
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
