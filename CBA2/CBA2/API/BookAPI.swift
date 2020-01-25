//
//  BookAPI.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/19/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import Foundation
protocol BooksApi {
	// adds new book
	func add(_ book: BookModel, _ then: ((Result<Void, Errors>) -> Void)?)
	func add(_ book: BookModel)
	
	// list of all books
	func bookList(_ then: @escaping (Result<[BookModel], Errors>)->Void)
	
	// finds a book by its id
	func book(id: UUID,_ then: @escaping (Result<BookModel, Errors>)->Void)
	
	// start reading this book
	func startReading(_ book: BookModel)
	func stopReading(_ book: BookModel)
	
	
	/// check if a book is currently reading status, sends nil if book is not in reading state and if the book is in reading, will returns the total seconds that from the start date until now
	/// - Parameters:
	///   - book: book to check
	func isCurrentlyReading(_ book: BookModel)->Double?
}
