//
//  AppCoordinator.swift
//  Cafe Bazaar
//
//  Created by Farshad Jahanmanesh on 12/21/19.
//  Copyright © 2019 Farshad Jahanmanesh. All rights reserved.
//

import Foundation
import UIKit
import CoreData
class AppCoordinator: BookCordinator {
	private unowned var window: UIWindow
	private(set) var navigation: UINavigationController!
	private var dataStore: DataStore = UserDefaultStore()
	private let coreDatabase = CoreDatabase()
	
	init(window: UIWindow) {
		self.window = window
		self.coreDatabase.initalizeStack()
		start()
	}
	
	private func start(){
		let api = DefaultBooksDatabse(database: self.coreDatabase)
		let bookListViewController = BooksListViewController.init(nibName: "BooksListViewController", bundle: nil)
		bookListViewController.viewModel = DefaultBookListViewModel(store: dataStore, repo: api, coordinator: self)
		navigation = UINavigationController(rootViewController: bookListViewController)
		self.window.rootViewController = navigation
		self.window.makeKeyAndVisible()
	}
	
	func coordinateToAddBook() {
		let api = DefaultBooksDatabse(database: self.coreDatabase)
		let newBookViewController = NewBookViewController.init(nibName: "NewBookViewController", bundle: nil)
		newBookViewController.viewModel = DefaultNewBookViewModel(store: dataStore, repo: api, coordinator: self)
		newBookViewController.viewModel.newBookAdded.listen {[weak self] added in
			if added {
				self?.navigation.popViewController(animated: true)
			}
		}
		self.navigation.pushViewController(newBookViewController, animated: true)
	}
	
	func coordinateToDetails(of book: BookModel) {
		let api = DefaultBooksDatabse(database: self.coreDatabase)
		let detailsViewController = BookDetailsViewController.init(nibName: "BookDetailsViewController", bundle: nil)
		detailsViewController.viewModel = DefaultBookDetailsViewModel(store: dataStore, repo: api, coordinator: self, book: book)
		self.navigation.pushViewController(detailsViewController, animated: true)
	}
}

protocol BookCordinator {
	func coordinateToAddBook()
	func coordinateToDetails(of book: BookModel)
}
