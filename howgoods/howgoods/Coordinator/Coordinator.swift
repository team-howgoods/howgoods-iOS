//
//  Coordinator.swift
//  howgoods
//
//  Created by 양원식 on 8/14/25.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }
    func start()
}
