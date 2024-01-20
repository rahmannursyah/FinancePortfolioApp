//
//  CustomErrorModel.swift
//  Domain
//
//  Created by Rahmannur Rizki Syahputra on 20/01/24.
//

import Foundation

public struct CustomError: Swift.Error {
	public let description: String
	public let errorCode: Int
	
	public var localizedDescription: String {
		return NSLocalizedString(description, comment: "")
	}
	
	public init(description: String, errorCode: Int) {
		self.description = description
		self.errorCode = errorCode
	}
}
