//
//  ChooseSeatViewController.swift
//  MovieApp
//
//  Created by Cengizhan Tomak on 14.07.2023.
//

import UIKit

protocol ChooseSeatDisplayLogic: AnyObject {
    func displayFetchedMovie(viewModel: ChooseSeatModels.FetchChooseSeat.ViewModel)
}

final class ChooseSeatViewController: UIViewController {
    
    var interactor: ChooseSeatBusinessLogic?
    var router: (ChooseSeatRoutingLogic & ChooseSeatDataPassing)?
    
    // MARK: - Outlet
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - VIP Properties
    
    var selectedSeats: Set<Int> = []
    
    let a = ["a", "b", "c", "d", "e", "f", "g", "h", "i"]
    let b = [1, 2, 3, 4, 5, 6, 7, 8, 9]
    
    var displayedMovie: ChooseSeatModels.FetchChooseSeat.ViewModel?
    
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
        
        interactor?.getMovie()
        setupNavigationBar()
        setupCollectionView()
    }
    
    // MARK: - Setup
    
    private func setup() {
        let viewController = self
        let interactor = ChooseSeatInteractor()
        let presenter = ChooseSeatPresenter()
        let router = ChooseSeatRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    private func setupNavigationBar() {
        guard let displayedMovie else { return }
        let customView = NavigationCustomView(frame: CGRect(x: 0, y: 0, width: 250, height: 38))
        customView.setupView(viewModel: displayedMovie)
        navigationItem.titleView = customView
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(.init(nibName: "SeatCollectionViewCell", bundle: .main), forCellWithReuseIdentifier: "SeatCollectionViewCell")
        collectionView.collectionViewLayout = getCompositionalLayout()
        collectionView.allowsMultipleSelection = true
    }
    
    // MARK: - CompositionalLayout
    
    func getCompositionalLayout() -> UICollectionViewLayout {
        
        // Item
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 3),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 3, bottom: 0, trailing:3)
        
        // Group in Group
        let innerGroupLayout = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0 / 3),
            heightDimension: .fractionalHeight(1.0)
        )
        let innerGroup = NSCollectionLayoutGroup.horizontal(layoutSize: innerGroupLayout, subitems: [item])
        innerGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 6, bottom: 0, trailing: 6)
        
        let middleGroupLayout = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0 / 3)
        )
        let middleGroup = NSCollectionLayoutGroup.horizontal(layoutSize: middleGroupLayout, subitems: [innerGroup])
        middleGroup.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 0 , bottom: 3, trailing: 0)
        
        let outerGroupLayout = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.45)
        )
        let outerGroup = NSCollectionLayoutGroup.vertical(layoutSize: outerGroupLayout, subitems: [middleGroup])
        outerGroup.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 35 , bottom: 6, trailing: 35)
        
        // Section
        let section = NSCollectionLayoutSection(group: outerGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0 , bottom: 0, trailing: 0)
        
        // Layout
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// MARK: - DisplayLogic

extension ChooseSeatViewController: ChooseSeatDisplayLogic {
    func displayFetchedMovie(viewModel: ChooseSeatModels.FetchChooseSeat.ViewModel) {
        displayedMovie = viewModel
    }
}

// MARK: - UICollectionView

extension ChooseSeatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return a.count * b.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SeatCollectionViewCell", for: indexPath) as? SeatCollectionViewCell else { return UICollectionViewCell() }
        
        var combined = [String]()
        
        a.forEach { letter in
            b.forEach { number in
                combined.append("\(letter)\(number)")
            }
        }
        
        let value = combined[indexPath.row]
        
        cell.textLabel.text = value
        
        if selectedSeats.contains(indexPath.row) {
            cell.contentView.backgroundColor = UIColor(named: "47CFFF")
        } else {
            cell.contentView.backgroundColor = UIColor.clear
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SeatCollectionViewCell else { return }
        
        if selectedSeats.contains(indexPath.row) {
            selectedSeats.remove(indexPath.row)
            collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            selectedSeats.insert(indexPath.row)
        }
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        selectedSeats.remove(indexPath.row)
        collectionView.reloadItems(at: [indexPath])
    }
}