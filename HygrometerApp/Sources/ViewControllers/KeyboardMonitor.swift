//
//  KeyboardMonitor.swift
//  HygrometerApp
//
//  Created by hyeonseok on 2022/07/24.
//

import Combine
import UIKit

final class KeyboardMonitor {
    
    enum Status {
        case show, hide
        var description: String {
            switch self {
            case .show: return "보임"
            case .hide: return "안보임"
            }
        }
    }

    var subscriptions = Set<AnyCancellable>()

    @Published var updatedKeyboardStatusAction: Status = .hide
    @Published var keyboardHeight: CGFloat = 0.0

    func keyboardMonitorNoti(noti: Notification) {
        print("KeyboardMonitor - keyboardWillShowNotification: noti: \(noti)") //Here
    }

    init() {
               
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink {
                print($0)
            }.store(in: &subscriptions)
        // 키보드가 올라올 때 이벤트가 들어옴
        NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillShowNotification) // 아래 값을 구독
            .sink { [weak self] noti in
                self?.keyboardMonitorNoti(noti: noti)
                self?.updatedKeyboardStatusAction = .show
            }.store(in: &subscriptions)

        // 키보드가 내려갈 때 이벤트가 들어옴
        NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] noti in
                self?.keyboardMonitorNoti(noti: noti)
                self?.updatedKeyboardStatusAction = .hide
            }.store(in: &subscriptions)

        // 키보드 크기가 변경될 때 이벤트가 들어옴
        NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillChangeFrameNotification)
            .sink { [weak self] noti in
                self?.keyboardMonitorNoti(noti: noti)
                let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                self?.keyboardHeight = keyboardFrame.height
            }.store(in: &subscriptions)

        /// 키보드 올라온 이벤트 처리 -> 키보드 높이
        NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillChangeFrameNotification))
            .compactMap { noti in
                return noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            }.map { keyboardFrame in
                return keyboardFrame.height
            }
            .sink { [weak self] height in
                self?.keyboardHeight = height
            }.store(in: &subscriptions)

        /// 키보드 내려갈때 이벤트 처리 -> 키보드 높이
        NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillHideNotification)
            .compactMap { noti in
                return .zero
            }
            .sink { [weak self] height in
                self?.keyboardHeight = height
            }.store(in: &subscriptions)
    }
}
