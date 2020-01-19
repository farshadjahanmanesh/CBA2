//
//  BooksListViewController.swift
//  Cafe Bazaar
//
//  Created by Farshad Jahanmanesh on 12/23/19.
//  Copyright © 2019 Farshad Jahanmanesh. All rights reserved.
//

import UIKit
class BooksListViewController: UIViewController, ViewModelHolder {
	var viewModel: BookListViewModel!
	private let headerHeight: CGFloat = 300
	
	@IBOutlet var addNewBookButton: UIButton!
	@IBOutlet var collectionView: UICollectionView! {
		didSet {
			self.collectionView.register(UINib(nibName: "CurrentBookCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CurrentBookCollectionReusableView")
			self.collectionView.register(UINib(nibName: "BookCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "BookCollectionViewCell")
			self.collectionView.dataSource = self
			self.collectionView.delegate = self
			(self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.headerReferenceSize = CGSize(width: self.collectionView.frame.size.width, height: headerHeight)

		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		binding()
	}
	
	private func styles() {
		self.navigationItem.title = "Library"
	}
	
	private func binding() {
		self.addNewBookButton.addTarget(self, action: #selector(addNewBook), for: .touchUpInside)
		self.viewModel.bookList
			.listen { [weak self] (bookist) in
				self?.collectionView.reloadData()
			}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.refreshBookList()
	}
	@objc
	private func addNewBook() {
		viewModel.navigateNewBook()
	}
}

extension BooksListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		self.viewModel.bookList.value.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionViewCell", for: indexPath) as? BookCollectionViewCell else {
			assertionFailure("BookCollectionViewCell not found")
			return UICollectionViewCell()
		}
		cell.fill(self.viewModel.bookList.value[indexPath.row])
		return cell
	}
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		guard
			let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CurrentBookCollectionReusableView", for: indexPath) as? CurrentBookCollectionReusableView, let model = self.viewModel.bookList.value.last else {
				return UICollectionReusableView()
		}
		headerView.fill(model)
		headerView.frame.size.height = headerHeight
		return headerView
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return .leastNonzeroMagnitude
	}
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		var width = self.collectionView.frame.width / 2
		width -= 2
		return .init(width:  width , height: (width + (width * 0.75)))
	}
}
