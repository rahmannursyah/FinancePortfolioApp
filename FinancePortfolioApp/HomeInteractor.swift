// 
//  HomeInteractor.swift
//  FinancePortfolioApp
//
//  Created by Rahmannur Rizki Syahputra on 18/01/24.
//

import Data
import Domain
import Foundation
import SwiftyJSON

class HomeInteractor: HomePresenterToInteractor {
    weak var presenter: HomeInteractorToPresenter?
	let localJsonRepository: JsonDataRepository
	
	init(localJsonRepository: JsonDataRepository) {
		self.localJsonRepository = localJsonRepository
	}
	
	func fetchPortfolioData(Bundle: Bundle, fileName: String) {
		let parsedJsonData = localJsonRepository.parseFromJsonFile(Bundle: Bundle, fileName: fileName)
		switch parsedJsonData {
		case .success(let data):
			decodedPortfolioModel(data: data)
		case .failure(let failure):
			print(failure.localizedDescription)
		}
	}
	
	func decodedPortfolioModel(data: JSON) {
		do {
			let model = try localJsonRepository.decodeJsonDataToModel(data: data.arrayValue[0].rawData(), to: PortfolioModel.self)
			switch model {
			case .success(let model):
				presenter?.didSuccessFetchTransactionData(data: model.data)
			case .failure(let error):
				presenter?.didFailFetchPortfolioModel(error: error)
			}
		} catch {
			presenter?.didFailFetchPortfolioModel(error: CustomError(description: error.localizedDescription, errorCode: 999))
		}
		
	}
}
