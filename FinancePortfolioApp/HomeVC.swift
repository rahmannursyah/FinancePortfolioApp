//
//  HomeVC.swift
//  FinancePortfolioApp
//
//  Created by Rahmannur Rizki Syahputra on 18/01/24.
//

import UIKit
import CommonExtension
import Data
import DGCharts
import Domain

class HomeVC: UIViewController {
    var presenter: HomeViewToPresenter?

	private lazy var pieChartView: PieChartView = {
		let pieView = PieChartView()
		pieView.delegate = self
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
			pieChartView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
			pieChartView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
			pieChartView.widthAnchor.constraint(equalTo: view.widthAnchor)
		])
	}
	
	private func setupPieChartData(data: [PortfolioUIModel]) {
		// 1. Set ChartDataEntry
		var dataEntries: [ChartDataEntry] = []
		for i in 0..<data.count {
			let dataEntry = PieChartDataEntry(value: data[i].percentage,
											  label: "\(data[i].label)\n\(data[i].totalTransactions.formatted())",
											  data: data[i])
			dataEntries.append(dataEntry)
		}
		// 2. Set ChartDataSet
		let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: "")
		pieChartDataSet.colors = colorsOfCharts(numbersOfColor: dataEntries.count)
		pieChartDataSet.valueColors = [UIColor.clear]
		pieChartDataSet.entryLabelColor = UIColor.black
		pieChartDataSet.entryLabelFont = UIFont.boldSystemFont(ofSize: 14)
		// 3. Set ChartData
		let pieChartData = PieChartData(dataSet: pieChartDataSet)
		let format = NumberFormatter()
		format.numberStyle = .none
		let formatter = DefaultValueFormatter(formatter: format)
		pieChartData.setValueFormatter(formatter)
		// 4. Assign it to the chart’s data
		pieChartView.data = pieChartData
		pieChartView.centerText = "Portfolio Data"
	}
}

extension HomeVC: ChartViewDelegate {
	func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
		presenter?.routeToDetail(transactionData: entry.data as! PortfolioUIModel, navigationController: self.navigationController)
	}
}

extension HomeVC: HomePresenterToView {
	func didSuccessGetTransactionDetail(model: [PortfolioUIModel]) {
		setupPieChartData(data: model)
	}
	
	func didFailGetTransactionDetail(error: String) {
		print(error)
	}
}
