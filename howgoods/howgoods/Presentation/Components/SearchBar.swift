//
//  SearchBar.swift
//  howgoods
//
//  Created by 양원식 on 8/31/25.
//

import UIKit
import Combine

final class SearchBar: UIView {
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    
    // 외부로 노출할 상태
    var isActive: Bool = false {
        didSet { updateInteraction() }
    }
    
    // 외부에서 구독할 수 있는 탭 이벤트
    private let tapSubject = PassthroughSubject<Void, Never>()
    var didTapSearchBar: AnyPublisher<Void, Never> {
        tapSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UI Components
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "search")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .never
        return tf
    }()

    private let clearButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .iconDark
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    // MARK: - Combine
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: textField)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Initializer
    init(placeholder: String, isActive: Bool) {
        self.isActive = isActive
        super.init(frame: .zero)
        configure(placeholder: placeholder)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
}

// MARK: - Private Methods
private extension SearchBar {
    func configure(placeholder: String) {
        setHierarchy()
        setStyles(placeholder: placeholder)
        setConstraints()
        setBind()
        setTapGesture()
        updateInteraction()
    }
    
    func setHierarchy() {
        addSubviews(
            iconImageView,
            textField,
            clearButton
        )
    }
    
    func setStyles(placeholder: String) {
        backgroundColor = .white
        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor.lineAlternative.cgColor
        clipsToBounds = true
        
        // Placeholder 스타일
        let placeholderAttributes = Typography.attributes(
            for: .body2Medium,
            color: .textAssistive,
            alignment: .left,
            lineBreak: .byTruncatingTail
        )
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: placeholderAttributes
        )
        
        // 입력 텍스트 스타일
        textField.defaultTextAttributes = Typography.attributes(
            for: .body1Medium,
            color: .textDefault,
            alignment: .left,
            lineBreak: .byTruncatingTail
        )
    }
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            
            clearButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            clearButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 20),
            clearButton.heightAnchor.constraint(equalToConstant: 20),
            
            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
            textField.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor, constant: -4),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 11),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11)
        ])
    }
    
    func setBind() {
        // 텍스트 변화 감지 → clearButton 표시/숨김
        textPublisher
            .sink { [weak self] text in
                self?.clearButton.isHidden = text.isEmpty
            }
            .store(in: &cancellables)
        
        // clearButton 탭 → textField 비우기
        clearButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                self?.textField.text = ""
                self?.clearButton.isHidden = true
            }
            .store(in: &cancellables)
    }
    
    func setTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tap)
    }
    
    func updateInteraction() {
        textField.isUserInteractionEnabled = isActive
    }
    
    @objc func handleTap() {
        if !isActive {
            tapSubject.send()
        }
    }
}

// MARK: - Public API
extension SearchBar {
    /// 현재 입력된 텍스트를 가져오기
    var text: String? {
        get { textField.text }
        set {
            textField.text = newValue
            clearButton.isHidden = (newValue ?? "").isEmpty
        }
    }
    
    /// 텍스트 초기화
    func clear() {
        textField.text = ""
        clearButton.isHidden = true
    }
}
