//
//  SceneDelegate.swift
//  HygrometerApp
//
//  Created by 홍승현 on 2022/07/09.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        let vc = UINavigationController()
        window?.rootViewController = vc
        vc.pushViewController(AddViewController(), animated: false)
//        vc.pushViewController(MainViewController(), animated: false)
        window?.makeKeyAndVisible()
    }
}

