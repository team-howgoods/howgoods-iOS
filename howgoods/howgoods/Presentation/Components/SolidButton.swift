//
//  SolidButton.swift
//  howgoods
//
//  Created by 양원식 on 8/18/25.
//

import UIKit

class SolidButton: UIButton {

    // MARK: - Default Colors (프로젝트 토큰에 맞게 교체 가능)
    private var enabledBackgroundColor: UIColor = .primary
    private var enabledTitleColor: UIColor = .white
    private var disabledBackgroundColor: UIColor = .btnAlternative
    private var disabledTitleColor: UIColor = .textAssistive

    // MARK: - Title cache
    private var currentTitleText: String
    private var currentTitleStyle: Typography.Style = .body2Semibold

    // MARK: - Init
    init(frame: CGRect, title: String) {
        self.currentTitleText = title
        super.init(frame: frame)
        configure()
        setNeedsUpdateConfiguration()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public
    /// 디자인 토큰/테마 교체용
    public func configureColors(
        enabledBackground: UIColor? = nil,
        enabledTitle: UIColor? = nil,
        disabledBackground: UIColor? = nil,
        disabledTitle: UIColor? = nil
    ) {
        if let c = enabledBackground { enabledBackgroundColor = c }
        if let c = enabledTitle { enabledTitleColor = c }
        if let c = disabledBackground { disabledBackgroundColor = c }
        if let c = disabledTitle { disabledTitleColor = c }
        setNeedsUpdateConfiguration()
    }

    public func updateTitle(_ title: String, style: Typography.Style? = nil) {
        currentTitleText = title
        if let style { currentTitleStyle = style }
        setNeedsUpdateConfiguration()
    }

    public func updateInsets(
        top: CGFloat? = nil,
        left: CGFloat? = nil,
        bottom: CGFloat? = nil,
        right: CGFloat? = nil
    ) {
        setInsets(
            top: top ?? 14,
            left: left ?? 28,
            bottom: bottom ?? 14,
            right: right ?? 28
        )
    }

    override var isEnabled: Bool {
        didSet { setNeedsUpdateConfiguration() }
    }

    // MARK: - 상태 변화 시 호출
    override func updateConfiguration() {
        super.updateConfiguration()
        var config = self.configuration ?? .filled()

        let bg = isEnabled ? enabledBackgroundColor : disabledBackgroundColor
        let fg = isEnabled ? enabledTitleColor : disabledTitleColor

        config.baseBackgroundColor = bg
        config.baseForegroundColor = fg
        applyTypography(title: currentTitleText, style: currentTitleStyle, color: fg, into: &config)

        self.configuration = config
    }
}

// MARK: - Private
private extension SolidButton {
    func configure() {
        var config = UIButton.Configuration.filled()
        config.baseBackgroundColor = enabledBackgroundColor
        config.baseForegroundColor = enabledTitleColor
        config.cornerStyle = .medium
        config.contentInsets = .init(top: 14, leading: 28, bottom: 14, trailing: 28)
        self.configuration = config

        layer.cornerRadius = 8
        clipsToBounds = true
    }

    func setInsets(top: CGFloat = 14, left: CGFloat = 28, bottom: CGFloat = 14, right: CGFloat = 28) {
        guard var config = self.configuration else { return }
        config.contentInsets = .init(top: top, leading: left, bottom: bottom, trailing: right)
        self.configuration = config
    }

    func applyTypography(title: String, style: Typography.Style, color: UIColor, into config: inout UIButton.Configuration) {
        config.attributedTitle = AttributedString(
            title,
            attributes: AttributeContainer(
                Typography.attributes(
                    for: style,
                    color: color,
                    alignment: .center,
                    lineBreak: .byTruncatingTail
                )
            )
        )
    }
}
