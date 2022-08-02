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
        case show
        case hide
    }
    
    var subscriptions = Set<AnyCancellable>()
    
    @Published var updatedKeyboardStatusAction: Status = .hide
    
    init() {
        
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
