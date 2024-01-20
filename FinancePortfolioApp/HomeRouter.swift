// 
//  HomeRouter.swift
//  FinancePortfolioApp
//
//  Created by Rahmannur Rizki Syahputra on 18/01/24.
//

import Data
import UIKit

class HomeRouter: HomePresenterToRouter {
	
     public func createHomeModule() -> UIViewController {
         let view: UIViewController & HomePresenterToView = HomeVC()
         let presenter: HomeViewToPresenter & HomeInteractorToPresenter = HomePresenter()
		 let interactor: HomePresenterToInteractor = HomeInteractor(localJsonRepository: LocalJsonDataRepository.shared)
         let router: HomePresenterToRouter = HomeRouter()
        
         view.presenter = presenter
         presenter.view = view
         presenter.router = router
         presenter.interactor = interactor
         interactor.presenter = presenter
        
         return view
     }
}
