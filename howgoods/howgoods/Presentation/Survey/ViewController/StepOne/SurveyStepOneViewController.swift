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
    
    private var animations: [Animation] = []
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = surveyStepOneView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        self.viewModel.loadAnimations()
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
    var didTapHome: (() -> Void)?
}

// MARK: - UI Methods
private extension SurveyStepOneViewController {
    func configure() {
        setStyles()
        setCollectionView()
        setActions()
        setBinding()
    }
    func setStyles() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
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
        surveyStepOneView.getTwoButton.primaryTapPublisher
            .sink {
                print("완료 클릭")
                if self.viewModel.requestDTO.animationSurveyResults.contains(where: { $0.animationId == nil }) {
                    // "없어요" 선택됨 → skip 로직 실행
                    self.viewModel.reset(step: .animation)
                    self.didTapSkip?()
                } else {
                    // 정상 선택됨 → 다음 단계
                    self.viewModel.loadCharacters()
                    self.didTapNext?()
                }
            }
            .store(in: &cancellables)
        
        surveyStepOneView.getTwoButton.skipButtonTapPublisher
            .sink {
                print("다음에 할께요 클릭")
                self.didTapHome?()
                self.viewModel.reset(step: .animation)
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
        
        viewModel.animations
            .receive(on: RunLoop.main)
            .sink { [weak self] animations in
                self?.animations = animations
                self?.surveyStepOneView.getTagCollectionView.reloadData()
                self?.surveyStepOneView.updateCollectionViewHeight()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource
extension SurveyStepOneViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        animations.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TagCell.identifier,
            for: indexPath
        ) as? TagCell else {
            return UICollectionViewCell()
        }
        
        if indexPath.item == 0 {
            let isSelected = viewModel.requestDTO.animationSurveyResults.contains { $0.animationId == nil }
            cell.configure(title: "좋아하는 애니메이션이 없어요", isSelected: isSelected)
        } else {
            let item = animations[indexPath.item - 1]
            let isSelected = viewModel.requestDTO.animationSurveyResults.contains { $0.animationId == item.id }
            cell.configure(title: item.name, isSelected: isSelected)
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension SurveyStepOneViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            // "좋아하는 애니메이션이 없어요" → nil 삽입
            viewModel.select(step: .animation, id: nil)
        } else {
            let item = animations[indexPath.item - 1]
            if viewModel.requestDTO.animationSurveyResults.contains(where: { $0.animationId == item.id }) {
                viewModel.deselect(step: .animation, id: item.id)
            } else {
                viewModel.select(step: .animation, id: item.id)
            }
        }
    }
}

