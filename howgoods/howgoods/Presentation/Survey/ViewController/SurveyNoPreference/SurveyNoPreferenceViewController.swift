//
//  SurveyNoPreferenceViewController.swift
//  howgoods
//
//  Created by 양원식 on 8/30/25.
//

import UIKit
import Combine

final class SurveyNoPreferenceViewController: UIViewController {
    
    // MARK: - Properties
    private let surveyNoPreferenceView = SurveyNoPreferenceView()
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: SurveyViewModel
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = surveyNoPreferenceView
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
    
    // Coordinator에서 주입할 이벤트 클로저
    var didTapHome: (() -> Void)?
}

// MARK: - UI Methods

private extension SurveyNoPreferenceViewController {
    func configure() {
        setHierarchy()
        setStyles()
        setConstraints()
        setActions()
        setBinding()
    }
    
    // MARK: - setBinding
    func setHierarchy() { }
    func setStyles() { }
    func setConstraints() { }
    func setActions() {
        surveyNoPreferenceView.homeButtonPublisher
            .sink {
                print("홈 화면 이동")
                self.viewModel.submitSurvey { result in
                    switch result {
                    case .success(let response):
                        print("서버 응답:", response)
                        self.didTapHome?()
                    case .failure(let error):
                        print("제출 실패:", error)
                    }
                }
            }
            .store(in: &cancellables)
        
        // 뒤로가기
        surveyNoPreferenceView.getNavigationBar.backButtonPublisher
            .sink { [weak self] in
                print("뒤로가기 클릭")
                self?.navigationController?.popViewController(animated: true)
            }
            .store(in: &cancellables)
    }
    func setBinding() { }
    
}
