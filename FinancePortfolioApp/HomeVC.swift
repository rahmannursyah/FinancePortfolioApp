//
//  HomeVC.swift
//  FinancePortfolioApp
//
//  Created by Rahmannur Rizki Syahputra on 18/01/24.
//

import UIKit
import Data
import DGCharts
import Domain

class HomeVC: UIViewController {
    var presenter: HomeViewToPresenter?

	private lazy var pieChartView: PieChartView = {
		let pieView = PieChartView()
		pieView.translatesAutoresizingMaskIntoConstraints = false
		return pieView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
		setupView()
		setupConstraints()
		
		presenter?.getTransactionData(Bundle: Bundle(identifier: "com.nur.Data")!, filename: "portfolioData")
	}

	private func setupView() {
		view.backgroundColor = .white
		view.addSubview(pieChartView)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			pieChartView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			pieChartView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height / 2),
			pieChartView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			pieChartView.widthAnchor.constraint(equalTo: view.widthAnchor)
		])
	}
	
	@objc private func didTappedBtn() {
		self.navigationController?.pushViewController(SecondViewController(), animated: true)
	}
}

extension HomeVC: HomePresenterToView {
	func didSuccessGetTransactionDetail(name: [String], percentage: [Double], nominal: [Double]) {
		print(name)
		print(percentage)
		print(nominal)
		
		// 1. Set ChartDataEntry
		var dataEntries: [ChartDataEntry] = []
		for i in 0..<name.count {
			let dataEntry = PieChartDataEntry(value: percentage[i], label: name[i], data: name[i] as AnyObject)
			dataEntries.append(dataEntry)
		}
		// 2. Set ChartDataSet
		let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
		pieChartDataSet.colors = [UIColor.red, UIColor.green, UIColor.yellow, UIColor.blue]
		pieChartDataSet.valueColors = [UIColor.black]
		pieChartDataSet.entryLabelColor = UIColor.black
		// 3. Set ChartData
		let pieChartData = PieChartData(dataSet: pieChartDataSet)
		let format = NumberFormatter()
		format.numberStyle = .none
		let formatter = DefaultValueFormatter(formatter: format)
		pieChartData.setValueFormatter(formatter)
		// 4. Assign it to the chart’s data
		pieChartView.data = pieChartData
	}
	
	func didFailGetTransactionDetail(error: String) {
		print(error)
	}
}
