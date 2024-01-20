//
//  String.swift
//  CommonExtension
//
//  Created by Rahmannur Rizki Syahputra on 20/01/24.
//

import Foundation

public extension String {
	/// Func to easily convert string to double
	func toDouble() -> Double {
		if let doubleValue = Double(self) {
			return doubleValue
		} else {
			return 0
		}
	}
	
	/// Func to easily convert string to int
	func toInt() -> Int {
		if let intValue = Int(self) {
			return intValue
		} else {
			return 0
		}
	}
}
