//
//  SecureStore.swift
//  Cafe Bazaar
//
//  Created by Farshad Jahanmanesh on 12/19/19.
//  Copyright © 2019 Farshad Jahanmanesh. All rights reserved.
//

import Foundation

class SecureDataStore: DataStore {
	private var keychain = Keychain.shared
	func set<Value>(data: Value, for key: PersistentManager.Key) where Value : Decodable, Value : Encodable {
		let container = PersistentManager.WrapperObject<Value>.init(value: data)
		guard let value = try? JSONEncoder().encode(container) else {
			fatalError("Value is not encodable.")
		}
		keychain[key.rawValue] = value
	}
	
	func get<Value>(for key: PersistentManager.Key) -> Value? where Value : Decodable, Value : Encodable {
		guard let value = keychain[key.rawValue] ,let model = try? JSONDecoder().decode(PersistentManager.WrapperObject<Value>.self, from: value) else {
			return nil
		}
		return model.value
	}
	
	func remove(for key:  PersistentManager.Key) {
		keychain.delete(withKey: key.rawValue)
	}
}

fileprivate class Keychain {
    
    open var loggingEnabled = false
    
    private init() {}
    public static let shared = Keychain()
    
    open subscript(key: String) -> Data? {
        get {
            return load(withKey: key)
        } set {
            DispatchQueue.global().sync(flags: .barrier) {
                self.save(newValue, forKey: key)
            }
        }
    }
    
    private func save(_ objectData: Data?, forKey key: String) {
        let query = keychainQuery(withKey: key)
        if SecItemCopyMatching(query, nil) == noErr {
            if let dictData = objectData {
                let status = SecItemUpdate(query, NSDictionary(dictionary: [kSecValueData: dictData]))
                logPrint("Update status: ", status)
            } else {
                let status = SecItemDelete(query)
                logPrint("Delete status: ", status)
            }
        } else {
            if let dictData = objectData {
                query.setValue(dictData, forKey: kSecValueData as String)
                let status = SecItemAdd(query, nil)
                logPrint("Update status: ", status)
            }
        }
    }
    
    private func load(withKey key: String) -> Data? {
        let query = keychainQuery(withKey: key)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnAttributes as String)
        
        var result: CFTypeRef?
        let status = SecItemCopyMatching(query, &result)
        
        guard
            let resultsDict = result as? NSDictionary,
            let resultsData = resultsDict.value(forKey: kSecValueData as String) as? Data,
            status == noErr
            else {
                logPrint("Load status: ", status)
                return nil
        }
        return resultsData
    }
	
	func delete(withKey key: String){
        let query = keychainQuery(withKey: key)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        query.setValue(kCFBooleanTrue, forKey: kSecReturnAttributes as String)
        SecItemDelete(query)
    }
    
    
    private func keychainQuery(withKey key: String) -> NSMutableDictionary {
        let result = NSMutableDictionary()
        result.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
        result.setValue(key, forKey: kSecAttrService as String)
        result.setValue(kSecAttrAccessibleAlwaysThisDeviceOnly, forKey: kSecAttrAccessible as String)
        return result
    }
    
    private func logPrint(_ items: Any...) {
        if loggingEnabled {
            print(items)
        }
    }
}
