//
//  DetailVC.swift
//  FinancePortfolioApp
//
//  Created by Rahmannur Rizki Syahputra on 20/01/24.
//

import CommonExtension
import UIKit

class DetailVC: UIViewController, DetailPresenterToView {
    var presenter: DetailViewToPresenter?

	private lazy var titleLbl: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 17)
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var totalLbl: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var totalTranscationLbl: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var transactionBreakdownLbl: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	private lazy var transactionTableView: UITableView = {
		let tableView = UITableView()
		tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.delegate = self
		tableView.dataSource = self
		return tableView
	}()
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		setupView()
		setupConstraints()
    }
	
	private func setupView() {
		view.backgroundColor = .white
		self.navigationItem.title = "Transaction Detail"
		titleLbl.text = presenter?.transactionDetailData.label
		totalLbl.text = "Total transactions this month"
		transactionBreakdownLbl.text = "Transaction breakdown this month"
		totalTranscationLbl.text = "Rp.\(presenter?.transactionDetailData.totalTransactions.formatted() ?? "")"
		transactionTableView.reloadData()
		
		view.addSubview(titleLbl)
		view.addSubview(totalLbl)
		view.addSubview(totalTranscationLbl)
		view.addSubview(transactionBreakdownLbl)
		view.addSubview(transactionTableView)
	}
	
	private func setupConstraints() {
		NSLayoutConstraint.activate([
			titleLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			titleLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
			titleLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			
			totalLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			totalLbl.topAnchor.constraint(equalTo: titleLbl.bottomAnchor, constant: 24),
			totalLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			
			totalTranscationLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			totalTranscationLbl.topAnchor.constraint(equalTo: totalLbl.bottomAnchor, constant: 8),
			totalTranscationLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			
			transactionBreakdownLbl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
			transactionBreakdownLbl.topAnchor.constraint(equalTo: totalTranscationLbl.bottomAnchor, constant: 24),
			transactionBreakdownLbl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
			
			transactionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
			transactionTableView.topAnchor.constraint(equalTo: transactionBreakdownLbl.bottomAnchor, constant: 8),
			transactionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
			transactionTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24)
		])
	}
}

extension DetailVC: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.transactionDetailData.transactionDateNominal.count ?? 0
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .value1, reuseIdentifier: "Cell")
		cell.textLabel?.text = presenter?.transactionDetailData.transactionDateNominal[indexPath.row].nominal.formatted()
		cell.detailTextLabel?.text = presenter?.transactionDetailData.transactionDateNominal[indexPath.row].trx_date
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
