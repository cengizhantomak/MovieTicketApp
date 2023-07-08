//
//  ProfileViewController.swift
//  MovieApp
//
//  Created by Cengizhan Tomak on 8.07.2023.
//

import UIKit

protocol ProfileDisplayLogic: AnyObject {
    func displayProfile(viewModel: ProfileModels.FetchProfile.ViewModel)
}

final class ProfileViewController: UIViewController {
    
    // MARK: - VIP Properties
    
    var interactor: ProfileBusinessLogic?
    var router: (ProfileRoutingLogic & ProfileDataPassing)?
    
    // MARK: - Outlet
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var darkModeSwitch: UISwitch!
    
    // MARK: - Property
    
    var displayedProfile: ProfileModels.FetchProfile.ViewModel?
    
    // MARK: - Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Profile"
        interactor?.fetchProfile()
        
        if #available(iOS 13.0, *) {
            let darkModeEnabled = UserDefaults.standard.bool(forKey: "darkModeEnabled")
            darkModeSwitch.isOn = darkModeEnabled
        }
    }
    
    // MARK: - Setup
    
    private func setup() {
        let viewController = self
        let interactor = ProfileInteractor()
        let presenter = ProfilePresenter()
        let router = ProfileRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: - Action
    
    @IBAction func darkModeSwitch(_ sender: UISwitch) {
        if #available(iOS 13.0, *) {
            if sender.isOn {
                (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .dark
                }
                UserDefaults.standard.set(true, forKey: "darkModeEnabled")
            } else {
                (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.forEach { window in
                    window.overrideUserInterfaceStyle = .light
                }
                UserDefaults.standard.set(false, forKey: "darkModeEnabled")
            }
        }
    }
}

// MARK: - DisplayLogic

extension ProfileViewController: ProfileDisplayLogic {
    func displayProfile(viewModel: ProfileModels.FetchProfile.ViewModel) {
        
        displayedProfile = viewModel
        guard let displayedProfile else { return }
        
        if let posterUrl = ImageUrlHelper.imageUrl(for: displayedProfile.avatarPath) {
            profileImage.load(url: posterUrl)
        }
        
        nameLabel.text = displayedProfile.name
        userNameLabel.text = displayedProfile.username
    }
}
