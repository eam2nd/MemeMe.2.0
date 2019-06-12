//
//  Meme.swift
//  MemeMe.2.0
//
//  Created by Edward Morton on 5/25/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: Meme Model - Struct

public struct Meme {

	// MARK: - Properties

	var topText: String
	var bottomText: String
	var originalImage: UIImage
	var memedImage: UIImage

	var fontFamily: String
	var fontName: String

	// MARK: - Initializer

	init(topText: String, bottomText: String, originalImage: UIImage, memedImage: UIImage, fontFamily: String? = nil, fontName: String? = nil) {
		self.topText = topText
		self.bottomText = bottomText
		self.originalImage = originalImage
		self.memedImage = memedImage

		if let fontFamily = fontFamily {
			self.fontFamily = fontFamily
		} else {
			self.fontFamily = Font.fontFamily
		}

		if let fontName = fontName {
			self.fontName = fontName
		} else {
			self.fontName = Font.fontName
		}
	}
}
