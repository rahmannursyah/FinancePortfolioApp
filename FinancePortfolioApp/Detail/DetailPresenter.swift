//
//  DetailPresenter.swift
//  FinancePortfolioApp
//
//  Created by Rahmannur Rizki Syahputra on 20/01/24.
//

import Domain
import Foundation

class DetailPresenter: DetailViewToPresenter {
    weak var view: DetailPresenterToView?
    var interactor: DetailPresenterToInteractor?
    var router: DetailPresenterToRouter?
	var transactionDetailData: PortfolioUIModel
	
	init(transactionDetailData: PortfolioUIModel) {
		self.transactionDetailData = transactionDetailData
	}
}

extension DetailPresenter: DetailInteractorToPresenter {
    
}
