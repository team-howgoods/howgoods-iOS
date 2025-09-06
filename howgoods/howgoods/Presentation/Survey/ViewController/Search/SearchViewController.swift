//
//  SearchViewController.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//

import UIKit
import Combine

final class SearchViewController: UIViewController {
    
    // MARK: - Properties
    private let searchView = SearchView()
    private let viewModel: SurveyViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var goods: [GoodsItem] = []
    private var collectionView: UICollectionView { searchView.getCollectionView }
    
    /// 임시 선택된 굿즈 ID 목록 (순서 유지)
    private var tempSelectedGoods: [Int] = []
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        // 기존 선택값을 임시 배열에 복사
        tempSelectedGoods = viewModel.requestDTO.goodsSurveyResults.compactMap { $0.goodsId }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 검색창 초기화
        searchView.getSearchBar.text = ""
        // 검색 결과 초기화
        goods = []
        collectionView.reloadData()
        // 뷰모델의 검색 상태도 초기화
        viewModel.clearSearchedGoods()
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
}

// MARK: - UI Methods
private extension SearchViewController {
    func configure() {
        collectionView.dataSource = self
        collectionView.delegate   = self
        
        setActions()
        setBinding()
    }
    
    func setActions() {
        // 뒤로가기
        searchView.getNavigationBar.backButtonPublisher
            .sink { [weak self] in
                self?.viewModel.reset(step: .character)
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
        
        // 검색 이벤트 바인딩
        searchView.getSearchBar.textPublisher
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] keyword in
                guard let self else { return }
                
                if keyword.isEmpty {
                    self.goods = []
                    self.collectionView.reloadData()
                    return
                }
                self.viewModel.searchGoods(keyword: keyword)
            }
            .store(in: &cancellables)
        
        // 완료 버튼 액션
        searchView.confirmButtonPublisher
            .sink { [weak self] in
                guard let self else { return }
                // 선택 초기화 후 임시 선택 확정
                self.viewModel.reset(step: .goods) // goodsSubject는 유지됨
                tempSelectedGoods.forEach {
                    self.viewModel.select(step: .goods, id: $0)
                }
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
    
    func setBinding() {
        viewModel.searchedGoods
            .receive(on: RunLoop.main)
            .sink { [weak self] list in
                guard let self else { return }
                self.goods = list
                self.collectionView.reloadData()
                
                self.searchView.getEmptyLabel.isHidden = !list.isEmpty
                self.collectionView.isHidden = list.isEmpty
            }
            .store(in: &cancellables)
    }
}

// MARK: - CollectionView
extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int { 1 }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return goods.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = goods[indexPath.item]
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GoodsCell.identifier,
            for: indexPath
        ) as! GoodsCell
        cell.configure(with: item)
        
        if let order = tempSelectedGoods.firstIndex(of: item.id) {
            cell.updateSelectionOrder(order + 1)
        } else {
            cell.updateSelectionOrder(nil)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = goods[indexPath.item]
        
        if let index = tempSelectedGoods.firstIndex(of: item.id) {
            // 해제
            tempSelectedGoods.remove(at: index)
            if let cell = collectionView.cellForItem(at: indexPath) as? GoodsCell {
                cell.updateSelectionOrder(nil)
            }
        } else {
            // 선택
            tempSelectedGoods.append(item.id)
            if let cell = collectionView.cellForItem(at: indexPath) as? GoodsCell {
                let order = tempSelectedGoods.firstIndex(of: item.id) ?? 0
                cell.updateSelectionOrder(order + 1)
            }
        }
        
        collectionView.reloadData() // 전체 인덱스 업데이트
    }
}
