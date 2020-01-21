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
	func startReading()
	func stopReading()
	var readingTime: Live<Int>{get}
	var isReading: Live<Bool>{get}
}

class DefaultBookDetailsViewModel: ViewModel, BookDetailsViewModel {
	private let repo: BooksApi
	var book: BookModel
	var readingTime: Live<Int> = .init(startWith: 0)
	var isReading: Live<Bool> = .init(startWith: false)
	private var timer: Timer?
	
	init(repo:BooksApi,  coordinator: BookCordinator, book: BookModel) {
		self.repo = repo
		self.book = book
		isReading.value = book.isReading
		readingTime.value = Int(repo.isCurrentlyReading(book) ?? 0)
		if book.isReading {
			startTimer()
		}
	}
	
	private func startTimer() {
		guard timer == nil else {return}
		timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] _ in
			guard let self = self else {return}
			self.readingTime.value = self.readingTime.value + 1
		})
	}
	
	func startReading() {
		startTimer()
		self.isReading.value = true
		self.repo.startReading(book)
	}
	
	func stopReading() {
		self.isReading.value = false
		timer?.invalidate()
		timer = nil
		self.repo.stopReading(book)
	}
}
