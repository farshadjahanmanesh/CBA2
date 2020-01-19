//
//  DataStore+Ext.swift
//  Cafe Bazaar
//
//  Created by Farshad Jahanmanesh on 12/21/19.
//  Copyright © 2019 Farshad Jahanmanesh. All rights reserved.
//

import Foundation
extension DataStore {
	//	suger subscript
	subscript<Value:Codable>(key: PersistentManager.Key)->Value? {
		get {
			return get(for: key)
		}
		set {
			set(data: newValue , for: key)
		}
	}
}
