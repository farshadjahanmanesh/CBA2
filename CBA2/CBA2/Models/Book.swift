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
	var author: String? {get set}
	var coverAddress: String? {get set}
	var name: String? {get set}
	var numberOfPages: Int32 {get set}
	var bookmarkPage: Int32 {get set}
	var otherInfo: String? {get set}
}

struct Book: BookModel {
	var otherInfo: String?
	var author: String?
	var coverAddress: String?
	var name: String?
	var numberOfPages: Int32
	var bookmarkPage: Int32	
}
