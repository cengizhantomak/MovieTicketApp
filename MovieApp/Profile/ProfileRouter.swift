//
//  ProfileRouter.swift
//  MovieApp
//
//  Created by Cengizhan Tomak on 8.07.2023.
//

import Foundation
import UIKit

protocol ProfileRoutingLogic: AnyObject {
    func routeToMyBankCards()
    func routeToLinkedIn()
    func routeToMobvenVideo()
    func routeToLoginScreen()
}

protocol ProfileDataPassing: AnyObject {
    var dataStore: ProfileDataStore? { get }
}

final class ProfileRouter: ProfileRoutingLogic, ProfileDataPassing {
    
    weak var viewController: ProfileViewController?
    var dataStore: ProfileDataStore?
    
    func routeToMyBankCards() {
        let storyboard = UIStoryboard(name: "MyBankCards", bundle: nil)
        
        guard let destinationVC = storyboard.instantiateViewController(withIdentifier: "MyBankCardsViewController") as? MyBankCardsViewController else { return }
        
        destinationVC.loadViewIfNeeded()
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToLinkedIn() {
        let storyboard = UIStoryboard(name: "LinkedIn", bundle: nil)
        
        guard let destinationVC = storyboard.instantiateViewController(withIdentifier: "LinkedInViewController") as? LinkedInViewController else { return }
        
        destinationVC.hidesBottomBarWhenPushed = true
        destinationVC.loadViewIfNeeded()
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToMobvenVideo() {
        let storyboard = UIStoryboard(name: "MobvenVideo", bundle: nil)
        
        guard let destinationVC = storyboard.instantiateViewController(withIdentifier: "MobvenVideoViewController") as? MobvenVideoViewController else { return }
        
        destinationVC.hidesBottomBarWhenPushed = true
        destinationVC.loadViewIfNeeded()
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
    
    func routeToLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController,
              let windowScene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first else { return }
        
        window.rootViewController = loginVC
        window.makeKeyAndVisible()
    }
}
