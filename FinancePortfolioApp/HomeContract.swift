// 
//  HomeContract.swift
//  FinancePortfolioApp
//
//  Created by Rahmannur Rizki Syahputra on 18/01/24.
//

import UIKit
import Domain
import Foundation

// MARK: View -
protocol HomePresenterToView: AnyObject {
    var presenter: HomeViewToPresenter? { get set }
	
	func didSuccessGetTransactionDetail(model: [PortfolioUIModel])
	func didFailGetTransactionDetail(error: String)
}

// MARK: Interactor -
protocol HomePresenterToInteractor: AnyObject {
    var presenter: HomeInteractorToPresenter? { get set }
	
	func fetchPortfolioData(Bundle: Bundle, fileName: String)
}

// MARK: Router -
protocol HomePresenterToRouter: AnyObject {
	var detailPageRouter: DetailPresenterToRouter? { get set }
	
	func createHomeModule() -> UIViewController
	func routeToDetailPage(transactionData: PortfolioUIModel, navigationController: UINavigationController?)
}

// MARK: Presenter -
protocol HomeViewToPresenter: AnyObject {
    var view: HomePresenterToView? { get set }
    var interactor: HomePresenterToInteractor? { get set }
    var router: HomePresenterToRouter? { get set }
	
	func getTransactionData(Bundle: Bundle, filename: String)
	func routeToDetail(transactionData: PortfolioUIModel, navigationController: UINavigationController?)
}

protocol HomeInteractorToPresenter: AnyObject {
	func didSuccessFetchTransactionData(data: [TransactionData])
	func didFailFetchPortfolioModel(error: CustomError)
}
