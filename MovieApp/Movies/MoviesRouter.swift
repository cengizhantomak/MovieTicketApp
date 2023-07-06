//
//  MoviesRouter.swift
//  MovieApp
//
//  Created by Cengizhan Tomak on 26.06.2023.
//

import Foundation
import UIKit

protocol MoviesRoutingLogic: AnyObject {
    func routeToMovieDetails()
}

protocol MoviesDataPassing: AnyObject {
    var dataStore: MoviesDataStore? { get }
}

final class MoviesRouter: MoviesRoutingLogic, MoviesDataPassing {
    
    weak var viewController: MoviesViewController?
    var dataStore: MoviesDataStore?
    
    func routeToMovieDetails() {
        let storyboard = UIStoryboard(name: "MovieDetails", bundle: nil)
        
        guard let destinationVC = storyboard.instantiateViewController(withIdentifier: "MovieDetailsViewController") as? MovieDetailsViewController,
        let dataStore else { return }
        
        destinationVC.router?.dataStore?.selectedMovieID = dataStore.selectedMovieId
        destinationVC.loadViewIfNeeded()
        viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }
}
