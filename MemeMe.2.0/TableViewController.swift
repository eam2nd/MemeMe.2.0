//
//  TableViewController.swift
//  MemeMe.2.0
//
//  Created by Edward Morton on 6/2/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: UITableViewController

class TableViewController: UITableViewController {

	// MARK: - Properties

	var memes: [Meme]! {
		let appDelegate = UIApplication.shared.delegate as! AppDelegate

		return appDelegate.memes
	}

	// MARK: - View Life Cycle

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		tableView.reloadData()
	}

	// MARK: - Table View - Methods

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return memes.count
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell

		cell.setContent(memes[indexPath.row])

		return cell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let detailController = storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController

		detailController.memeIndex = indexPath.row
		self.navigationController!.pushViewController(detailController, animated: true)
	}

	// MARK: Swipe To Delete

	override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
		if editingStyle == .delete {
			let appDelegate = UIApplication.shared.delegate as! AppDelegate

			appDelegate.memes.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .fade)
		}
	}
}
