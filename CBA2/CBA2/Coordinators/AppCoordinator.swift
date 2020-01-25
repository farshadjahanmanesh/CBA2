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
	private let coreDatabase = CoreDatabase()
	private lazy var bookApi: BooksApi = {CoreDataBooksApiImplementation(database: self.coreDatabase)}()
	init(window: UIWindow) {
		self.window = window
		self.coreDatabase.initalizeStack()
		start()
	}
	
	private func start(){
		let bookListViewController = BooksListViewController.init(nibName: "BooksListViewController", bundle: nil)
		bookListViewController.viewModel = DefaultBookListViewModel(repo: bookApi, coordinator: self)
		navigation = UINavigationController(rootViewController: bookListViewController)
		self.window.rootViewController = navigation
		self.window.makeKeyAndVisible()
	}
	
	func coordinateToAddBook() {
		let newBookViewController = NewBookViewController.init(nibName: "NewBookViewController", bundle: nil)
		newBookViewController.viewModel = DefaultNewBookViewModel(repo: bookApi, coordinator: self)
		newBookViewController.viewModel.newBookAdded.listen {[weak self] added in
			if added {
				self?.navigation.popViewController(animated: true)
			}
		}
		self.navigation.pushViewController(newBookViewController, animated: true)
	}
	
	func coordinateToDetails(of book: BookModel) {
		let detailsViewController = BookDetailsViewController.init(nibName: "BookDetailsViewController", bundle: nil)
		detailsViewController.viewModel = DefaultBookDetailsViewModel(repo: bookApi, coordinator: self, book: book)
		self.navigation.pushViewController(detailsViewController, animated: true)
	}
}
