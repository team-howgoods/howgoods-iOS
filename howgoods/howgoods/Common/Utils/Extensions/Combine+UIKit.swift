//
//  Combine+UIKit.swift
//  howgoods
//
//  Created by 양원식 on 8/13/25.
//

import Combine
import UIKit

/// `UIControl` 이벤트를 Combine `Publisher` 형태로 변환하는 확장
///
/// - 사용 목적:
///   - 버튼 클릭, 스위치 값 변경 등 `UIControl.Event`를 Combine 스트림으로 변환하여 선언형 방식으로 처리
///
/// - 사용 예시:
/// ```swift
/// myButton
///     .publisher(for: .touchUpInside)
///     .sink { print("버튼 클릭") }
///     .store(in: &cancellables)
/// ```
///
/// - Output: `Void` (이벤트 발생 시 값 없이 신호만 전달)
/// - Failure: `Never` (실패 없음)
extension UIControl {
    
    // MARK: - EventPublisher
    
    /// 특정 `UIControl.Event`를 Combine Publisher로 제공하는 구조체
    struct EventPublisher: Publisher {
        typealias Output = Void
        typealias Failure = Never
        
        /// 이벤트를 감지할 UIControl 객체
        let control: UIControl
        /// 구독할 UIControl 이벤트 타입
        let events: UIControl.Event
        
        func receive<S>(subscriber: S) where S: Subscriber, S.Failure == Failure, S.Input == Output {
            let subscription = EventSubscription(subscriber: subscriber, control: control, event: events)
            subscriber.receive(subscription: subscription)
        }
    }
    
    // MARK: - EventSubscription
    
    /// `UIControl.Event`를 감지하고 Subscriber에게 전달하는 Subscription
    final class EventSubscription<S: Subscriber>: Subscription where S.Input == Void {
        private var subscriber: S?
        weak private var control: UIControl?
        let event: UIControl.Event
        
        init(subscriber: S, control: UIControl, event: UIControl.Event) {
            self.subscriber = subscriber
            self.control = control
            self.event = event
            // UIControl 이벤트 등록
            control.addTarget(self, action: #selector(eventHandler), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {
            // UIControl 이벤트는 무한히 발생할 수 있으므로 별도의 처리 불필요
        }
        
        func cancel() {
            subscriber = nil
        }
        
        /// UIControl 이벤트 발생 시 Subscriber에 Void 신호 전달
        @objc private func eventHandler() {
            _ = subscriber?.receive(())
        }
    }
    
    // MARK: - Public API
    
    /// 특정 `UIControl.Event`를 Combine Publisher로 반환
    ///
    /// - Parameter events: 감지할 UIControl 이벤트
    /// - Returns: 해당 이벤트 발생 시 Void를 방출하는 Publisher
    func publisher(for events: UIControl.Event) -> EventPublisher {
        EventPublisher(control: self, events: events)
    }
}
