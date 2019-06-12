//
//  EditorViewController
//  MemeMe.2.0
//
//  Created by Edward Morton on 5/25/19.
//  Copyright © 2019 Edward Morton. All rights reserved.
//

import UIKit
import Photos
import AVFoundation

// MARK: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate

class EditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate {

	// MARK: - Properties

	var meme: Meme!
	var memeIndex: Int!
	var saveAndShareBarButtonItem: UIBarButtonItem!

	// Credit: https://medium.com/modernnerd-code/how-to-make-a-custom-image-cropper-with-swift-3-c0ec8c9c7884
	var cropArea: CGRect {
		get {
			let factor = imageView.image!.size.width / view.frame.width
			let scale = 1 / scrollView.zoomScale
			let imageFrame = imageView.imageFrame()
			let x = (scrollView.contentOffset.x + cropAreaView.frame.origin.x - imageFrame.origin.x) * scale * factor
			let y = (scrollView.contentOffset.y + cropAreaView.frame.origin.y - imageFrame.origin.y) * scale * factor
			let width = cropAreaView.frame.size.width * scale * factor
			let height = cropAreaView.frame.size.height * scale * factor

			return CGRect(x: x, y: y, width: width, height: height)
		}
	}

	// MARK: - Outlets

	// Credit: https://medium.com/modernnerd-code/how-to-make-a-custom-image-cropper-with-swift-3-c0ec8c9c7884
	@IBOutlet weak var scrollView: UIScrollView! {
		didSet {
			scrollView.delegate = self
			scrollView.minimumZoomScale = 1.0
			scrollView.maximumZoomScale = 10.0
		}
	}
	@IBOutlet weak var cropAreaView: EditorCropAreaView!
	@IBOutlet weak var imageView: UIImageView!
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	@IBOutlet weak var bottomToolbar: UIToolbar!
	@IBOutlet weak var cameraBarButtonItem: UIBarButtonItem!

	// MARK: - Actions

	@objc func shareMeme() {
		let image: UIImage = generateMeme()
		let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)

		activity.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, activityError: Error?) in
			if completed && activityError == nil {
				self.saveMeme(image)
				self.dismiss(animated: true, completion: nil)
			}
		}

		present(activity, animated: true, completion: nil)
	}

	@objc func saveEditedMeme() {
		let image: UIImage = generateMeme()

		saveMeme(image, memeIndex)
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func cancel(_ sender: UIBarButtonItem) {
		self.dismiss(animated: true, completion: nil)
	}

	@IBAction func pickImageFromLibrary(_ sender: UIBarButtonItem) {
		pickImage(sourceType: .photoLibrary)
	}

	@IBAction func pickImageFromCamera(_ sender: UIBarButtonItem) {
		pickImage(sourceType: .camera)
	}

	// MARK: - Pick Image - Photo Library or Camera

	func pickImage(sourceType: UIImagePickerController.SourceType) {
		let pickerController = UIImagePickerController()

		pickerController.delegate = self
		pickerController.sourceType = sourceType
		pickerController.modalPresentationStyle = .overCurrentContext
		checkAuthorizationStatus(pickerController)
	}

	// MARK: Permission Check - Photo Library or Camera

	func checkAuthorizationStatus(_ pickerController: UIImagePickerController) {
		if pickerController.sourceType == .camera {
			let authStatus = AVCaptureDevice.authorizationStatus(for: .video)

			switch authStatus {
			case .authorized:
				present(pickerController, animated: true, completion: nil)
			case .notDetermined:
				AVCaptureDevice.requestAccess(for: .video) { success in
					if success {
						DispatchQueue.main.async {
							self.present(pickerController, animated: true, completion: nil)
						}
					}
				}
			default:
				self.showSettingsAlert("Camera", "Open Settings to grant access to the Camera?")
			}
		} else if pickerController.sourceType == .photoLibrary {
			let authStatus = PHPhotoLibrary.authorizationStatus()

			switch authStatus {
			case .authorized:
				present(pickerController, animated: true, completion: nil)
			case .notDetermined:
				PHPhotoLibrary.requestAuthorization({
					(status) in
					if status == PHAuthorizationStatus.authorized {
						DispatchQueue.main.async {
							self.present(pickerController, animated: true, completion: nil)
						}
					}
				})
			default:
				self.showSettingsAlert("Photo Library", "Open Settings to grant access to Photo Library?")
			}
		}
	}

	// MARK: - Meme Generate & Save

	func generateMeme() -> UIImage {
		// Hide toolbar to not include in Meme Image
		bottomToolbar.isHidden = true

		// Render view to an image
		UIGraphicsBeginImageContext(self.view.frame.size)
		view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
		let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
		UIGraphicsEndImageContext()

		// Show toolbar after capturing Meme Image
		bottomToolbar.isHidden = false

		return memedImage
	}

	// No reason to return meme since we're dismissing view after saving.
	func saveMeme(_ memedImage: UIImage, _ index: Int? = nil) {
		let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageView.image!, memedImage: memedImage)
		let appDelegate = UIApplication.shared.delegate as! AppDelegate

		if let index = index {
			appDelegate.memes[index] = meme
		} else {
			appDelegate.memes.append(meme)
		}
	}

	// MARK: - Delegate Methods -  Scroll View

	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return imageView
	}

	// MARK: Delegate Methods -  Image Picker

	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
		dismiss(animated: true, completion: nil)

		if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			imageView.contentMode = .scaleAspectFit
			imageView.image = pickedImage
			saveAndShareBarButtonItem?.isEnabled = true
		}
	}

	func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
		dismiss(animated: true, completion: nil)
	}

	// MARK: Delegate Methods - Text Fields

	func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
		if MemeDefault.text.contains(textField.text!) {
			textField.text = ""
		}

		return true
	}

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()

		return true
	}

	func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
		if textField.text == "" {
			textField.text = MemeDefault.text[textField.tag]
		}
	}

	// MARK: - Keyboard Notification Methods

	func subscribeToKeyboardNotifications() {
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	func unsubscribeFromKeyboardNotifications() {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}

	@objc func keyboardWillShow(_ notification:Notification) {
		if bottomTextField.isEditing && self.view.frame.origin.y == 0 {
			self.view.frame.origin.y -= getKeyboardHeight(notification)
		}
	}

	@objc func keyboardWillHide(_ notification: Notification) {
		if bottomTextField.isEditing && self.view.frame.origin.y != 0 {
			self.view.frame.origin.y += getKeyboardHeight(notification)
		}
	}

	func getKeyboardHeight(_ notification:Notification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue

		return keyboardSize.cgRectValue.height
	}

	// MARK: - Alert Controller to Open Settings - To Change App Permissions

	func showSettingsAlert(_ title: String, _ msg: String) {
		let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)

		alert.addAction(UIAlertAction(title: "NO", style: .default, handler: { action in
			self.dismiss(animated: true, completion: nil)
		}))

		alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { action in
			self.dismiss(animated: true, completion: nil)
			UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
		}))

		present(alert, animated: true)
	}

	// MARK: - Set Default TextField Properties

	func setDefaultTextFieldProperties(_ textField: UITextField) {
		textField.text = MemeDefault.text[textField.tag]
		textField.defaultTextAttributes = MemeDefault.memeTextAttributes
		textField.textAlignment = .center
		textField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
		textField.borderStyle = .none
		textField.adjustsFontSizeToFitWidth = true
		textField.minimumFontSize = 10
		textField.delegate = self
	}

	// MARK: - View Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()

		setDefaultTextFieldProperties(topTextField)
		setDefaultTextFieldProperties(bottomTextField)
		cameraBarButtonItem.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
		cropAreaView.alpha = 0.5

		if let meme = meme {
			// we are editing an existing meme
			Font.fontFamily = meme.fontFamily
			Font.fontName = meme.fontName

			topTextField.text = meme.topText
			bottomTextField.text = meme.bottomText
			imageView.image = meme.originalImage

			saveAndShareBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .save, target: self, action: #selector(saveEditedMeme))
		} else {
			// we are creating a new meme
			Font.reset()
			saveAndShareBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .action, target: self, action: #selector(shareMeme))
			saveAndShareBarButtonItem.isEnabled = false
		}

		navigationItem.leftBarButtonItem = saveAndShareBarButtonItem
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		topTextField.font = UIFont(name: Font.fontName, size: MemeDefault.fontSize)
		bottomTextField.font = UIFont(name: Font.fontName, size: MemeDefault.fontSize)
		subscribeToKeyboardNotifications()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		unsubscribeFromKeyboardNotifications()
	}

	// dismiss keyboard on orientation change when editing bottom textfield
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)

		if bottomTextField.isEditing {
			bottomTextField.endEditing(true)
		}
	}
}

// MARK: - UIImage View Extenstion

// Credit: https://medium.com/modernnerd-code/how-to-make-a-custom-image-cropper-with-swift-3-c0ec8c9c7884
extension UIImageView {

	// MARK: UIImageView .imageFrame

	func imageFrame() -> CGRect {
		let imageViewSize = self.frame.size
		guard let imageSize = self.image?.size else {
			return CGRect.zero
		}
		let imageRatio = imageSize.width / imageSize.height
		let imageViewRatio = imageViewSize.width / imageViewSize.height
		let scaleFactor: CGFloat

		if imageRatio < imageViewRatio {
			scaleFactor = imageViewSize.height / imageSize.height
			let width = imageSize.width * scaleFactor
			let topLeftX = (imageViewSize.width - width) * 0.5

			return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
		} else {
			scaleFactor = imageViewSize.width / imageSize.width
			let height = imageSize.height * scaleFactor
			let topLeftY = (imageViewSize.height - height) * 0.5

			return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
		}
	}
}
