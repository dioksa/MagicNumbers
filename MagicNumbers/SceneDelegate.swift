//
//  SceneDelegate.swift
//  MagicNumbers
//
//  Created by Oksana Dionisieva on 18.09.2025.
//

import UIKit
import CoreData

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let storyboard = UIStoryboard(name: "MainViewController", bundle: nil)
        guard let mainVC = storyboard.instantiateViewController(identifier: "MainViewController") as? MainViewController else { return }

        mainVC.context = AppDelegate.shared.persistentContainer.viewContext

        let nav = UINavigationController(rootViewController: mainVC)
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = nav
        self.window = window
        window.makeKeyAndVisible()
    }
}
