//
//  LiveData.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/19/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import Foundation

/// a class that keeps a list of callbacks (listeners) and notify them as it's value change with it's new value
/// sample:
///		let bookList: Live<[BookModel]> = Live<[BookModel]>(startWith: [])
///		// this will call eveytime `bookList.value` has new value
///		bookList.listen = {books in
///			// do something with books
///		}
class Live<T> {
    typealias CompletionHandler = ((T) -> Void)
	// value holder
    var value : T {
        didSet {
            self.notifyObservers(self.observers)
        }
    }
	// list of listeners
    private var observers : [CompletionHandler] = []
	
	// initial state
    init(startWith value: T) {
        self.value = value
    }
	
	// subscribes listener for listening for new changes
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

