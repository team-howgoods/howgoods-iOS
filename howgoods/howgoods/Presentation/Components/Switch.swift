//
//  Switch.swift
//  howgoods
//
//  Created by 양원식 on 8/18/25.
//

import UIKit
import Combine

class Switch: UISwitch {
    
    private let onColor: UIColor
    private let offColor: UIColor
    
    init(frame: CGRect, onColor: UIColor, offColor: UIColor) {
        self.onColor = onColor
        self.offColor = offColor
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension Switch {
    func configure() {
        setStyle()
    }
    
    func setStyle() {
        self.backgroundColor = .white
        
        self.onTintColor = onColor
        self.tintColor = offColor
        
        self.thumbTintColor = .white
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
