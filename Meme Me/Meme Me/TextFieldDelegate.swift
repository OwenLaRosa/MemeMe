//
//  TextFieldDelegate.swift
//  Meme Me
//
//  Created by Owen LaRosa on 3/23/15.
//  Copyright (c) 2015 Owen LaRosa. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    var defaultText: String!
    
    init(defaultText: String) {
        self.defaultText = defaultText
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        // clears the text field when the user begins editing
        if textField.text == defaultText {
            textField.text = ""
        }
        textField.becomeFirstResponder()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // reverts to default text if text field is empty
        if textField.text == "" {
            textField.text = defaultText
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // dismiss the keyboard
        textField.resignFirstResponder()
        return true
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)
        
        // ensure all inserted text is capitalized
        textField.text = newText.uppercaseString
        return false
    }
}
