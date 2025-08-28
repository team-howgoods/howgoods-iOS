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
    
    /// 임시 데이터 (API 연동 시 교체 예정)
    private let dummyCharacterAnimations: [CharacterAnimation] = [
        CharacterAnimation(id: 16, name: "귀멸의 칼날", characters: [
            Character(id: 1, name: "카마도 탄지로", imageUrl: "https://cdn.mariooutlet.com/Produ0462/B6W/P000733796_d1.jpg"),
            Character(id: 2, name: "카마도 네즈코", imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
            Character(id: 3, name: "젠이츠", imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
            Character(id: 4, name: "칸로지 미츠리", imageUrl: "https://cdn.mariooutlet.cProduct/A0462/B6W/P000733796_d1.jpg"),
            Character(id: 5, name: "렌고쿠 코쥬로", imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
            Character(id: 6, name: "토미오카 기유", imageUrl: "https://cdn.mariooutlet.com/Pruct/A0462/B6W/P000733796_d1.jpg"),
            Character(id: 7, name: "아카자", imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
            Character(id: 8, name: "키부츠지 무잔", imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg")
        ]),
        CharacterAnimation(id: 17, name: "나루토", characters: [
            Character(id: 9, name: "우즈마키 나루토", imageUrl: ""),
            Character(id: 10, name: "우치하 사스케", imageUrl: ""),
            Character(id: 11, name: "하츠네 미쿠", imageUrl: ""),
            Character(id: 12, name: "카카시", imageUrl: ""),
            Character(id: 13, name: "사라토비", imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
            Character(id: 14, name: "이타치", imageUrl: "https://cdn.mariooutlet.com/ProduA0462/B6W/P000733796_d1.jpg"),
            Character(id: 15, name: "도깨비", imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
            Character(id: 16, name: "나루토 (어린 시절)", imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg")
        ]),
        CharacterAnimation(id: 18, name: "원피스", characters: [
            Character(id: 17, name: "몽키 D. 루피", imageUrl: ""),
            Character(id: 18, name: "조로", imageUrl: ""),
            Character(id: 19, name: "나미", imageUrl: ""),
            Character(id: 20, name: "상디", imageUrl: ""),
            Character(id: 21, name: "우소우", imageUrl: ""),
            Character(id: 22, name: "브룩", imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
            Character(id: 23, name: "프랑키", imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
            Character(id: 24, name: "쵸파", imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg")
        ]),
        CharacterAnimation(id: 19, name: "드래곤볼", characters: [
            Character(id: 25, name: "손오공", imageUrl: ""),
            Character(id: 26, name: "베지터", imageUrl: ""),
            Character(id: 27, name: "피콜로", imageUrl: ""),
            Character(id: 28, name: "손오반", imageUrl: ""),
            Character(id: 29, name: "프리저", imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
            Character(id: 30, name: "셀", imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
            Character(id: 31, name: "마인 부우", imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg"),
            Character(id: 32, name: "트랭크스", imageUrl: "https://cdn.mariooutlet.com/Product/A0462/B6W/P000733796_d1.jpg")
        ])
    ]
    
    // Coordinator에서 주입할 이벤트 클로저
    var didTapNext: (() -> Void)?
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = surveyStepTwoView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
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
            .sink { [weak self] _ in
                // 선택 상태 변경 시 셀 전체를 갱신 (간단/안정성 우선)
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDataSource
extension SurveyStepTwoViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dummyCharacterAnimations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dummyCharacterAnimations[section].characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CharacterCell.identifier,
            for: indexPath
        ) as? CharacterCell else {
            return UICollectionViewCell()
        }
        
        let character = dummyCharacterAnimations[indexPath.section].characters[indexPath.item]
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
        header.updateTitle(title: dummyCharacterAnimations[indexPath.section].name)
        return header
    }
}

// MARK: - UICollectionViewDelegate
extension SurveyStepTwoViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let character = dummyCharacterAnimations[indexPath.section].characters[indexPath.item]
        // 선택
        viewModel.select(step: .character, id: character.id)
        // ViewModel에서 max=50 제한, 상태는 setBinding()에서 reload로 반영
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let character = dummyCharacterAnimations[indexPath.section].characters[indexPath.item]
        // 선택 해제
        viewModel.deselect(step: .character, id: character.id)
    }
}
