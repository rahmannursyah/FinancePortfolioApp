//
//  LocalJsonDataRepository.swift
//  Data
//
//  Created by Rahmannur Rizki Syahputra on 20/01/24.
//

import Domain
import Foundation
import SwiftyJSON

public protocol JsonDataRepository {
	func parseFromJsonFile(Bundle: Bundle, fileName: String) -> Result<JSON, CustomError>
	func decodeJsonDataToModel<T: Codable>(data: Data, to: T.Type) -> Result<T, CustomError>
}

public struct LocalJsonDataRepository: JsonDataRepository {
	public static let shared = LocalJsonDataRepository()
	
	private init() {
		/// Private initializers to ensure singleton for this struct
	}
	
	public func parseFromJsonFile(Bundle: Bundle, fileName: String) -> Result<JSON, CustomError> {
		if let path = Bundle.path(forResource: fileName, ofType: "json") {
			do {
				let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
				let jsonObj = try JSON(data: data)
				return .success(jsonObj)
			} catch let error {
				return .failure(CustomError(description: error.localizedDescription, errorCode: 997))
			}
		} else {
			return .failure(CustomError(description: "Invalid filename/path", errorCode: 999))
		}
	}
	
	public func decodeJsonDataToModel<T>(data: Data, to: T.Type) -> Result<T, CustomError> where T : Decodable, T : Encodable {
		do {
			let decodedModel = try JSONDecoder().decode(T.self, from: data)
			return .success(decodedModel)
		} catch {
			return .failure(CustomError(description: error.localizedDescription, errorCode: 998))
		}
	}
}
