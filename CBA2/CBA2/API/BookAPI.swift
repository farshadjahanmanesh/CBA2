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
	// edit a book
	func edit(_ book: BookModel)
	
	// list of all books
	func bookList(_ then: (Result<[BookModel], Errors>)->Void)
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
	
	func edit(_ book: BookModel) {
		
	}
	
	func bookList(_ then: (Result<[BookModel], Errors>)->Void)  {
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
}
