//
//  FontTableViewController.swift
//  MemeMe.2.0
//
//  Created by Edward Morton on 6/8/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: UITableViewController

class FontTableViewController: UITableViewController {

	// MARK: - Properties

	var meme: Meme!
	var fonts = Font.fonts
	var scrolledToFont: Bool = false

	// MARK: - Actions

	@IBAction func cancel(_ sender: Any) {
		self.dismiss(animated: true, completion: nil)
	}

	// MARK: View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		tableView.sectionIndexColor = UIColor.orange
		tableView.sectionIndexBackgroundColor = UIColor.init(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.2)
		tableView.sectionIndexTrackingBackgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.4)
	}

	// MARK: - Table View - Methods

	override func numberOfSections(in tableView: UITableView) -> Int {
		return fonts.count
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return fonts[section].fontNames.count
	}

	override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
		var fontFamilies = [String]()

		for font in fonts {
			fontFamilies.append(font.fontFamily)
		}

		return fontFamilies
	}

	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		return fonts[section].fontFamily
	}

	override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
		let header = view as! UITableViewHeaderFooterView

		header.textLabel?.textColor = UIColor.white
		view.tintColor = UIColor.init(red: 0.0196, green: 0.3726, blue: 0.5294, alpha: 1.0) // 5, 95, 135
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let family = fonts[indexPath.section]
		let font = family.fontNames[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "FontCell", for: indexPath)

		cell.textLabel?.text = font
		cell.textLabel?.font = UIFont(name: font, size: 16)

		if family.fontFamily == Font.fontFamily && font == Font.fontName {
			cell.accessoryType = .checkmark
		} else {
			cell.accessoryType = .none
		}

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		Font.fontFamily = fonts[indexPath.section].fontFamily
		Font.fontName = fonts[indexPath.section].fontNames[indexPath.row]
		dismiss(animated: true, completion: nil)
	}

	// MARK: - View Life Cycle

	// Put selected font on screen
	override func viewDidLayoutSubviews() {
		if !scrolledToFont {
			scrolledToFont = true

			let sectionRow = Font.getSectionRow()
			let indexPath = IndexPath(row: sectionRow.1, section: sectionRow.0)

			tableView.scrollToRow(at: indexPath, at: .top, animated: true)
		}
	}
}
