// 
//  HomeRouter.swift
//  FinancePortfolioApp
//
//  Created by Rahmannur Rizki Syahputra on 18/01/24.
//

import Component
import Data
import Domain
import UIKit

class HomeRouter: HomePresenterToRouter {
	var detailPageRouter: DetailPresenterToRouter?
	
     public func createHomeModule() -> UIViewController {
         let view: UIViewController & HomePresenterToView = HomeVC()
         let presenter: HomeViewToPresenter & HomeInteractorToPresenter = HomePresenter()
		 let interactor: HomePresenterToInteractor = HomeInteractor(localJsonRepository: DIContainer.shared.resolve(type: JsonDataRepository.self)!)
         let router: HomePresenterToRouter = HomeRouter()
        
         view.presenter = presenter
         presenter.view = view
         presenter.router = router
         presenter.interactor = interactor
         interactor.presenter = presenter
		 router.detailPageRouter = DetailRouter()
        
         return view
     }
	
	func routeToDetailPage(transactionData: PortfolioUIModel, navigationController: UINavigationController?) {
		let detailVC = detailPageRouter?.createDetailModule(transactionData: transactionData)
		guard let detailVC = detailVC else { return }
		navigationController?.pushViewController(detailVC, animated: true)
	}
	
}
