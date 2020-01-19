//
//  Database.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/17/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import Foundation
import CoreData

class CoreDatabase {
    let persistentContainer = NSPersistentContainer(name: "CBA2")
    
    func initalizeStack() {
        self.persistentContainer.loadPersistentStores { description, error in
            if let error = error {
				assertionFailure("could not load store \(error.localizedDescription)")
                return
            }
			print("store loaded")
        }
    }
	
	var context: NSManagedObjectContext {
		return self.persistentContainer.viewContext
	}
}
