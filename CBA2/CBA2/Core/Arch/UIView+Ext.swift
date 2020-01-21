//
//  UIView+Ext.swift
//  CBA2
//
//  Created by Farshad Jahanmanesh on 1/19/20.
//  Copyright © 2020 Farshad Jahanmanesh. All rights reserved.
//

import UIKit
extension UIView {
	func dropShadow(color: UIColor, opacity: Float = 0.4, offSet: CGSize, radius: CGFloat = 5, scale: Bool = true) {
	   layer.masksToBounds = false
	   layer.shadowColor = color.cgColor
	   layer.shadowOpacity = opacity
	   layer.shadowOffset = offSet
	   layer.shadowRadius = radius

	   layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
	   layer.shouldRasterize = true
	   layer.rasterizationScale = scale ? UIScreen.main.scale : 1
	 }
}
