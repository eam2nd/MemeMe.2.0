//
//  TabBarViewController.swift
//  MemeMe.2.0
//
//  Created by Edward Morton on 6/10/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: - UITabBarController

class TabBarViewController: UITabBarController {

	// MARK: - View Life Cycle

	override func viewDidLoad() {
		super.viewDidLoad()
		delegate = self
	}
}

// MARK: - Extension - UITabBarControllerDelegate

extension TabBarViewController: UITabBarControllerDelegate  {

	// MARK: Delegate Methods

	// Provide some animation moving between tabs
	func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
		guard
			let fromVC = selectedViewController,
			let fromView = fromVC.view,
			let fromIndex = getIndex(forViewController: fromVC),
			let toView = viewController.view
		else {
			return false
		}

		var options: UIView.AnimationOptions = [.transitionFlipFromRight]

		if fromIndex == 1 {
			options = [.transitionFlipFromLeft]
		}

		// only animate if switching tabs
		if fromView != toView {
			UIView.transition(from: fromView, to: toView, duration: 0.35, options: options, completion: nil)
		}

		return true
	}

	// MARK: Methods

	func getIndex(forViewController vc: UIViewController) -> Int? {
		guard let vcontrollers = self.viewControllers else {
			return nil
		}

		for (index, thisVC) in vcontrollers.enumerated() {
			if thisVC == vc {
				return index
			}
		}

		return nil
	}
}
