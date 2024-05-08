//
//  SceneDelegate.swift
//  iOS12-HW22-Mikhailova Olga
//
//  Created by FoxxFire on 06.05.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let moduleBuilder = Builder.module()
        let navigationController = UINavigationController(rootViewController: moduleBuilder)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}

