//
//  BookListViewModel.swift
//  Cafe Bazaar
//
//  Created by Farshad Jahanmanesh on 12/21/19.
//  Copyright © 2019 Farshad Jahanmanesh. All rights reserved.
//

import Foundation
protocol BookListViewModel {
	var bookList: Live<[BookModel]> {get}
	func refreshBookList()
	func navigateNewBook()
}
class DefaultBookListViewModel: ViewModel, BookListViewModel {
	
	var bookList: Live<[BookModel]> = .init(value: [])
	private let repo: BooksApi
	private let coordinator: BookCordinator
	
	func refreshBookList() {
		self.repo.bookList() {[weak self] (result) in
			if case let .success(data) = result {
				self?.bookList.value = data
			}
		}
	}
	
	init(store: DataStore,repo:BooksApi,  coordinator: BookCordinator) {
		self.repo = repo
		self.coordinator = coordinator
	}
	
	func navigateNewBook() {
		self.coordinator.coordinateToAddBook()
	}
}
