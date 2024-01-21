//
//  DIContainer.swift
//  Component
//
//  Created by Rahmannur Rizki Syahputra on 21/01/24.
//

import Foundation

final public class DIContainer: DIContainerProtocol {

	public static let shared = DIContainer()
	
	private init() {}
	
	var services: [String: Any] = [:]
	
	public func register<Service>(type: Service.Type, component service: Any) {
		services["\(type)"] = service
	}
	
	public func resolve<Service>(type: Service.Type) -> Service? {
		return services["\(type)"] as? Service
	}
	
}
