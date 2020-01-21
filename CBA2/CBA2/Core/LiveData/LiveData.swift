//
//  LiveData.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/19/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import Foundation
class Live<T> {
    typealias CompletionHandler = ((T) -> Void)

    var value : T {
        didSet {
            self.notifyObservers(self.observers)
        }
    }

    private var observers : [CompletionHandler] = []
    init(value: T) {
        self.value = value
    }
	
	func listen(_ completion: @escaping CompletionHandler) {
		self.observers.append(completion)
	}

    private func notifyObservers(_ listeners: [CompletionHandler]) {
        listeners.forEach({ $0(value) })
    }

    deinit {
		print("\(self) deinited.")
        observers.removeAll()
    }
}

