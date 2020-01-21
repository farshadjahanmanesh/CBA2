//
//  NewBookViewModel.swift
//  Cafe Bazaar
//
//  Created by Farshad Jahanmanesh on 12/23/19.
//  Copyright © 2019 Farshad Jahanmanesh. All rights reserved.
//

import Foundation

protocol NewBookViewModel {
	func add(_ book: BookModel, _ then: ((Result<Void, Errors>) -> Void)?)
	var newBookAdded: Live<Bool> {get}
}

class DefaultNewBookViewModel: ViewModel, NewBookViewModel {
	private let repo: BooksApi
	var newBookAdded: Live<Bool>
	func add(_ book: BookModel, _ then: ((Result<Void, Errors>) -> Void)?) {
		self.repo.add(book) { [weak self] result in
			then?(result)
			self?.newBookAdded.value = true
		}
	}
	
	init(store: DataStore,repo:BooksApi,  coordinator: BookCordinator) {
		self.repo = repo
		newBookAdded = .init(value: true)
	}
}
