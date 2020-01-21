//
//  DirectoryPath.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/19/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import Foundation
struct DirectoryPath {
	var url: URL
}

extension DirectoryPath {
	static var user: DirectoryPath {
		return .init(url: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!)
	}
}
