//
//  SurveyViewController.swift
//  howgoods
//
//  Created by 양원식 on 8/20/25.
//

import UIKit
import Combine

final class SurveyViewController: UIViewController {
    
    // MARK: - Properties
    private let surveyView = SurveyView()
    private let viewModel: SurveyViewModel
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Lifecycle
    override func loadView() {
        self.view = surveyView
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
    var didTapStart: (() -> Void)?
    var didTapSkip: (() -> Void)?
}

// MARK: - UI Methods
private extension SurveyViewController {
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
        surveyView.startButtonPublisher
        // TODO: 추후 화면 전환 연결
            .sink {
                print("지금 시작하기 클릭")
                self.didTapStart?()
                self.viewModel.loadAnimations()
            }
            .store(in: &cancellables)
        
        surveyView.skipButtonPublisher
        // TODO: 추후 화면 전환 연결
            .sink {
                print("건너뛰기 클릭")
            }
            .store(in: &cancellables)
    }
    func setBinding() {
        
    }
    
}
