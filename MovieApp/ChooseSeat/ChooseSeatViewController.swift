//
//  ChooseSeatViewController.swift
//  MovieApp
//
//  Created by Cengizhan Tomak on 14.07.2023.
//

import UIKit

protocol ChooseSeatDisplayLogic: AnyObject {
    func displayTickets(viewModel: ChooseSeatModels.FetchChooseSeat.ViewModel)
    func displayFetchedMovie(viewModel: ChooseSeatModels.FetchChooseSeat.ViewModel)
    func displayUpdatedViewComponents(selectedSeats: [String], totalAmount: Double)
    func displaySeatPrice()
}

final class ChooseSeatViewController: UIViewController {
    
    var interactor: ChooseSeatBusinessLogic?
    var router: (ChooseSeatRoutingLogic & ChooseSeatDataPassing)?
    
    // MARK: - Outlet
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var seatLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Properties
    var displayedTickets: [ChooseSeatModels.FetchChooseSeat.ViewModel.DisplayedTicket] = []
    var displayedSeatData = ChooseSeatModels.FetchChooseSeat.SeatDataModel.SeatData()
    
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
        commonSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkSeatsAvailability()
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
    
    private func commonSetup() {
        fetchTickets()
        getMovie()
        setupCollectionView()
        setupContinueButton()
    }
    
    private func fetchTickets() {
        interactor?.fetchTickets()
    }
    
    private func getMovie() {
        interactor?.getMovie()
    }
    
    private func setupContinueButton() {
        continueButton.isEnabled = false
        continueButton.backgroundColor = .systemGray
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(.init(nibName: Constants.CellIdentifiers.seatCell, bundle: .main), forCellWithReuseIdentifier: Constants.CellIdentifiers.seatCell)
        collectionView.collectionViewLayout = getCompositionalLayout()
        collectionView.allowsMultipleSelection = true
    }
    
    private func checkSeatsAvailability() {
        if displayedSeatData.unavailableSeats.count >= displayedSeatData.seat.count * displayedSeatData.row.count {
            UIAlertHelper.shared.showAlert(
                title: "Dikkat",
                message: "Tüm koltuklar dolu!",
                buttonTitle: "Tamam",
                on: self,
                buttonAction: {
                    self.router?.routeToBack()
                })
        }
    }
    
    // MARK: - Action
    @IBAction func continueButtonTapped(_ sender: Any) {
        interactor?.selectedSeatPrice(seat: displayedSeatData.selectedSeats, price: displayedSeatData.totalAmount)
    }
}

// MARK: - DisplayLogic
extension ChooseSeatViewController: ChooseSeatDisplayLogic {
    func displayTickets(viewModel: ChooseSeatModels.FetchChooseSeat.ViewModel) {
        displayedTickets = viewModel.displayedTickets ?? []
    }
    
    func displayFetchedMovie(viewModel: ChooseSeatModels.FetchChooseSeat.ViewModel) {
        let customView = NavigationCustomView(frame: CGRect(x: 0, y: 0, width: 250, height: 38))
        customView.setupView(viewModel: viewModel)
        navigationItem.titleView = customView
        
        displayedSeatData.unavailableSeats = interactor?.filterUnavailableSeats(seatFilter: displayedTickets) ?? []
        
        collectionView.reloadData()
    }
    
    func displayUpdatedViewComponents(selectedSeats: [String], totalAmount: Double) {
        seatLabel.text = selectedSeats.joined(separator: ", ") + (selectedSeats.isEmpty ? "" : " SELECTED")
        displayedSeatData.totalAmount = totalAmount
        priceLabel.text = "$ " + String(format: "%.2f", displayedSeatData.totalAmount)
        
        if selectedSeats.isEmpty {
            continueButton.isEnabled = false
            continueButton.backgroundColor = .systemGray
        } else {
            continueButton.isEnabled = true
            continueButton.backgroundColor = UIColor(named: "buttonRed")
        }
    }
    
    func displaySeatPrice() {
        router?.routeToPayment()
    }
}

// MARK: - CompositionalLayout
extension ChooseSeatViewController {
    private func getCompositionalLayout() -> UICollectionViewLayout {
        
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

// MARK: - UICollectionView
extension ChooseSeatViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedSeatData.row.count * displayedSeatData.seat.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.seatCell, for: indexPath) as? SeatCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let value = interactor?.getSeatValue(for: indexPath, row: displayedSeatData.row, seat: displayedSeatData.seat) ?? ""
        cell.textLabel.text = value
        cell.isSelected = cell.isSelected
        
        if displayedSeatData.unavailableSeats.contains(value) {
            cell.isUserInteractionEnabled = false
            cell.contentView.backgroundColor = .lightGray
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if displayedSeatData.selectedSeats.count >= 10 {
            collectionView.deselectItem(at: indexPath, animated: true)
            
            UIAlertHelper.shared.showAlert(
                title: "Seat Selection Limit Reached",
                message: "You can select up to 10 seats only.",
                buttonTitle: "OK",
                on: self)
        } else {
            guard let cell = collectionView.cellForItem(at: indexPath) as? SeatCollectionViewCell else { return }
            displayedSeatData.selectedSeats.append(cell.textLabel.text ?? "")
            interactor?.updateViewComponents(displayedSeatData: displayedSeatData)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? SeatCollectionViewCell else { return }
        if let index = displayedSeatData.selectedSeats.firstIndex(of: cell.textLabel.text ?? "") {
            displayedSeatData.selectedSeats.remove(at: index)
            interactor?.updateViewComponents(displayedSeatData: displayedSeatData)
        }
    }
}
