//
//  PortfolioModel.swift
//  Domain
//
//  Created by Rahmannur Rizki Syahputra on 18/01/24.
//

import Foundation

public struct PortfolioModel: Codable {
	public let type: String
	public let data: [TransactionData]
	
}

public struct TransactionData: Codable {
	public let label: String
	public let percentage: String
	public let data: [TransactionDetail]
	
}

public struct TransactionDetail: Codable {
	public let trx_date: String
	public let nominal: Double
	
}

public struct PortfolioUIModel: Codable {
	public let label: String
	public let percentage: Double
	public let totalTransactions: Double
	public let transactionDateNominal: [TransactionDetail]
	
	public init(label: String, percentage: Double, totalTransactions: Double, transactionDateNominal: [TransactionDetail]) {
		self.label = label
		self.percentage = percentage
		self.totalTransactions = totalTransactions
		self.transactionDateNominal = transactionDateNominal
	}
}
