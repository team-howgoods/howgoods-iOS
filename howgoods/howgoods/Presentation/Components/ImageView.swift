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

    private let shadowImageView: UIImageView = {
        let v = UIImageView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.clipsToBounds = false
        v.contentMode = .scaleAspectFit
        v.isUserInteractionEnabled = false
        return v
    }()

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
            imageView,
            shadowImageView
        )

        layer.cornerRadius = cornerRadius
        clipsToBounds = true

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),

            shadowImageView.topAnchor.constraint(equalTo: topAnchor),
            shadowImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shadowImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shadowImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        shadowImageView.image = UIImage(named: "shadow")
        imageView.kf.indicatorType = .activity
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
}

private extension String {
    var mc_isProbablyURL: Bool {
        let l = lowercased()
        if l.hasPrefix("http://") || l.hasPrefix("https://") { return true }
        if let u = URL(string: self), u.scheme != nil, u.host != nil { return true }
        return false
    }
}
