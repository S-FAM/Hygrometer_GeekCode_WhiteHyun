//
//  KeyboardMonitor.swift
//  HygrometerApp
//
//  Created by hyeonseok on 2022/07/24.
//

import Foundation
import Combine
import UIKit

final class KeyboardMonitor : ObservableObject {
    
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

    func keyboardMonitorNoti(noti:Notification){
        print("KeyboardMonitor - keyboardWillShowNotification: noti: \(noti)") //Here
    }

    init(){
        
        print("KeyboardMonitor - init() called")
        
        // 키보드가 올라올 때 이벤트가 들어옴
        NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillShowNotification) // 아래 값을 구독
            .sink { noti in
                self.keyboardMonitorNoti(noti: noti)
                self.updatedKeyboardStatusAction = .show

            }.store(in: &subscriptions)
        
        // 키보드가 내려갈 때 이벤트가 들어옴
        NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillHideNotification)
            .sink { noti in
                self.keyboardMonitorNoti(noti: noti)
                self.updatedKeyboardStatusAction = .hide
            }.store(in: &subscriptions)

        
        // 키보드 크기가 변경될 때 이벤트가 들어옴
        NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillChangeFrameNotification)
            .sink { noti in
                self.keyboardMonitorNoti(noti: noti)

                let keyboardFrame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect

                self.keyboardHeight = keyboardFrame.height

            }.store(in: &subscriptions)
        
        /// 키보드 올라온 이벤트 처리 -> 키보드 높이
        NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.Publisher(center: NotificationCenter.default, name: UIResponder.keyboardWillChangeFrameNotification))
            .compactMap { (noti : Notification) -> CGRect in
                return noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
            }.map{ (keyboardFrame : CGRect) -> CGFloat in
                return keyboardFrame.height
            }.subscribe(Subscribers.Assign(object: self, keyPath: \.keyboardHeight))
            
        
        /// 키보드 내려갈때 이벤트 처리 -> 키보드 높이
        NotificationCenter.Publisher(center: .default, name: UIResponder.keyboardWillHideNotification)
            .compactMap { (noti : Notification) -> CGFloat in
                return .zero
            }.subscribe(Subscribers.Assign(object: self, keyPath: \.keyboardHeight))

    }
}
