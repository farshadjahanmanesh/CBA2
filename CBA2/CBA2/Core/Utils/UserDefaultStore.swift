//
//  UserDefaultStore.swift
//  Cafe Bazaar
//
//  Created by Farshad Jahanmanesh on 12/19/19.
//  Copyright © 2019 Farshad Jahanmanesh. All rights reserved.
//

import Foundation
class UserDefaultStore: DataStore {
	
	func get<Value>(for key: PersistentManager.Key) -> Value? where Value : Decodable, Value : Encodable {
		guard let value = UserDefaults.standard.data(forKey: key.rawValue), let model = try? JSONDecoder().decode(PersistentManager.WrapperObject<Value>.self, from: value) else {
			return nil
		}
		return model.value
	}
	
	func set<Value>(data: Value, for key: PersistentManager.Key) where Value : Decodable, Value : Encodable {
		let container = PersistentManager.WrapperObject<Value>.init(value: data)
		guard let value = try? JSONEncoder().encode(container) else {
			fatalError("Value is not encodable.")
		}
		UserDefaults.standard.set(value, forKey: key.rawValue)
	}
	
	func remove(for key:  PersistentManager.Key) {
		UserDefaults.standard.removeObject(forKey: key.rawValue)
	}
}
