//
//  HomePresenter.swift
//  FinancePortfolioApp
//
//  Created by Rahmannur Rizki Syahputra on 18/01/24.
//

import CommonExtension
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
		var transactionPercentage: [Double] = []
		var transactionNominal: [Double] = []
		
		data.forEach { transactionData in
			transactionNames.append(transactionData.label)
			transactionPercentage.append(transactionData.percentage.toDouble())
			transactionData.data.forEach { transactionDetail in
				transactionNominal.append(transactionDetail.nominal)
			}
		}
		
		view?.didSuccessGetTransactionDetail(name: transactionNames, percentage: transactionPercentage, nominal: transactionNominal)
	}
	
	func didFailFetchPortfolioModel(error: Domain.CustomError) {
		view?.didFailGetTransactionDetail(error: error.description)
	}
	
    
}
