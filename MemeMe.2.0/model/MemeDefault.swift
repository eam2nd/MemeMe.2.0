//
//  MemeDefault.swift
//  MemeMe.2.0
//
//  Created by Edward Morton on 6/11/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: Meme Default Model - Struct

public struct MemeDefault {

	// MARK: - Properties

	static let text = ["TOP","BOTTOM"]
	static let memeTextAttributes: [NSAttributedString.Key: Any] = [
		NSAttributedString.Key.strokeColor: UIColor.black,
		NSAttributedString.Key.foregroundColor: UIColor.white,
		NSAttributedString.Key.font: UIFont(name: MemeDefault.fontName, size: MemeDefault.fontSize)!,
		NSAttributedString.Key.strokeWidth: -6.0
	]
	static let fontFamily: String = "Impact"
	static let fontName: String = "Impact"
	static let fontSize: CGFloat = 40
}
