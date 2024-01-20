//
//  HomeVC.swift
//  FinancePortfolioApp
//
//  Created by Rahmannur Rizki Syahputra on 18/01/24.
//

import UIKit
import Data
import SwiftyJSON
import Domain

class HomeVC: UIViewController {
    var presenter: HomeViewToPresenter?

	private lazy var nextBtn: UIButton = {
		let btn = UIButton()
		btn.backgroundColor = .red
		btn.setTitle("Next VC", for: .normal)
		btn.addTarget(self, action: #selector(didTappedBtn), for: .touchUpInside)
		btn.translatesAutoresizingMaskIntoConstraints = false
		return btn
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		view.backgroundColor = .purple
		
		view.addSubview(nextBtn)
		NSLayoutConstraint.activate([
			nextBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			nextBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			nextBtn.widthAnchor.constraint(equalToConstant: 100)
		])
		
		presenter?.getTransactionData(Bundle: Bundle(identifier: "com.nur.Data")!, filename: "portfolioData")
	}

	@objc private func didTappedBtn() {
		self.navigationController?.pushViewController(SecondViewController(), animated: true)
	}
}

extension HomeVC: HomePresenterToView {
	func didSuccessGetTransactionDetail(name: [String], percentage: [Int]) {
		print(name)
		print(percentage)
	}
	
	func didFailGetTransactionDetail(error: String) {
		print(error)
	}
}
