//
//  Book.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/19/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import Foundation
// a contract between LocalModel and Outside one
protocol BookModel {
	var author: String? {get}
	var id: UUID? {get}
	var coverAddress: String? {get}
	var name: String? {get}
	var numberOfPages: Int32 {get}
	var bookmarkPage: Int32 {get}
	var otherInfo: String? {get}
	var totalReadSeconds: Double {get}
	var isReading: Bool {get}
}

struct Book: BookModel {
	let id: UUID?
	let otherInfo: String?
	let author: String?
	let coverAddress: String?
	let name: String?
	let numberOfPages: Int32
	let bookmarkPage: Int32
	let totalReadSeconds: Double
	let isReading: Bool
}
