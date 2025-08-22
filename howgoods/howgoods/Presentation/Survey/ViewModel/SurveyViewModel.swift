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
    
    // MARK: - 내부 상태 (Subjects)
    private let selectedAnimationsSubject = CurrentValueSubject<[Int], Never>([])
    private let selectedCharactersSubject = CurrentValueSubject<[Int], Never>([])
    private let selectedGoodsTypesSubject = CurrentValueSubject<[Int], Never>([])
    private let selectedGoodsSubject = CurrentValueSubject<[Int], Never>([])
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Output
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
    
    // MARK: - Input
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
                if !values.contains(id) && values.count < 3 {
                    values.append(id)
                }
                selectedAnimationsSubject.send(values)
            }
        case .character:
            updateSelection(subject: selectedCharactersSubject, id: id, max: 3)
        case .goodsType:
            updateSelection(subject: selectedGoodsTypesSubject, id: id, max: 3)
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
    
    // MARK: - Helpers
    private func updateSelection(subject: CurrentValueSubject<[Int], Never>, id: Int, max: Int) {
        var values = subject.value
        if !values.contains(id) {
            if values.count < max {
                values.append(id)
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
