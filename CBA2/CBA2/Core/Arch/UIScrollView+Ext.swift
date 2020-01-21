//
//  UIScrollView+Ext.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/19/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import UIKit
extension UIScrollView {
	
	// Scroll to a specific view so that it's top is at the top our scrollview
	func scrollToView(view:UIView, animated: Bool, topOffset: CGFloat = 0) {
		if let origin = view.superview {
			// Get the Y position of your child view
			let childStartPoint = origin.convert(view.frame.origin, to: self)
			// Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
			self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y - topOffset,width: 1,height: self.frame.height), animated: animated)
		}
	}
	
	// Bonus: Scroll to top
	func scrollToTop(animated: Bool) {
		let topOffset = CGPoint(x: 0, y: -contentInset.top)
		setContentOffset(topOffset, animated: animated)
	}
	
	// Bonus: Scroll to bottom
	func scrollToBottom() {
		let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
		if(bottomOffset.y > 0) {
			setContentOffset(bottomOffset, animated: true)
		}
	}
	
}
