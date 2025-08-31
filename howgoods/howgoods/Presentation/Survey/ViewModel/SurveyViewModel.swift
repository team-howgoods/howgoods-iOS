//
//  SurveyViewModel.swift
//  howgoods
//
//  Created by 양원식 on 8/22/25.
//

import Combine
import Foundation

// MARK: - 설문 단계 정의
enum SurveyStep {
    case animation
    case character
    case goodsType
    case goods
}

// MARK: - Input / Output Protocol
protocol SurveyViewModelInput {
    func select(step: SurveyStep, id: Int)
    func deselect(step: SurveyStep, id: Int)
    func reset(step: SurveyStep)
}

protocol SurveyViewModelOutput {
    var selectedAnimations: AnyPublisher<[Int], Never> { get }
    var selectedCharacters: AnyPublisher<[Int], Never> { get }
    var selectedGoodsTypes: AnyPublisher<[Int], Never> { get }
    var selectedGoods: AnyPublisher<[Int], Never> { get }
    
    var requestDTO: SubmitSurveyRequestDTO { get }
}

// MARK: - ViewModel
final class SurveyViewModel: SurveyViewModelInput, SurveyViewModelOutput {
    
    private let surveyUseCase: SurveyUseCaseProtocol
    
    // MARK: - 내부 상태 (Subjects)
    private let animationsSubject = CurrentValueSubject<[Animation], Never>([])
    private let charactersSubject = CurrentValueSubject<[CharacterAnimation], Never>([])
    private let goodsTypesSubject = CurrentValueSubject<[GoodsType], Never>([])
    
    private let selectedAnimationsSubject = CurrentValueSubject<[Int], Never>([])
    private let selectedCharactersSubject = CurrentValueSubject<[Int], Never>([])
    private let selectedGoodsTypesSubject = CurrentValueSubject<[Int], Never>([])
    private let selectedGoodsSubject = CurrentValueSubject<[Int], Never>([])
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Output
    var animations: AnyPublisher<[Animation], Never> {
        animationsSubject.eraseToAnyPublisher()
    }
    
    var characters: AnyPublisher<[CharacterAnimation], Never> {
        charactersSubject.eraseToAnyPublisher()
    }
    
    var goodsTypes: AnyPublisher<[GoodsType], Never> {
        goodsTypesSubject.eraseToAnyPublisher()
    }
    
    var selectedAnimations: AnyPublisher<[Int], Never> {
        selectedAnimationsSubject.eraseToAnyPublisher()
    }
    
    var selectedCharacters: AnyPublisher<[Int], Never> {
        selectedCharactersSubject.eraseToAnyPublisher()
    }
    
    var selectedGoodsTypes: AnyPublisher<[Int], Never> {
        selectedGoodsTypesSubject.eraseToAnyPublisher()
    }
    
    var selectedGoods: AnyPublisher<[Int], Never> {
        selectedGoodsSubject.eraseToAnyPublisher()
    }
    
    var requestDTO: SubmitSurveyRequestDTO {
        SubmitSurveyRequestDTO(
            animationSurveyResults: selectedAnimationsSubject.value.map { AnimationSurveyResultDTO(animationId: $0) },
            characterSurveyResults: selectedCharactersSubject.value.map { CharacterSurveyResultDTO(characterId: $0) },
            goodsTypeSurveyResults: selectedGoodsTypesSubject.value.map { GoodsTypeSurveyResultDTO(goodsTypeId: $0) },
            goodsSurveyResults: selectedGoodsSubject.value.map { GoodsSurveyResultDTO(goodsId: $0) }
        )
    }
    
    // MARK: - Init
    init(surveyUseCase: SurveyUseCaseProtocol) {
        self.surveyUseCase = surveyUseCase
    }
    
    // MARK: - API Call
    func loadAnimations() {
        // 이미 값이 있으면 재호출 안 함
        if !animationsSubject.value.isEmpty { return }
        
        surveyUseCase.fetchAnimations { [weak self] result in
            switch result {
            case .success(let animations):
                self?.animationsSubject.send(animations)
            case .failure(let error):
                print("애니메이션 불러오기 실패:", error)
            }
        }
    }
    
    func loadCharacters() {
        let animationIds = requestDTO.animationSurveyResults.map { $0.animationId }
        if !charactersSubject.value.isEmpty { return }
        
        surveyUseCase.fetchCharacters(animationIds: animationIds) { [weak self] result in
            switch result {
            case .success(let list):
                self?.charactersSubject.send(list)
            case .failure(let error):
                print("캐릭터 불러오기 실패:", error)
            }
        }
    }
    
    func loadGoodsTypes() {
        if !goodsTypesSubject.value.isEmpty { return }
        surveyUseCase.fetchGoodsTypes { [weak self] result in
            switch result {
            case .success(let list):
                self?.goodsTypesSubject.send(list)
            case .failure(let error):
                print("굿즈 타입 불러오기 실패:", error)
            }
        }
    }
    
    // MARK: - Input (단일 선택/해제)
    func select(step: SurveyStep, id: Int) {
        switch step {
        case .animation:
            if id == -1 {
                // "없어요" → 기존 선택 모두 지우고 -1만 남김
                selectedAnimationsSubject.send([-1])
            } else {
                var values = selectedAnimationsSubject.value
                // 만약 -1이 선택돼 있으면 해제
                values.removeAll { $0 == -1 }
                if !values.contains(id) && values.count < 5 {
                    values.append(id)
                }
                selectedAnimationsSubject.send(values)
            }
        case .character:
            updateSelection(subject: selectedCharactersSubject, id: id, max: 5)
        case .goodsType:
            updateSelection(subject: selectedGoodsTypesSubject, id: id)
        case .goods:
            updateSelection(subject: selectedGoodsSubject, id: id, max: 3)
        }
    }
    
    func deselect(step: SurveyStep, id: Int) {
        switch step {
        case .animation:
            removeSelection(subject: selectedAnimationsSubject, id: id)
        case .character:
            removeSelection(subject: selectedCharactersSubject, id: id)
        case .goodsType:
            removeSelection(subject: selectedGoodsTypesSubject, id: id)
        case .goods:
            removeSelection(subject: selectedGoodsSubject, id: id)
        }
    }
    
    func reset(step: SurveyStep) {
        switch step {
        case .animation:
            selectedAnimationsSubject.send([])
        case .character:
            selectedCharactersSubject.send([])
        case .goodsType:
            selectedGoodsTypesSubject.send([])
        case .goods:
            selectedGoodsSubject.send([])
        }
    }
    
    // MARK: - 전체 선택/해제 (goodsType 전용) — 선택 제한 무시
    /// 전달된 모든 goodsType id를 한 번에 선택 (중복 제거)
    func selectAllGoodsTypes(_ ids: [Int]) {
        selectedGoodsTypesSubject.send(Array(Set(ids)))
    }
    
    /// goodsType 선택 전체 해제
    func clearAllGoodsTypes() {
        selectedGoodsTypesSubject.send([])
    }
    
    // MARK: - Helpers
    private func updateSelection(
        subject: CurrentValueSubject<[Int], Never>,
        id: Int,
        max: Int? = nil
    ) {
        var values = subject.value
        if !values.contains(id) {
            if let max = max {
                if values.count < max {
                    values.append(id)
                }
            } else {
                values.append(id) // 제한 없음
            }
        }
        subject.send(values)
    }

    
    private func removeSelection(subject: CurrentValueSubject<[Int], Never>, id: Int) {
        var values = subject.value
        values.removeAll { $0 == id }
        subject.send(values)
    }
}
