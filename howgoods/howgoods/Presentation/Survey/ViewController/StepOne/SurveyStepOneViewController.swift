//
//  SurveyViewController.swift
//  howgoods
//
//  Created by 양원식 on 8/20/25.
//

import UIKit
import Combine

final class SurveyStepOneViewController: UIViewController {
    
    // MARK: - Properties
    private let surveyStepOneView = SurveyStepOneView()
    private let viewModel: SurveyViewModel
    private var cancellables = Set<AnyCancellable>()
    
    /// 임시 데이터 (API 연동 시 교체 예정)
    private let dummyAnimations: [Animation] = [
        Animation(id: 1, name: "귀멸의 칼날", imageUrl: ""),
        Animation(id: 2, name: "원피스", imageUrl: ""),
        Animation(id: 3, name: "나루토", imageUrl: ""),
        Animation(id: 4, name: "주술회전", imageUrl: ""),
        Animation(id: 5, name: "진격의 거인", imageUrl: "")
    ]
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = surveyStepOneView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        surveyStepOneView.updateCollectionViewHeight()
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
    
    // Coordinator에서 주입할 이벤트 클로저
    var didTapNext: (() -> Void)?
    var didTapSkip: (() -> Void)?
}

// MARK: - UI Methods
private extension SurveyStepOneViewController {
    func configure() {
        setCollectionView()
        setActions()
        setBinding()
    }
    
    // MARK: - CollectionView 설정
    func setCollectionView() {
        surveyStepOneView.getTagCollectionView.dataSource = self
        surveyStepOneView.getTagCollectionView.delegate = self

        if let flowLayout = surveyStepOneView.getTagCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            flowLayout.minimumInteritemSpacing = 5
            flowLayout.minimumLineSpacing = 8
        }
    }

    
    // MARK: - Actions
    func setActions() {
        surveyStepOneView.nextButtonPublisher
            .sink {
                print("다음 클릭, requestDTO:", self.viewModel.requestDTO)
                self.didTapNext?()
            }
            .store(in: &cancellables)
        
        surveyStepOneView.skipButtonPublisher
            .sink {
                print("건너뛰기 클릭")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Binding
    func setBinding() {
        viewModel.selectedAnimations
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.surveyStepOneView.getTagCollectionView.reloadData()
                self?.surveyStepOneView.updateCollectionViewHeight()
            }
            .store(in: &cancellables)
        
        // 뒤로가기 버튼 탭 이벤트 구독
        surveyStepOneView.getNavigationBar.backButtonPublisher
            .sink { [weak self] in
                print("뒤로가기 클릭")
                self?.viewModel.reset(step: .animation)
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource
extension SurveyStepOneViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dummyAnimations.count + 1 // 마지막에 "없어요" 셀 추가
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCell.identifier,
            for: indexPath
        ) as? TagCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.item == dummyAnimations.count {
            // "없어요" 셀
            let isSelected = viewModel.requestDTO.animationSurveyResults.contains { $0.animationId == -1 }
            cell.configure(title: "좋아하는 애니메이션이 없어요", isSelected: isSelected)
        } else {
            let item = dummyAnimations[indexPath.item]
            let isSelected = viewModel.requestDTO.animationSurveyResults.contains { $0.animationId == item.id }
            cell.configure(title: item.name, isSelected: isSelected)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SurveyStepOneViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == dummyAnimations.count {
            viewModel.select(step: .animation, id: -1)
        } else {
            let item = dummyAnimations[indexPath.item]
            
            if viewModel.requestDTO.animationSurveyResults.contains(where: { $0.animationId == item.id }) {
                viewModel.deselect(step: .animation, id: item.id)
            } else {
                viewModel.select(step: .animation, id: item.id)
            }
        }
    }
}
