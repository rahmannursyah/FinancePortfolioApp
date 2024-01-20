// 
//  DetailContract.swift
//  FinancePortfolioApp
//
//  Created by Rahmannur Rizki Syahputra on 20/01/24.
//

import Domain
import UIKit

// MARK: View -
protocol DetailPresenterToView: AnyObject {
    var presenter: DetailViewToPresenter? { get set }
}

// MARK: Interactor -
protocol DetailPresenterToInteractor: AnyObject {
    var presenter: DetailInteractorToPresenter? { get set }
}

// MARK: Router -
protocol DetailPresenterToRouter: AnyObject {
	func createDetailModule(transactionData: PortfolioUIModel) -> UIViewController
}

// MARK: Presenter -
protocol DetailViewToPresenter: AnyObject {
    var view: DetailPresenterToView? { get set }
    var interactor: DetailPresenterToInteractor? { get set }
    var router: DetailPresenterToRouter? { get set }
	var transactionDetailData: PortfolioUIModel { get set }
}

protocol DetailInteractorToPresenter: AnyObject {
}
