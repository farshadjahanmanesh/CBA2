//
//  BookCordinator.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/21/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import Foundation
protocol BookCordinator {
	func coordinateToAddBook()
	func coordinateToDetails(of book: BookModel)
}
