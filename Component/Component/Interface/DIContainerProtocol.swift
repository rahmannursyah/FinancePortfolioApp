//
//  DIContainerProtocol.swift
//  Component
//
//  Created by Rahmannur Rizki Syahputra on 21/01/24.
//

import Foundation

protocol DIContainerProtocol {
  func register<Service>(type: Service.Type, component: Any)
  func resolve<Service>(type: Service.Type) -> Service?
}
