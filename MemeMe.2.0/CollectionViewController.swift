//
//  CollectionViewController.swift
//  MemeMe.2.0
//
//  Created by Edward Morton on 6/2/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: UICollectionViewController

class CollectionViewController: UICollectionViewController {

	// MARK: - Properties

	var memes: [Meme]! {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate

		return appDelegate.memes
	}

	// MARK: - Outlets

	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

	// MARK: - View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()

		let space: CGFloat = 3.0
		let dimension: CGFloat
		let width: CGFloat = view.frame.size.width
		let height: CGFloat = view.frame.size.height

		// determine cell size based on smallest dimension
		if ( height > width ) { // portrait
			dimension = (width - (2 * space)) / 3.0
		} else { // landscape
			dimension = (height - (2 * space)) / 3.0
		}

		flowLayout?.minimumInteritemSpacing = space
		flowLayout?.minimumLineSpacing = space
		flowLayout?.itemSize = CGSize(width: dimension, height: dimension)
		// adjust for X notch
		collectionView?.contentInsetAdjustmentBehavior = .always
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		collectionView.reloadData()
	}

	// MARK: - Collection View - Methods

	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return memes.count
	}

	override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let meme = memes[indexPath.row]
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell

		cell.imageView?.image = meme.memedImage

		return cell
	}

	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
		let detailController = storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController

		detailController.memeIndex = indexPath.row
		self.navigationController!.pushViewController(detailController, animated: true)
	}
}
