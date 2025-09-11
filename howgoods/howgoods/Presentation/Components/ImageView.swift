//
//  ImageView.swift
//  howgoods
//
//  Created by 양원식 on 8/28/25.
//

import UIKit
import Kingfisher

final class ImageView: UIView {
    private let imageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = true
        v.contentMode = .scaleAspectFill
        return v
    }()

    private let gradientLayer = CAGradientLayer()
    private let cornerRadius: CGFloat

    init(cornerRadius: CGFloat = 8) {
        self.cornerRadius = cornerRadius
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    required init?(coder: NSCoder) {
        self.cornerRadius = 8
        super.init(coder: coder)
        translatesAutoresizingMaskIntoConstraints = false
        setup()
    }

    private func setup() {
        addSubviews(
            imageView
        )

        layer.cornerRadius = cornerRadius
        clipsToBounds = true

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        imageView.kf.indicatorType = .activity

        // 아래 절반부터 흰색→검정 그라데이션(기본: 위 투명 흰색, 아래 불투명 검정)
        configureBottomHalfGradient(
            startAlpha: 0.0,   // 위 절반은 영향 없게
            endAlpha: 1.0      // 아래는 완전 검정
        )

        // 이미지 위에 그라데이션 레이어 올림
        imageView.layer.addSublayer(gradientLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = imageView.bounds
        gradientLayer.cornerRadius = cornerRadius
    }

    func prepareForReuse() {
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }

    func setImage(urlOrName: String?, placeholderName: String? = "Sample") {
        let placeholder = placeholderName.flatMap { UIImage(named: $0) }
        guard let s = urlOrName, !s.isEmpty else {
            imageView.image = placeholder
            return
        }

        if s.mc_isProbablyURL {
            let target = bounds.size == .zero ? CGSize(width: 300, height: 300) : bounds.size
            let processor = DownsamplingImageProcessor(size: target)
            imageView.kf.setImage(
                with: URL(string: s),
                placeholder: placeholder,
                options: [.processor(processor), .scaleFactor(UIScreen.main.scale),
                          .cacheOriginalImage, .transition(.fade(0.2))]
            )
        } else {
            imageView.image = UIImage(named: s) ?? placeholder
        }
    }
    
    func reset() {
        imageView.kf.cancelDownloadTask()
        imageView.image = nil
    }

    // MARK: - Gradient
    /// 뷰의 "아래 절반"에서만 흰색→검정 그라데이션
    /// startAlpha가 0이면 위 절반은 투명(이미지 그대로), endAlpha는 아래쪽 어둡기
    func configureBottomHalfGradient(
        startAlpha: CGFloat = 0.0,
        endAlpha: CGFloat = 1.0
    ) {
        gradientLayer.colors = [
            UIColor.white.withAlphaComponent(startAlpha).cgColor,
            UIColor.black.withAlphaComponent(endAlpha).cgColor
        ]
        // 0.5에서 시작해 1.0까지 변화 → 상단 50%는 처음 색(투명 흰색) 유지
        gradientLayer.locations = [0.4, 1.0]
        gradientLayer.startPoint = CGPoint(x: 0.4, y: 0.0)
        gradientLayer.endPoint   = CGPoint(x: 0.4, y: 1.0)
    }
}

private extension String {
    var mc_isProbablyURL: Bool {
        let l = lowercased()
        if l.hasPrefix("http://") || l.hasPrefix("https://") { return true }
        if let u = URL(string: self), u.scheme != nil, u.host != nil { return true }
        return false
    }
}
