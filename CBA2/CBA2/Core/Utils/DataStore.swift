//
//  DataStore.swift
//  Cafe Bazaar
//
//  Created by Farshad Jahanmanesh on 12/19/19.
//  Copyright © 2019 Farshad Jahanmanesh. All rights reserved.
//

import Foundation
protocol DataStore: class {
	func set<Value: Codable>(data: Value, for key:  PersistentManager.Key)
	func get<Value>(for key:  PersistentManager.Key)->Value? where Value: Codable
	func remove(for key:  PersistentManager.Key)
}
