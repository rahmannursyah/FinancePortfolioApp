// 
//  DetailRouter.swift
//  FinancePortfolioApp
//
//  Created by Rahmannur Rizki Syahputra on 20/01/24.
//

import Domain
import UIKit

class DetailRouter: DetailPresenterToRouter {
     public func createDetailModule(transactionData: PortfolioUIModel) -> UIViewController {
         let view: UIViewController & DetailPresenterToView = DetailVC()
		 let presenter: DetailViewToPresenter & DetailInteractorToPresenter = DetailPresenter(transactionDetailData: transactionData)
         let interactor: DetailPresenterToInteractor = DetailInteractor()
         let router: DetailPresenterToRouter = DetailRouter()
        
         view.presenter = presenter
         presenter.view = view
         presenter.router = router
         presenter.interactor = interactor
         interactor.presenter = presenter
        
         return view
     }
}
