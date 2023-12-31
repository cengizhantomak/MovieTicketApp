//
//  MyBankCardsPresenter.swift
//  MovieApp
//
//  Created by Cengizhan Tomak on 21.07.2023.
//

import Foundation

protocol MyBankCardsPresentationLogic: AnyObject {
    func presentBankCards(response: MyBankCardsModels.FetchMyBankCards.Response)
//    func presentSelectBankCard()
    func presentOriginViewController(originViewController: String?)
}

final class MyBankCardsPresenter: MyBankCardsPresentationLogic {
    
    weak var viewController: MyBankCardsDisplayLogic?
    
    func presentBankCards(response: MyBankCardsModels.FetchMyBankCards.Response) {
        let displayedBankCards = response.bankCards.compactMap { bankCard in
            MyBankCardsModels.FetchMyBankCards.ViewModel.DisplayedBankCard(
                cardNumber: bankCard.cardNumber,
                cardHolder: bankCard.nameCard,
                cardExpires: bankCard.dateExpire,
                cvv: bankCard.cvv,
                id: bankCard.id)
        }
        
        let viewModel = MyBankCardsModels.FetchMyBankCards.ViewModel(displayedBankCard: displayedBankCards)
        viewController?.displayBankCards(viewModel: viewModel)
    }
    
    func presentDeleteBankCardResult(response: MyBankCardsModels.DeleteBankCard.Response) {
        let viewModel = MyBankCardsModels.DeleteBankCard.ViewModel(success: response.success)
        viewController?.displayDeleteBankCardResult(viewModel: viewModel)
    }
    
//    func presentSelectBankCard() {
//        viewController?.displaySelectBankCard()
//    }
    
    func presentOriginViewController(originViewController: String?) {
        viewController?.displayOriginViewController(viewModel: originViewController)
    }
}
