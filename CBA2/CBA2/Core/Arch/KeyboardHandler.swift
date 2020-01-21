//
//  KeyboardHandler.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/17/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import UIKit
import Foundation
protocol KeyboardHandler: class {
	var keyboardIsUp: Bool {set get}
	var keyboardScrollView: UIScrollView? { get }
	var keyboardBottomConstraint: NSLayoutConstraint? { get }
	func keyboardWillShow(_ notification: Notification)
	func keyboardWillHide(_ notification: Notification)
	func startObservingKeyboardChanges()
	func stopObservingKeyboardChanges()
}

private var keyboardHandlerUnsafe: Int8 = 0
@objc extension UIViewController: KeyboardHandler  {
	var keyboardIsUp: Bool {
		get { objc_getAssociatedObject(self, &keyboardHandlerUnsafe) as? Bool ?? false }
		set { objc_setAssociatedObject(self, &keyboardHandlerUnsafe, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
	}
	var keyboardScrollView: UIScrollView? {nil}
	var keyboardBottomConstraint: NSLayoutConstraint? {nil}
	func startObservingKeyboardChanges() {
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		
		NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	func stopObservingKeyboardChanges(){
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc func keyboardWillShow(_ notification: Notification) {
		defer{self.keyboardIsUp = true}
		let userInfo: NSDictionary = notification.userInfo! as NSDictionary
		let keyboardInfo = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
		let keyboardSize = keyboardInfo.cgRectValue.size
		var contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height , right: 0)
		if #available(iOS 11.0, *) {
			contentInsets.bottom = keyboardSize.height - view.safeAreaInsets.bottom
		}
		guard let bottomConstraint = keyboardBottomConstraint, abs(bottomConstraint.constant) != contentInsets.bottom else {
			return
		}
		bottomConstraint.constant = -contentInsets.bottom
		UIView.animate(withDuration: 0.3) {
			self.view.layoutIfNeeded()
		}
	}
	
	@objc func keyboardWillHide(_ notification: Notification) {
		defer{self.keyboardIsUp = false}
		if let bottom = keyboardBottomConstraint {
			bottom.constant = 0
			UIView.animate(withDuration: 0.3) {
				self.view.layoutIfNeeded()
			}
		}
		guard let keyboardScrollView = keyboardScrollView else { return }
		keyboardScrollView.contentInset = .zero
		keyboardScrollView.scrollIndicatorInsets = .zero
	}
}
