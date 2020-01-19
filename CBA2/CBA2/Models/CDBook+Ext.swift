//
//  CDBook+Ext.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/19/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import Foundation
extension CDBook: BookModel {
	func from(_ book: BookModel) {
		self.author = book.author
		self.coverAddress = book.coverAddress
		self.name = book.name
		self.numberOfPages = book.numberOfPages
		self.bookmarkPage = book.bookmarkPage
	}
	func toLocalModel()->Book {
		.init(
			otherInfo: self.otherInfo,
			author : self.author,
			coverAddress : self.coverAddress,
			name : self.name,
			numberOfPages : self.numberOfPages,
			bookmarkPage : self.bookmarkPage
		)
	}
}
