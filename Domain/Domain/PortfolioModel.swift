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
