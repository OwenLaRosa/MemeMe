//
//  MemeEditorViewController.swift
//  Meme Me
//
//  Created by Owen LaRosa on 3/19/15.
//  Copyright (c) 2015 Owen LaRosa. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var cameraBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    
    @IBOutlet weak var bottomTextField: UITextField!
    
    private var image: UIImage!
    private var imageWidth: CGFloat!
    private var imageHeight: CGFloat!
    
    private var topTextFieldConstraint: NSLayoutConstraint!
    private var bottomTextFieldConstraint: NSLayoutConstraint!
    
    let topTextFieldDelegate = TextFieldDelegate(defaultText: "TOP")
    let bottomTextFieldDelegate = TextFieldDelegate(defaultText: "BOTTOM")
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(), // TODO: Fill in appropriate UIColor,
        NSForegroundColorAttributeName : UIColor.whiteColor(), // TODO: Fill in UIColor,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -3.0 // TODO: Fill in appropriate Float
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set camera button status
        cameraBarButtonItem.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        // configure the text fields
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        topTextField.delegate = topTextFieldDelegate
        bottomTextField.delegate = bottomTextFieldDelegate
        
        // constraints to keep the text fields in the correct place
        // the constant values will be adjusted when necessary
        topTextFieldConstraint = NSLayoutConstraint(item: topTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        view.addConstraint(topTextFieldConstraint)
        bottomTextFieldConstraint = NSLayoutConstraint(item: bottomTextField, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.Top, multiplier: 1.0, constant: 0)
        view.addConstraint(bottomTextFieldConstraint)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        subscribeToKeyboardNotifications()
        subscribeToDeviceRotationNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func subscribeToDeviceRotationNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "deviceDidRotate:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func deviceDidRotate(notification: NSNotification) {
        // reposition text fields after a rotation
        positionTextFields()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:"    , name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name:
            UIKeyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        // move the view so the bottom text field is not obscured
        // in some cases, this could obscure the top text field in landscape mode
        if bottomTextField.isFirstResponder() {
            let keyboardHeight = getKeyboardHeight(notification)
            let imageRect = getImageRect()
            let verticalDisplacement = keyboardHeight - UIScreen.mainScreen().bounds.height + imageRect.origin.y + imageRect.height
            view.frame.origin.y -= verticalDisplacement
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        // reset the view position
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        // returns a value for the keyboard's height
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.CGRectValue().height
    }

    @IBAction func selectImage(sender: UIBarButtonItem) {
        // prompts the user to select an image from the dialog
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func takeNewImage(sender: UIBarButtonItem) {
        // prompts the user to take an image with the camera
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(sender: UIBarButtonItem) {
        // check if default text is in either text field
        if topTextField.text == "TOP" || bottomTextField.text == "BOTTOM" {
            // remind the user to enter text
            let alertView = UIAlertController(title: "Save Failed", message: "Please enter text into both fields.", preferredStyle: UIAlertControllerStyle.Alert)
            alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            presentViewController(alertView, animated: true, completion: nil)
        } else {
            // close the keyboard if it is showing
            topTextField.resignFirstResponder()
            bottomTextField.resignFirstResponder()
            
            // create the meme and prompt the user for an action
            let memedImage = generateMemedImage()
            
            let activityView = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
            activityView.completionWithItemsHandler = {type, completed, items, error in
                if completed {
                    self.save(memedImage)
                    self.navigationController?.popViewControllerAnimated(true)
                }
            }
            presentViewController(activityView, animated: true, completion: nil)
        }
    }
    
    @IBAction func dismissView(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        // get the selected image
        self.image = image
        imageView.image = image
        
        // update the text fields for the image
        positionTextFields()
        topTextField.hidden = false
        bottomTextField.hidden = false
        
        // return to the editor view
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func save(memedImage: UIImage) {
        // creates a custom meme object and saves it to the memes array
        let memeObject = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: image, memedImage: memedImage)
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(memeObject)
    }
    
    func positionTextFields() {
        // moves the text fields based on the image location
        if image != nil {
            let imageRect = getImageRect()
            
            // position text fields with appropriate padding
            topTextFieldConstraint.constant = imageRect.origin.y + 8
            bottomTextFieldConstraint.constant = imageRect.origin.y + imageRect.height - bottomTextField.frame.height - 8
        }
    }
    
    func getImageRect() -> CGRect {
        // returns a CGRect that represents the coordinates, width, and height of the scaled image
        
        // determine image orientation with respect to the image view
        if image.size.width / image.size.height >= imageView.frame.width / imageView.frame.height {
            // image is "landscape"
            
            let posx = imageView.frame.origin.x // leftmost position of the image view
            let w = imageView.bounds.width // image width
            
            // determine how much the image had been stretched or shrunk
            let scaleRatio = imageView.frame.width / image.size.width
        
            let h = image.size.height * scaleRatio // image height
            
            // get the image's vertical distance from the top of the image view
            let offset = (imageView.frame.height - h) / 2
            
            // get pixel where image starts
            let posy = imageView.frame.origin.y + offset
            
            // generate object for image bounds and location
            let imageRect = CGRectMake(posx, posy, w, h)
        
            return imageRect
        } else {
            // image is "portrait"
            
            // determine how much the image had been stretched or shrunk
            let scaleRatio = imageView.frame.height / image.size.height
            
            // get the image's vertical distance from the top of the image view
            let offset = (imageView.frame.width - image.size.width * scaleRatio) / 2
            
            // generate object for image bounds and location
            let imageRect = CGRectMake(imageView.frame.origin.x + offset, imageView.frame.origin.y, image.size.width * scaleRatio, imageView.bounds.height)
            
            return imageRect
        }
    }
    
    func generateMemedImage() -> UIImage {
        // take a screenshot of the view
        UIGraphicsBeginImageContext(view.frame.size)
        self.view.drawViewHierarchyInRect(view.frame,
            afterScreenUpdates: true)
        let Screenshot : UIImage =
        UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // determine meme location and crop the screenshot accordingly
        let imageRect = getImageRect()

        let croppedImage: CGImageRef = CGImageCreateWithImageInRect(Screenshot.CGImage, imageRect)!
        
        let memedImage = UIImage(CGImage: croppedImage)
        
        return memedImage
    }
}
