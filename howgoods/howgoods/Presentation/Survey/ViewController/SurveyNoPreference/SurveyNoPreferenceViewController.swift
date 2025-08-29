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
    // private let viewModel: <#ViewModel#>
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = surveyNoPreferenceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    // MARK: - Initializer
    
    init() {
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
                self.didTapHome?()
            }
            .store(in: &cancellables)
    }
    func setBinding() { }
    
}
