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

    init() {
               
        Timer.publish(every: 1, on: .main, in: .default)
            .autoconnect()
            .sink {
                print($0)
            }.store(in: &subscriptions)
        // 키보드가 올라올 때 이벤트가 들어옴
        NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] noti in
                self?.updatedKeyboardStatusAction = .show
            }.store(in: &subscriptions)

        // 키보드가 내려갈 때 이벤트가 들어옴
        NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] noti in
                self?.updatedKeyboardStatusAction = .hide
            }.store(in: &subscriptions)
    }
}
