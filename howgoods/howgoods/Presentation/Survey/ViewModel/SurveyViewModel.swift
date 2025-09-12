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
    func select(step: SurveyStep, id: Int?)
    func deselect(step: SurveyStep, id: Int?)
    func reset(step: SurveyStep)
}

protocol SurveyViewModelOutput {
    var selectedAnimations: AnyPublisher<[Int?], Never> { get }
    var selectedCharacters: AnyPublisher<[Int?], Never> { get }
    var selectedGoodsTypes: AnyPublisher<[Int?], Never> { get }
    var selectedGoods: AnyPublisher<[Int?], Never> { get }
    
    var requestDTO: SubmitSurveyRequestDTO { get }
}

// MARK: - ViewModel
final class SurveyViewModel: SurveyViewModelInput, SurveyViewModelOutput {
    
    private let surveyUseCase: SurveyUseCaseProtocol
    
    // MARK: - 내부 상태 (Subjects)
    private let animationsSubject = CurrentValueSubject<[Animation], Never>([])
    private let charactersSubject = CurrentValueSubject<[CharacterAnimation], Never>([])
    private let goodsTypesSubject = CurrentValueSubject<[GoodsType], Never>([])
    private let goodsSubject = CurrentValueSubject<[GoodsItem], Never>([])
    private let searchGoodsSubject = CurrentValueSubject<[GoodsItem], Never>([])
    
    private let selectedAnimationsSubject = CurrentValueSubject<[Int?], Never>([])
    private let selectedCharactersSubject = CurrentValueSubject<[Int?], Never>([])
    private let selectedGoodsTypesSubject = CurrentValueSubject<[Int?], Never>([])
    private let selectedGoodsSubject = CurrentValueSubject<[Int?], Never>([])
    
    private var cancellables = Set<AnyCancellable>()
    
    // 모든 GoodsItem 캐시 (id -> GoodsItem)
    private let goodsCacheSubject = CurrentValueSubject<[Int: GoodsItem], Never>([:])
    var goodsCache: AnyPublisher<[Int: GoodsItem], Never> {
        goodsCacheSubject.eraseToAnyPublisher()
    }
    func goodsItem(for id: Int) -> GoodsItem? { goodsCacheSubject.value[id] }
    private func mergeGoodsCache(_ items: [GoodsItem]) {
        var cache = goodsCacheSubject.value
        for it in items { cache[it.id] = it }
        goodsCacheSubject.send(cache)
    }
    
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
    
    var goods: AnyPublisher<[GoodsItem], Never> {
        goodsSubject.eraseToAnyPublisher()
    }
    
    var searchedGoods: AnyPublisher<[GoodsItem], Never> {
        searchGoodsSubject.eraseToAnyPublisher()
    }
    
    var selectedAnimations: AnyPublisher<[Int?], Never> {
        selectedAnimationsSubject.eraseToAnyPublisher()
    }
    
    var selectedCharacters: AnyPublisher<[Int?], Never> {
        selectedCharactersSubject.eraseToAnyPublisher()
    }
    
    var selectedGoodsTypes: AnyPublisher<[Int?], Never> {
        selectedGoodsTypesSubject.eraseToAnyPublisher()
    }
    
    var selectedGoods: AnyPublisher<[Int?], Never> {
        selectedGoodsSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Request DTO
    var requestDTO: SubmitSurveyRequestDTO {
        // 내부 상태는 빈 배열 유지
        SubmitSurveyRequestDTO(
            animationSurveyResults: selectedAnimationsSubject.value.isEmpty
                ? []
                : selectedAnimationsSubject.value.map { AnimationSurveyResultDTO(animationId: $0) },
            
            characterSurveyResults: selectedCharactersSubject.value.isEmpty
                ? []
                : selectedCharactersSubject.value.map { CharacterSurveyResultDTO(characterId: $0) },
            
            goodsTypeSurveyResults: selectedGoodsTypesSubject.value.isEmpty
                ? []
                : selectedGoodsTypesSubject.value.map { GoodsTypeSurveyResultDTO(goodsTypeId: $0) },
            
            goodsSurveyResults: selectedGoodsSubject.value.isEmpty
                ? []
                : selectedGoodsSubject.value.map { GoodsSurveyResultDTO(goodsId: $0) }
        )
    }

    
    // MARK: - Init
    init(surveyUseCase: SurveyUseCaseProtocol) {
        self.surveyUseCase = surveyUseCase
    }
    
    // MARK: - API Call
    func loadAnimations() {
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
        let animationIds = requestDTO.animationSurveyResults.compactMap { $0.animationId }
        
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
    
    func loadGoods() {
        let animationIds = requestDTO.animationSurveyResults.compactMap { $0.animationId }
        let goodsTypeIds = requestDTO.goodsTypeSurveyResults.compactMap { $0.goodsTypeId }
        
        surveyUseCase.fetchGoods(animationIds: animationIds, goodsTypeIds: goodsTypeIds) { [weak self] result in
            switch result {
            case .success(let list):
                self?.goodsSubject.send(list)
                self?.mergeGoodsCache(list) // 캐시에 병합
            case .failure(let error):
                print("굿즈 불러오기 실패:", error)
            }
        }
    }
    
    func searchGoods(keyword: String) {
        surveyUseCase.searchGoods(keyword: keyword) { [weak self] result in
            switch result {
            case .success(let list):
                self?.searchGoodsSubject.send(list)
                self?.mergeGoodsCache(list) // 검색 결과도 캐시에 병합
            case .failure(let error):
                print("굿즈 검색 실패:", error)
                self?.searchGoodsSubject.send([])
            }
        }
    }
    
    func submitSurvey(completion: @escaping (Result<SubmitSurveyResponseDTO, Error>) -> Void) {
        print("submitSurvey 호출됨")
        dump(requestDTO) // 보낸 값 전체 구조 확인

        surveyUseCase.submitSurvey(requestDTO: requestDTO) { result in
            print("서버 응답:", result)
            completion(result)
        }
    }

    
    // MARK: - Input (선택/해제)
    func select(step: SurveyStep, id: Int?) {
        switch step {
        case .animation:
            if id == nil {
                // "좋아하는 애니 없음" → nil만 저장
                selectedAnimationsSubject.send([nil])
            } else {
                var values = selectedAnimationsSubject.value
                values.removeAll { $0 == nil } // nil 있으면 제거
                if !values.contains(where: { $0 == id }) && values.count < 5 {
                    values.append(id)
                }
                selectedAnimationsSubject.send(values)
            }
            
        case .character:
            updateSelection(subject: selectedCharactersSubject, id: id, max: 5)
            
        case .goodsType:
            updateSelection(subject: selectedGoodsTypesSubject, id: id)
            
        case .goods:
            updateSelection(subject: selectedGoodsSubject, id: id, max: 30)
        }
    }
    
    func deselect(step: SurveyStep, id: Int?) {
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
    func selectAllGoodsTypes(_ ids: [Int?]) {
        // nil 제외 + 중복 제거
        let nonNilIds = ids.compactMap { $0 }
        selectedGoodsTypesSubject.send(Array(Set(nonNilIds)))
    }

    /// goodsType 선택 전체 해제
    func clearAllGoodsTypes() {
        selectedGoodsTypesSubject.send([])
    }

    /// goods 검색 결과 초기화
    func clearSearchedGoods() {
        searchGoodsSubject.send([])
    }
    
    func sendDummyData() {
        goodsSubject.send(dummyGoods)
        mergeGoodsCache(dummyGoods)
    }
    
    // MARK: - Helpers
    private func updateSelection(
        subject: CurrentValueSubject<[Int?], Never>,
        id: Int?,
        max: Int? = nil
    ) {
        guard let id else { return } // nil은 select에서 따로 처리
        var values = subject.value
        if !values.contains(where: { $0 == id }) {
            if let max = max {
                if values.count < max { values.append(id) }
            } else {
                values.append(id)
            }
        }
        subject.send(values)
    }

    private func removeSelection(subject: CurrentValueSubject<[Int?], Never>, id: Int?) {
        var values = subject.value
        values.removeAll { $0 == id }
        subject.send(values)
    }
}
