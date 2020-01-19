//
//  ModelFillable.swift
//  Cafe Bazaar
//
//  Created by Farshad Jahanmanesh on 12/23/19.
//  Copyright © 2019 Farshad Jahanmanesh. All rights reserved.
//

import Foundation

protocol ModelFillable {
	associatedtype Model
	func fill(_ model: Model)
}
