//
//  HomePresenter.swift
//  FinancePortfolioApp
//
//  Created by Rahmannur Rizki Syahputra on 18/01/24.
//

import Domain
import Foundation

class HomePresenter: HomeViewToPresenter {
    weak var view: HomePresenterToView?
    var interactor: HomePresenterToInteractor?
    var router: HomePresenterToRouter?
	
	func getTransactionData(Bundle: Bundle, filename: String) {
		interactor?.fetchPortfolioData(Bundle: Bundle, fileName: filename)
	}
}

extension HomePresenter: HomeInteractorToPresenter {
	func didSuccessFetchTransactionData(data: [TransactionData]) {
		var transactionNames: [String] = []
		var transactionPercentage: [Int] = []
		data.forEach { tranData in
			transactionNames.append(tranData.label)
			transactionPercentage.append(Int(tranData.percentage) ?? 0)
		}
		
		view?.didSuccessGetTransactionDetail(name: transactionNames, percentage: transactionPercentage)
	}
	
	func didFailFetchPortfolioModel(error: Domain.CustomError) {
		view?.didFailGetTransactionDetail(error: error.description)
	}
	
    
}
