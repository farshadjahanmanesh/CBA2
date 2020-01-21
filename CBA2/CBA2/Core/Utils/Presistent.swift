//
//  Presistent.swift
//  Cafe Bazaar
//
//  Created by Farshad Jahanmanesh on 12/23/19.
//  Copyright © 2019 Farshad Jahanmanesh. All rights reserved.
//

import Foundation
struct PersistentManager {
	struct WrapperObject<Value: Codable>: Codable {
		let value: Value
	}
	struct Key: RawRepresentable, Hashable {
		var rawValue: String
		init(rawValue: String) {
			self.rawValue = rawValue
		}
	}
}
