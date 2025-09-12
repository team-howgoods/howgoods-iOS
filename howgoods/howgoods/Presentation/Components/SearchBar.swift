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

    // 검색 버튼 탭 이벤트 (텍스트 함께 전달)
    private let actionButtonSubject = PassthroughSubject<String, Never>()
    var didTapActionButton: AnyPublisher<String, Never> {
        actionButtonSubject.eraseToAnyPublisher()
    }

    // MARK: - UI Components
    /// 입력 박스(테두리/코너 적용)
    private let inputContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.cornerRadius = 8
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.lineAlternative.cgColor
        v.clipsToBounds = true
        return v
    }()

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

    // 오른쪽 액션 버튼 (72x44) — 입력 박스 바깥
    private lazy var actionButton: SolidButton = {
        let btn = SolidButton(frame: .zero, title: "검색")
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.updateInsets(top: 10, left: 12, bottom: 10, right: 12)
        btn.isEnabled = false
        return btn
    }()

    // MARK: - Combine
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: textField)
            .map { ($0.object as? UITextField)?.text ?? "" }
            .eraseToAnyPublisher()
    }

    // MARK: - Init
    init(placeholder: String, isActive: Bool) {
        self.isActive = isActive
        super.init(frame: .zero)
        configure(placeholder: placeholder)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }

    // SearchBar 고정 높이
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: 44)
    }
}

// MARK: - Private
private extension SearchBar {
    func configure(placeholder: String) {
        setHierarchy()
        setStyles(placeholder: placeholder)
        setConstraints()
        setBind()
        setTapGesture()
        updateInteraction()

        let initialText = textField.text ?? ""
        clearButton.isHidden = initialText.isEmpty
        actionButton.isEnabled = !initialText.isEmpty
    }

    func setHierarchy() {
        addSubviews(inputContainer, actionButton)
        inputContainer.addSubviews(iconImageView, textField, clearButton)
    }

    func setStyles(placeholder: String) {
        backgroundColor = .clear // 보더/코너는 inputContainer에만
        // Placeholder
        let placeholderAttributes = Typography.attributes(
            for: .body2Medium,
            color: .textAssistive,
            alignment: .left,
            lineBreak: .byTruncatingTail
        )
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: placeholderAttributes)
        // Text
        textField.defaultTextAttributes = Typography.attributes(
            for: .body1Medium,
            color: .textDefault,
            alignment: .left,
            lineBreak: .byTruncatingTail
        )
    }

    func setConstraints() {
        NSLayoutConstraint.activate([
            // 액션 버튼: 오른쪽 붙임, 상하 고정, 폭 72
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionButton.topAnchor.constraint(equalTo: topAnchor),
            actionButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: 72),

            // 입력 컨테이너: 왼쪽~버튼 사이 8pt, 상하 고정
            inputContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            inputContainer.trailingAnchor.constraint(equalTo: actionButton.leadingAnchor, constant: -8),
            inputContainer.topAnchor.constraint(equalTo: topAnchor),
            inputContainer.bottomAnchor.constraint(equalTo: bottomAnchor),

            // 내부 요소 레이아웃
            iconImageView.leadingAnchor.constraint(equalTo: inputContainer.leadingAnchor, constant: 10),
            iconImageView.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),

            clearButton.trailingAnchor.constraint(equalTo: inputContainer.trailingAnchor, constant: -10),
            clearButton.centerYAnchor.constraint(equalTo: inputContainer.centerYAnchor),
            clearButton.widthAnchor.constraint(equalToConstant: 20),
            clearButton.heightAnchor.constraint(equalToConstant: 20),

            textField.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 4),
            textField.trailingAnchor.constraint(equalTo: clearButton.leadingAnchor, constant: -4),
            textField.topAnchor.constraint(equalTo: inputContainer.topAnchor, constant: 11),
            textField.bottomAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: -11),
        ])

        // 우선순위(인풋이 남는 폭을 먹도록)
        actionButton.setContentHuggingPriority(.required, for: .horizontal)
        actionButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        inputContainer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        inputContainer.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
    }

    func setBind() {
        textPublisher
            .sink { [weak self] text in
                guard let self = self else { return }
                self.clearButton.isHidden = text.isEmpty
                self.actionButton.isEnabled = !text.isEmpty
            }
            .store(in: &cancellables)

        clearButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                guard let self = self else { return }
                self.textField.text = ""
                self.clearButton.isHidden = true
                self.actionButton.isEnabled = false
            }
            .store(in: &cancellables)

        actionButton.publisher(for: .touchUpInside)
            .sink { [weak self] in
                guard let self = self else { return }
                if self.isActive {
                    self.actionButtonSubject.send(self.textField.text ?? "")
                } else {
                    self.tapSubject.send()
                }
            }
            .store(in: &cancellables)
    }

    func setTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        inputContainer.addGestureRecognizer(tap)
    }

    func updateInteraction() {
        textField.isUserInteractionEnabled = isActive
    }

    @objc func handleTap() {
        if !isActive { tapSubject.send() }
    }
}

// MARK: - Public API
extension SearchBar {
    var text: String? {
        get { textField.text }
        set {
            textField.text = newValue
            let isEmpty = (newValue ?? "").isEmpty
            clearButton.isHidden = isEmpty
            actionButton.isEnabled = !isEmpty
        }
    }

    func clear() {
        textField.text = ""
        clearButton.isHidden = true
        actionButton.isEnabled = false
    }
}
