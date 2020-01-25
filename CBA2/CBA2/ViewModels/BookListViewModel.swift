//
//  BookListViewModel.swift
//  Cafe Bazaar
//
//  Created by Farshad Jahanmanesh on 12/21/19.
//  Copyright © 2019 Farshad Jahanmanesh. All rights reserved.
//

import Foundation

protocol BookListViewModel {
	// list of books
	var bookList: Live<[BookModel]> {get}
	
	// gets new books
	func refreshBookList()
	func createNewBook()
	func showToDetails(of book: BookModel)
}

class DefaultBookListViewModel: ViewModel, BookListViewModel {
	var bookList: Live<[BookModel]> = .init(startWith: [])
	private let repo: BooksApi
	private let coordinator: BookCordinator
	
	func refreshBookList() {
		self.repo.bookList() {[weak self] (result) in
			if case let .success(data) = result {
				self?.bookList.value = data
			}
		}
	}
	
	init(repo:BooksApi,  coordinator: BookCordinator) {
		self.repo = repo
		self.coordinator = coordinator
	}
	
	func createNewBook() {
		self.coordinator.coordinateToAddBook()
	}
	
	func showToDetails(of book: BookModel) {
		self.coordinator.coordinateToDetails(of: book)
	}
}
