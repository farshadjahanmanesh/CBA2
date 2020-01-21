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
		}
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		styles()
		binding()
	}
	
	private func styles() {
		self.navigationItem.title = "Library"
		self.collectionView.contentInset = .init(top: 0, left: 0, bottom: addNewBookButton.frame.height, right: 0)
	}
	
	private func binding() {
		self.addNewBookButton.addTarget(self, action: #selector(addNewBook), for: .touchUpInside)
		self.viewModel.bookList
			.listen { [weak self] (bookList) in
				self?.collectionView.isHidden = bookList.isEmpty
				self?.hasActiveBook()
				self?.collectionView.reloadData()
			}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		viewModel.refreshBookList()
	}
	@objc
	private func addNewBook() {
		viewModel.createNewBook()
	}
	
	@objc
	fileprivate func goToActiveBook() {
		guard let book = self.viewModel.bookList.value.first(where: {$0.isReading}) else {return}
		self.viewModel.showToDetails(of: book)
	}
	
	// resets collectionview header
	private func hasActiveBook() {
		guard let flow =  self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {return}
		if self.viewModel.bookList.value.first(where: {$0.isReading }) != nil {
			flow.headerReferenceSize = CGSize(width: self.collectionView.frame.size.width, height: headerHeight)
		} else {
			flow.headerReferenceSize = CGSize(width: 0, height: 0)
		}
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
		let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CurrentBookCollectionReusableView", for: indexPath)
		guard let headerView = header as? CurrentBookCollectionReusableView, let model = self.viewModel.bookList.value.first(where: {$0.isReading}) else {
				return header
		}
		headerView.fill(model)
		headerView.frame.size.height = headerHeight
		let tap  = UITapGestureRecognizer(target: self, action: #selector(self.goToActiveBook))
		headerView.gestureRecognizers = nil
		headerView.addGestureRecognizer(tap)
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
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let book = self.viewModel.bookList.value[indexPath.row]
		self.viewModel.showToDetails(of: book)
	}
	
}
