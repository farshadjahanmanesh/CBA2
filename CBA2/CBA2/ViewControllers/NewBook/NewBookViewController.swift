//
//  NewBookViewController.swift
//  Cafe Bazaar
//
//  Created by Farshad Jahanmanesh on 12/22/19.
//  Copyright © 2019 Farshad Jahanmanesh. All rights reserved.
//

import UIKit

class NewBookViewController: UIViewController, ViewModelHolder {
	var viewModel: NewBookViewModel!
	
	@IBOutlet var titleTextView: UITextView!
	@IBOutlet var coverSelectorButton: UIButton!
	@IBOutlet var authorTextField: UITextField!
	@IBOutlet var pageCountTextField: UITextField!
	@IBOutlet var otherInfoTextView: UITextView!
	@IBOutlet var saveButton: UIButton!
	@IBOutlet var containerBottomConstraint: NSLayoutConstraint!
	@IBOutlet var scrollView: UIScrollView!
	
	override var keyboardBottomConstraint: NSLayoutConstraint? {self.containerBottomConstraint}
	override var keyboardScrollView: UIScrollView? {self.scrollView}
	
	fileprivate var imagePickerController: UIImagePickerController?
	private enum ImageSource {
		case photoLibrary
		case camera
	}
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.startObservingKeyboardChanges()
	}
	
	deinit {
		self.stopObservingKeyboardChanges()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		styles()
	}
	
	private func styles() {
		self.navigationItem.title = "Add New Book"
		self.coverSelectorButton.imageView?.contentMode = .scaleToFill
		self.coverSelectorButton.setImage(.plus, for: .normal)
		self.coverSelectorButton.tintColor = .black
		self.coverSelectorButton.backgroundColor = .lightGray
		self.coverSelectorButton.addTarget(self, action: #selector(takePhoto(_:)), for: .touchUpInside)
		self.saveButton.addTarget(self, action: #selector(saveTheBook), for: .touchUpInside)
	}
	
	/// very simple validation
	private func isValidation() -> Bool{
		var animatedView: UIView? = nil
		defer {
			if let animatedView = animatedView {
				let oldBackground = animatedView.backgroundColor
				UIView.animateKeyframes(withDuration: 2, delay: 0, options: [], animations: {
					
					UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5) {
						animatedView.backgroundColor = .red
						self.scrollView.scrollToView(view: animatedView, animated: true, topOffset: 30)
					}
					UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.5) {
						animatedView.backgroundColor = oldBackground
					}
				}, completion: nil)
			}
		}
		guard titleTextView.text != "" else {
			animatedView = titleTextView
			return false
		}
		
		guard coverSelectorButton.currentBackgroundImage != nil else {
			animatedView = coverSelectorButton
			return false
		}
		
		guard authorTextField.text! != "" else {
			animatedView = authorTextField.superview!
			return false
		}
		guard let _ = Int(pageCountTextField.text!)  else {
			animatedView = pageCountTextField.superview!
			return false
		}
		return true
	}
	
	@objc
	private func saveTheBook() {
		guard isValidation() else {return}
		let imageName = "\(UUID().uuidString).png"
		
		let book = Book (id: UUID(), otherInfo: otherInfoTextView.text, author : authorTextField.text!,
						 coverAddress : imageName,
						 name : titleTextView.text!,
						 numberOfPages : Int32(pageCountTextField.text!) ?? 0,
						 bookmarkPage : 1, totalReadSeconds: 0, isReading: false)
		
		self.viewModel.add(book) { [weak self] result in
			switch result {
			case .failure(let error):
				self?.showErrorAlert(error.rawValue)
				break
			case .success(_):
				guard let _ = try? self?.saveImage(with: imageName) else {return}

			}
		}
	}
	
	//MARK: - Take image
	@objc func takePhoto(_ sender: UIButton) {
		guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
			selectImageFrom(.photoLibrary)
			return
		}
		selectImageFrom(.camera)
	}
	
	private func selectImageFrom(_ source: ImageSource){
		imagePickerController =  UIImagePickerController()
		imagePickerController!.delegate = self
		switch source {
		case .camera:
			imagePickerController!.sourceType = .camera
		case .photoLibrary:
			imagePickerController!.sourceType = .photoLibrary
		}
		DispatchQueue.main.async {
			self.present(self.imagePickerController!, animated: true, completion: nil)
		}
	}
	
	private func saveImage(with name: String) throws -> String? {
		guard let selectedImage = coverSelectorButton.currentBackgroundImage else {
			print("Image not found!")
			return nil
		}
		
		return try selectedImage.saveToDisk(quality: .low, name: name)
	}
	
	//MARK: - Add image to Library
	@objc func image(_ path: String, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
		if let error = error {
			// we got back an error!
			showAlertWith(title: "Save error", message: error.localizedDescription)
		} else {
			showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
		}
	}
	
	private func showAlertWith(title: String, message: String){
		let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "OK", style: .default))
		present(ac, animated: true)
	}
}

extension NewBookViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		imagePickerController?.dismiss(animated: true, completion: nil)
		guard let selectedImage = info[.originalImage] as? UIImage else {
			print("Image not found!")
			return
		}
		coverSelectorButton.setBackgroundImage(selectedImage, for: .normal)
	}
	
	fileprivate func showErrorAlert(_ message: String) {
		// Declare Alert
        let dialogMessage = UIAlertController(title: "Error", message: message, preferredStyle: .alert)

        // Create OK button with action handler
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)

        //Add OK and Cancel button to dialog message
        dialogMessage.addAction(ok)

        // Present dialog message to user
        self.present(dialogMessage, animated: true, completion: nil)
	}
}
