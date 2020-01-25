//
//  Errors.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/21/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import Foundation
struct Errors:Error, RawRepresentable {
	var rawValue: String
	init(rawValue: String) {
		self.rawValue = rawValue
	}
}

extension Errors: ExpressibleByStringLiteral {
	init(stringLiteral value: String) {
		self.rawValue = value
	}
	static let unknown:Errors = "unknown error."
}
