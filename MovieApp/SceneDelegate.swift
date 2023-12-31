//
//  SceneDelegate.swift
//  MovieApp
//
//  Created by Kerem Tuna Tomak on 18.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Renk ve font tanımlamalarını yapalım
        guard let font = UIFont(name: "SFProText-Medium", size: 18),
              let color = UIColor(named: "0F1B2B") else {
            return
        }
        
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: color,
            .font: font
        ]
        
        // Uygulamanın genelinde Navigasyon çubuğu başlığının görünümünü ayarlıyoruz
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        // Back butonu görünümünü özelleştiriyoruz
        let backImage = UIImage(systemName: "arrow.backward")
        UINavigationBar.appearance().backIndicatorImage = backImage
        UINavigationBar.appearance().tintColor = color
        
        // Back butonu başlığını gizliyoruz
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for: UIBarMetrics.default)
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        if #available(iOS 13.0, *) {
            let darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
            windowScene.windows.forEach { window in
                window.overrideUserInterfaceStyle = darkModeEnabled ? .dark : .light
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

