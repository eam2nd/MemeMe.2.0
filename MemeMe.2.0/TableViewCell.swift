//
//  TableViewCell.swift
//  MemeMe.2.0
//
//  Created by Edward Morton on 6/11/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

	//MARK: Properties

	@IBOutlet weak var img: UIImageView!
	@IBOutlet weak var topLabel: UILabel!
	@IBOutlet weak var bottomLabel: UILabel!

	//MARK: Custom Cell's Functions

	func setContent(_ meme: Meme) {
		img.image = meme.memedImage
		topLabel.text = meme.topText as String?
		bottomLabel.text = meme.bottomText as String?
	}
}
