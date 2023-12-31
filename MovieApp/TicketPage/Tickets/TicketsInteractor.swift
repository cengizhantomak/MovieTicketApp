//
//  TicketsInteractor.swift
//  MovieApp
//
//  Created by Cengizhan Tomak on 18.07.2023.
//

import Foundation
import UIKit

protocol TicketsBusinessLogic: AnyObject {
    func fetchTickets(request: TicketsModels.FetchTickets.Request)
    func deleteTicket(request: TicketsModels.DeleteTicket.Request)
}

protocol TicketsDataStore: AnyObject {
    
}

final class TicketsInteractor: TicketsBusinessLogic, TicketsDataStore {
    
    var presenter: TicketsPresentationLogic?
    var worker: TicketsWorkingLogic = TicketsWorker()
    
    func fetchTickets(request: TicketsModels.FetchTickets.Request) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let tickets = try worker.fetchTickets(using: context)
            let response = TicketsModels.FetchTickets.Response(tickets: tickets)
            presenter?.presentTickets(response: response)
        } catch {
            print("Failed to fetch tickets: \(error)")
        }
    }
    
    func deleteTicket(request: TicketsModels.DeleteTicket.Request) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            try worker.deleteTicket(withId: request.ticketId, using: context)
            fetchTickets(request: TicketsModels.FetchTickets.Request())
        } catch {
            print("Failed to delete ticket: \(error)")
        }
    }
}
