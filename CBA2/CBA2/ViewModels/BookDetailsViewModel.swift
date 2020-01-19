//
//  BookDetailsViewModel.swift
//  Cafe Bazaar
//
//  Created by Farshad Jahanmanesh on 12/23/19.
//  Copyright © 2019 Farshad Jahanmanesh. All rights reserved.
//

import Foundation

protocol BookDetailsViewModel {
	var book: BookModel {get}
}

class DefaultBookDetailsViewModel: ViewModel, BookDetailsViewModel {
	private let repo: BooksApi
	var book: BookModel

	init(store: DataStore,repo:BooksApi,  coordinator: BookCordinator, book: BookModel) {
		self.repo = repo
		self.book = book
	}
}
