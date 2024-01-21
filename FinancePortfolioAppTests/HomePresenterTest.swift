//
//  HomePresenterTest.swift
//  FinancePortfolioAppTests
//
//  Created by Rahmannur Rizki Syahputra on 21/01/24.
//

import Quick
import Nimble

@testable import FinancePortfolioApp
@testable import Data
@testable import Domain

class HomePresenterTest: QuickSpec {
	override class func spec() {
		var sut: HomePresenter!
		
		beforeEach {
			sut = HomePresenter()
			sut.interactor = HomeInteractor(localJsonRepository: LocalJsonDataRepository.shared)
		}
		
		afterEach {
			sut = nil
		}
		
		describe("I want to look at my portfolio data this month") {
			context("I open the home page") {
				it("Should return al of my portfolio data this month successfully") {
					sut.getTransactionData(Bundle: Bundle(identifier: Constants.ModuleBundle.Data)!, filename: "portfolioData")
					expect(sut.transactionDetails.count).toEventuallyNot(beNil())
				}
			}
		}
	}
}
