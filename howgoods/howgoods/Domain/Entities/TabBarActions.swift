//
//  TabBarActions.swift
//  howgoods
//
//  Created by 양원식 on 8/14/25.
//

import Combine

struct TabBarActions {
    var onHome: () -> Void
    var onAllGoods: () -> Void
//    var onGoodsMap: () -> Void
    var onMyPage: () -> Void
    var cancellables = Set<AnyCancellable>()
}
