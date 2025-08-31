//
//  SurveyStepTwoViewController.swift
//  howgoods
//
//  Created by 양원식 on 8/23/25.
//

import UIKit
import Combine

final class SurveyStepTwoViewController: UIViewController {
    
    // MARK: - Properties
    private let surveyStepTwoView = SurveyStepTwoView()
    private var collectionView: UICollectionView { surveyStepTwoView.getTagCollectionView }
    private let viewModel: SurveyViewModel
    private var cancellables = Set<AnyCancellable>()
    
    private var characterAnimations: [CharacterAnimation] = []
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = surveyStepTwoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.loadCharacters()
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
}

// MARK: - UI Methods
private extension SurveyStepTwoViewController {
    func configure() {
        setCollectionView()
        setActions()
        setBinding()
    }
    
    // MARK: - CollectionView 설정
    func setCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Compositional Layout (섹션은 View에서 생성)
        let layout = UICollectionViewCompositionalLayout { [weak self] _, _ in
            return self?.surveyStepTwoView.createCharacterSection()
        }
        collectionView.collectionViewLayout = layout
        
        // 다중 선택 허용 (최대 개수 제한은 ViewModel에서 50으로 관리)
        collectionView.allowsMultipleSelection = true
    }
    
    // MARK: - Actions
    func setActions() {
        surveyStepTwoView.nextButtonPublisher
            .sink { [weak self] in
                guard let self = self else { return }
                print("다음 클릭, requestDTO:", self.viewModel.requestDTO)
                self.didTapNext?()
            }
            .store(in: &cancellables)
        
        // 뒤로가기
        surveyStepTwoView.getNavigationBar.backButtonPublisher
            .sink { [weak self] in
                print("뒤로가기 클릭")
                self?.viewModel.reset(step: .character)
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Binding
    func setBinding() {
        viewModel.selectedCharacters
            .receive(on: RunLoop.main)
            .sink { [weak self] selected in
                guard let self = self else { return }

                let count = selected.count
                // 버튼 텍스트 업데이트
                self.surveyStepTwoView.updateNextButtonTitle(count: count)
                // 선택이 없으면 비활성화
                self.surveyStepTwoView.setNextButtonEnabled(count > 0)
                // 셀 전체 갱신
                self.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.characters
            .receive(on: RunLoop.main)
            .sink { [weak self] list in
                self?.characterAnimations = list
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource
extension SurveyStepTwoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        characterAnimations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characterAnimations[section].characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharacterCell.identifier,
            for: indexPath
        ) as? CharacterCell else {
            return UICollectionViewCell()
        }
        
        let character = characterAnimations[indexPath.section].characters[indexPath.item]
        cell.configure(character: character)
        
        // ViewModel 상태로부터 선택 여부 계산 (Step One 스타일)
        let isSelected = viewModel.requestDTO.characterSurveyResults.contains { $0.characterId == character.id }
        
        // UI 선택 동기화
        if isSelected {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
            cell.isSelected = true
        } else {
            collectionView.deselectItem(at: indexPath, animated: false)
            cell.isSelected = false
        }
        
        return cell
    }
    
    // 섹션 헤더
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader,
              let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: TitleHeaderView.identifier,
                for: indexPath
              ) as? TitleHeaderView else {
            return UICollectionReusableView()
        }
        header.updateTitle(title: characterAnimations[indexPath.section].name)
        return header
    }
}

// MARK: - UICollectionViewDelegate
extension SurveyStepTwoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = characterAnimations[indexPath.section].characters[indexPath.item]
        // 선택
        viewModel.select(step: .character, id: character.id)
        // ViewModel에서 max=50 제한, 상태는 setBinding()에서 reload로 반영
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let character = characterAnimations[indexPath.section].characters[indexPath.item]
        // 선택 해제
        viewModel.deselect(step: .character, id: character.id)
    }
}
