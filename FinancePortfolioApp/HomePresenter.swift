//
//  HomePresenter.swift
//  FinancePortfolioApp
//
//  Created by Rahmannur Rizki Syahputra on 18/01/24.
//

import CommonExtension
import Domain
import Foundation
import UIKit

class HomePresenter: HomeViewToPresenter {
    weak var view: HomePresenterToView?
    var interactor: HomePresenterToInteractor?
    var router: HomePresenterToRouter?
	var transactionDetails: [PortfolioUIModel] = []
	
	func getTransactionData(Bundle: Bundle, filename: String) {
		interactor?.fetchPortfolioData(Bundle: Bundle, fileName: filename)
	}
	
	func routeToDetail(transactionData: Domain.PortfolioUIModel, navigationController: UINavigationController?) {
		router?.routeToDetailPage(transactionData: transactionData, navigationController: navigationController)
	}
}

extension HomePresenter: HomeInteractorToPresenter {
	/// Format the API Model data into UIModel that'll be easily used by the screens
	func didSuccessFetchTransactionData(data: [TransactionData]) {
		var totalNominal: Double = 0
		
		data.forEach { transactionData in
			transactionData.data.forEach { detail in
				totalNominal += detail.nominal
			}
			transactionDetails.append( PortfolioUIModel(label: transactionData.label, percentage: transactionData.percentage.toDouble(), totalTransactions: totalNominal, transactionDateNominal: transactionData.data))
			totalNominal = 0
		}
		
		view?.didSuccessGetTransactionDetail(model: transactionDetails)
	}
	
	func didFailFetchPortfolioModel(error: Domain.CustomError) {
		view?.didFailGetTransactionDetail(error: error.description)
	}
	
    
}
