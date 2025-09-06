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

    /// SearchBar 내부 UITextField (재귀 탐색으로 안전하게 주입)
    private weak var searchTextField: UITextField?
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = searchView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        // 기존 선택값을 임시 배열에 복사
        tempSelectedGoods = viewModel.requestDTO.goodsSurveyResults.compactMap { $0.goodsId }

        // 키보드 액세서리/제스처 연결
        wireUpKeyboardAccessories()
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
        collectionView.delegate = self
        collectionView.keyboardDismissMode = .onDrag   // 스크롤로 키보드 내려감
        
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
        
        // 화면 하단 "완료" 버튼 → 선택 확정
        searchView.confirmButtonPublisher
            .sink { [weak self] in
                guard let self else { return }
                self.viewModel.reset(step: .goods)
                tempSelectedGoods.forEach { self.viewModel.select(step: .goods, id: $0) }
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
        
        // 선택된 순서 배지 업데이트
        let order = tempSelectedGoods.firstIndex(of: item.id).map { $0 + 1 }
        cell.configure(with: item, order: order)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = goods[indexPath.item]

        if let index = tempSelectedGoods.firstIndex(of: item.id) {
            // 해제
            tempSelectedGoods.remove(at: index)
        } else {
            // 선택
            tempSelectedGoods.append(item.id)
        }

        // 보이는 셀 중 선택된 것만 갱신
        let selectedSet = Set(tempSelectedGoods)
        let visible = collectionView.indexPathsForVisibleItems
        var toReload = Set(visible.filter { selectedSet.contains(goods[$0.item].id) })
        toReload.insert(indexPath) // 탭한 셀 포함
        collectionView.reloadItems(at: Array(toReload))
    }
}

// MARK: - 키보드 / Done 처리
private extension SearchViewController {
    func wireUpKeyboardAccessories() {
        // 화면 아무데나 탭 → 키보드 내려가게 (셀 탭 방해 안 하도록)
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Done 툴바 구성
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
        toolbar.items = [flex, done]
        
        // SearchBar 내부의 UITextField를 재귀적으로 찾아 안전하게 액세서리/델리게이트 설정
        if let tf = searchView.getSearchBar.findTextFieldRecursively() {
            tf.inputAccessoryView = toolbar
            tf.returnKeyType = .done
            tf.delegate = self
            self.searchTextField = tf
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    /// 키보드의 Done 또는 툴바 Done → 검색 실행 + 키보드 내리기
    @objc func doneButtonAction() {
        let keyword = searchView.getSearchBar.text ?? ""
        if keyword.isEmpty {
            goods = []
            collectionView.reloadData()
        } else {
            viewModel.searchGoods(keyword: keyword)
        }
        dismissKeyboard()
    }
}

// MARK: - UITextFieldDelegate
extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doneButtonAction()
        return true
    }
}

// MARK: - KVC 없이 UITextField 찾기
private extension UIView {
    func findTextFieldRecursively() -> UITextField? {
        if let tf = self as? UITextField { return tf }
        for sub in subviews {
            if let tf = sub.findTextFieldRecursively() { return tf }
        }
        return nil
    }
}
