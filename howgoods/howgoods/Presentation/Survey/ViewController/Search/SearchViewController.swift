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
    
    /// SearchBar 내부 UITextField
    private weak var searchTextField: UITextField?
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        // 기존 선택값 복사
        tempSelectedGoods = viewModel.requestDTO.goodsSurveyResults.compactMap { $0.goodsId }
        
        // 키보드 액세서리/제스처 연결
        wireUpKeyboardAccessories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 검색 초기화
        searchView.getSearchBar.text = ""
        goods = []
        collectionView.reloadData()
        viewModel.clearSearchedGoods()
    }
    
    // MARK: - Initializer
    init(viewModel: SurveyViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - UI Methods
private extension SearchViewController {
    func configure() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = true
        
        collectionView.keyboardDismissMode = .onDrag
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
        
        // 검색 실행
        searchView.getSearchBar.didTapActionButton
            .sink { [weak self] keyword in
                guard let self else { return }
                self.performSearch(with: keyword)
                self.dismissKeyboard()
            }
            .store(in: &cancellables)
        
        // 완료 버튼
        searchView.confirmButtonPublisher
            .sink { [weak self] in
                guard let self else { return }
                self.viewModel.reset(step: .goods)
                tempSelectedGoods.forEach { self.viewModel.select(step: .goods, id: $0) }
                self.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
    
    func performSearch(with raw: String) {
        let keyword = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !keyword.isEmpty else {
            goods = []
            collectionView.reloadData()
            viewModel.clearSearchedGoods()
            return
        }
        viewModel.searchGoods(keyword: keyword)
    }
    
    func setBinding() {
        viewModel.searchedGoods
            .receive(on: RunLoop.main)
            .sink { [weak self] list in
                guard let self else { return }
                self.goods = list
                self.collectionView.reloadData()
                
                // empty 상태 처리
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
        goods.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = goods[indexPath.item]
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GoodsCell.identifier,
            for: indexPath
        ) as! GoodsCell
        
        // 선택된 순서 배지 업데이트
        let order = tempSelectedGoods.firstIndex(of: item.id).map { $0 + 1 }
        cell.configure(with: item, order: order)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = goods[indexPath.item]
        
        // 이미 있으면 무시 (중복 방지)
        if !tempSelectedGoods.contains(item.id) {
            tempSelectedGoods.append(item.id)
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? GoodsCell {
            let order = tempSelectedGoods.firstIndex(of: item.id).map { $0 + 1 }
            cell.updateSelectionOrder(order)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let item = goods[indexPath.item]
        
        if let index = tempSelectedGoods.firstIndex(of: item.id) {
            tempSelectedGoods.remove(at: index)
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? GoodsCell {
            cell.updateSelectionOrder(nil)
        }
    }

}

// MARK: - 키보드 처리
private extension SearchViewController {
    func wireUpKeyboardAccessories() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        if let tf = searchView.getSearchBar.findTextFieldRecursively() {
            tf.inputAccessoryView = nil
            tf.returnKeyType = .done
            tf.enablesReturnKeyAutomatically = true
            tf.delegate = self
            self.searchTextField = tf
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return true
    }
}

// MARK: - UITextField Finder
private extension UIView {
    func findTextFieldRecursively() -> UITextField? {
        if let tf = self as? UITextField { return tf }
        for sub in subviews {
            if let tf = sub.findTextFieldRecursively() { return tf }
        }
        return nil
    }
}
