//
//  BookAPI.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/19/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import Foundation
import CoreData


struct Errors:Error, RawRepresentable {
	var rawValue: String
	init(rawValue: String) {
		self.rawValue = rawValue
	}
}

extension Errors: ExpressibleByStringLiteral {
	init(stringLiteral value: String) {
		self.rawValue = value
	}
	static let unknown:Errors = "unknown error."
}

protocol BooksApi {
	// adds new book
	func add(_ book: BookModel, _ then: ((Result<Void, Errors>) -> Void)?)
	func add(_ book: BookModel)
	
	// list of all books
	func bookList(_ then: @escaping (Result<[BookModel], Errors>)->Void)
	func book(id: UUID,_ then: @escaping (Result<BookModel, Errors>)->Void)
	func startReading(_ book: BookModel)
	func stopReading(_ book: BookModel)
	func isCurrentlyReading(_ book: BookModel)->Double?
}

struct DefaultBooksDatabse: BooksApi {
	weak var database: CoreDatabase?
	init(database: CoreDatabase) {
		self.database = database
	}
	
	func add(_ book: BookModel) {
		self.add(book, nil)
	}
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
	
	private func findDanglingReading(_ book: CDBook) -> CDReadingTrack? {
		guard let reading = book.value(forKey: "danglingReading") as?  [CDReadingTrack], let danglingRead = reading.last  else {
			return nil
		}
		
		return danglingRead
	}
	private func lastReadingBook() -> CDBook? {
		guard let context = self.database?.context else { return nil }
		let fetchRequest = NSFetchRequest<CDBook>(entityName: "Book")
		
		fetchRequest.predicate = NSPredicate(format: "isReading = true")
		guard let books = try? context.fetch(fetchRequest), let book = books.first else {
			return nil
		}
		
		return book
	}
	
	func isCurrentlyReading(_ book: BookModel)->Double? {
		guard let id = book.id, let storedBook = getBook(id) , let danglingRead = findDanglingReading(storedBook) else {
			return nil
		}
		return Date().timeIntervalSince(danglingRead.startAt!)
	}

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
	
	func book(id: UUID,_ then: @escaping (Result<BookModel, Errors>) -> Void) {
		guard let book = getBook(id) else {
			return then(.failure(.unknown))
		}
		then(.success(book))
	}
}
