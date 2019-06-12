//
//  DetailViewController
//  MemeMe.2.0
//
//  Created by Edward Morton on 6/4/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: UIViewController

class DetailViewController: UIViewController {

	// MARK: - Properties

	var meme: Meme!
	var memeIndex: Int!

	// MARK: - Outlets

	@IBOutlet weak var imageView: UIImageView!

	// MARK: - Actions

	@IBAction func shareMeme(_ sender: UIBarButtonItem) {
		let image: UIImage = meme.memedImage
		let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)

		present(activity, animated: true, completion: nil)
	}

	// MARK: - Prepare For Seque

	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

		if segue.identifier == "EditMeme"  {
			if let navController = segue.destination as? UINavigationController {
				if let childVC = navController.topViewController as? EditorViewController {
					childVC.meme = self.meme
					childVC.memeIndex = self.memeIndex
				}
			}
		}
	}

	// MARK: - View Life Cycle

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		tabBarController?.tabBar.isHidden = true

		// make sure we have any edits displayed
		if let memeIndex = memeIndex {
			let appDelegate = UIApplication.shared.delegate as! AppDelegate

			meme = appDelegate.memes[memeIndex]
			imageView!.image = meme.memedImage
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		tabBarController?.tabBar.isHidden = false
	}
}
