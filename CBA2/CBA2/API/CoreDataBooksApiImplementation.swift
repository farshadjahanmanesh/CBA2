//
//  DefaultBooksApi.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/21/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import Foundation
import CoreData

struct CoreDataBooksApiImplementation: BooksApi {
	weak var database: CoreDatabase?
	init(database: CoreDatabase) {
		self.database = database
	}
	
	/// adds a book to database
	/// - Parameter book: book
	func add(_ book: BookModel) {
		self.add(book, nil)
	}
	
	/// adds a book to database and calls the `then` function
	/// - Parameters:
	///   - book: book to add
	///   - then: callback function
	func add(_ book: BookModel, _ then: ((Result<Void, Errors>) -> Void)? = nil) {
		guard let context = self.database?.context else {
			then?(.failure(.unknown))
			return
		}
		let entity = CDBook(context: context)
		entity.from(book)
		entity.id = UUID()
		context.insert(entity)
		
		do {
			try self.database?.context.save()
		} catch let error {
			then?(.failure(.init(rawValue: error.localizedDescription)))
		}
		then?(.success(()))
	}
	
	
	/// finds a list of books and delivers it to the callback function
	/// - Parameter then: callback function
	func bookList(_ then: @escaping (Result<[BookModel], Errors>)->Void)  {
		guard let context = self.database?.context else {return then(.failure(.unknown))}
		let request = NSFetchRequest<CDBook>(entityName: "Book")
		
		do {
			let books = try context.fetch(request)
			let array = books.map{$0.toLocalModel()}
			return then(.success(array))
		} catch let error {
			return then(.failure(.init(rawValue: error.localizedDescription)))
		}
	}
	
	
	/// finds the last orphan reading track of this book that its stopAt property is nil (the reading track that is not finished yet)
	/// - Parameter book: book to find its unfinished reading track
	private func findDanglingReading(_ book: CDBook) -> CDReadingTrack? {
		guard let reading = book.value(forKey: "danglingReading") as?  [CDReadingTrack], let danglingRead = reading.last  else {
			return nil
		}
		return danglingRead
	}
	
	/// finds the book that user is currently reading it
	private func lastReadingBook() -> CDBook? {
		guard let context = self.database?.context else { return nil }
		let fetchRequest = NSFetchRequest<CDBook>(entityName: "Book")
		
		fetchRequest.predicate = NSPredicate(format: "isReading = true")
		guard let books = try? context.fetch(fetchRequest), let book = books.first else {
			return nil
		}
		
		return book
	}
	
	
	/// indicates if a book is currently is in reading state or not
	/// - Parameter book: book to find the reading state of it
	func isCurrentlyReading(_ book: BookModel)->Double? {
		guard let id = book.id, let storedBook = getBook(id) , let danglingRead = findDanglingReading(storedBook) else {
			return nil
		}
		return Date().timeIntervalSince(danglingRead.startAt!)
	}
	
	/// starts reading the book. it at first check if this book has an unfinished reading track or not, if an unfinished reading track is found, it will stop it first and then create a new one. it sets the book isReading property to `true`
	func startReading(_ book: BookModel) {
		guard let context = self.database?.context else {
			assertionFailure("Where is my context")
			return
		}
		guard let id = book.id, let storedBook = getBook(id) else {
			return
		}
		
		if let lastReadingBook = lastReadingBook() ,let lastBookId = lastReadingBook.id, lastBookId != id {
			stopReading(lastReadingBook)
		}
		
		let reading = CDReadingTrack(context: context)
		reading.startAt = Date()
		reading.book = storedBook
		storedBook.addToReadingTracks(reading)
		storedBook.isReading = true
		do {
			try context.save()
		} catch let error {
			print("Error Saving, \(error)")
			return
		}
	}
	
	
	/// stops reading a book by finding its unfinished reading track and sets it `endAt` by now and also increase its `totalReadSeconds` by adding this reading track seconds to it and resets the `isReading` property to false.
	func stopReading(_ book: BookModel) {
		guard let context = self.database?.context else {
			assertionFailure("Where is my context")
			return
		}
		
		guard let id = book.id, let storedBook = getBook(id) , let danglingRead = findDanglingReading(storedBook) else {
			return
		}
		
		danglingRead.endAt = Date()
		storedBook.totalReadSeconds += danglingRead.endAt!.timeIntervalSince(danglingRead.startAt!)
		storedBook.isReading = false
		do {
			try context.save()
		} catch let error {
			print("Error Saving, \(error)")
			return
		}
	}
	
	private func getBook(_ id: UUID) -> CDBook? {
		guard let context = self.database?.context else { return nil}
		let fetchRequest = NSFetchRequest<CDBook>(entityName: "Book")
		
		fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
		guard let books = try? context.fetch(fetchRequest), let book = books.first else {
			return nil
		}
		return book
	}
	
	/// finds a book and delivers it to the then closure.
	/// - Parameters:
	///   - id: id of the book to find
	///   - then: callback
	func book(id: UUID,_ then: @escaping (Result<BookModel, Errors>) -> Void) {
		guard let book = getBook(id) else {
			return then(.failure(.unknown))
		}
		then(.success(book))
	}
}
