//
//  EditorCropAreaView
//  MemeMe.2.0
//
//  Created by Edward Morton on 6/9/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit

// MARK: - UIView

class EditorCropAreaView: UIView {

	// MARK: - UIView Methods

	// Credit: https://medium.com/modernnerd-code/how-to-make-a-custom-image-cropper-with-swift-3-c0ec8c9c7884
	// Allow view to pass all events through to underlying view
	override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
		return false
	}
}
