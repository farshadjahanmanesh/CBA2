//
//  ViewModelHolder.swift
//  Cafe Bazaar
//
//  Created by Farshad Jahanmanesh on 12/23/19.
//  Copyright © 2019 Farshad Jahanmanesh. All rights reserved.
//

import UIKit
protocol ViewModel {}
protocol ViewModelHolder where Self: UIViewController {
	associatedtype ViewModel
	var viewModel: ViewModel!{set get}
	func validateViewModel()
}

extension ViewModelHolder {
	func validateViewModel(){
		guard viewModel != nil else {
			fatalError("whaat? have you forgot to set the viewModel?")
		}
	}
}
