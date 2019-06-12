//
//  Font.swift
//  MemeMe.2.0
//
//  Created by Edward Morton on 6/8/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: Font Model - Struct

public struct Font {

	// MARK: - Properties

	static var fontFamily: String = MemeDefault.fontFamily
	static var fontName: String = MemeDefault.fontName

	struct Fonts {
		var fontFamily: String
		var fontNames: Array<String>
	}

	static var fonts: Array<Fonts> {
		var fonts = [Fonts]()

		for fontFamily in UIFont.familyNames.sorted() {
			fonts.append(Fonts(fontFamily: fontFamily, fontNames: UIFont.fontNames(forFamilyName: fontFamily).sorted()))
		}

		return fonts
	}

	// MARK - Methods

	static func reset () {
		Font.fontFamily = MemeDefault.fontFamily
		Font.fontName = MemeDefault.fontName
	}

	// get the section and row of the current font
	static func getSectionRow () -> (Int, Int) {
		for (section, font) in Font.fonts.enumerated() {
			if font.fontFamily == fontFamily {
				for (row, name) in font.fontNames.enumerated() {
					if name == fontName {
						return (section, row)
					}
				}
			}
		}

		return (0, 0)
	}
}
