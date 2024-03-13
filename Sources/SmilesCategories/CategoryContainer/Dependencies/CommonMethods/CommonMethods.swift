//
//  File.swift
//  
//
//  Created by Habib Rehman on 12/03/2024.
//

import Foundation
import UIKit


struct CommonMethods {
    
    static func currentLanguage() -> Language {
        return .English
    }
    
    static func getLocalizedStringForKey(_ key: String) -> String {
        return key // Return the key itself for demonstration
    }
    
    
    static func applyLocalizedStrings(_ view: UIView) {
        for subView in view.subviews {
            if let subView = subView as? UIView {
                if subView.subviews.count > 0 {
                    // UIView
                    applyLocalizedStrings(subView)
                } else if let button = subView as? UIButton {
                    // UIButton
                    if button.tag == 90 {
                        if CommonMethods.currentLanguage() == .Arabic {
                            button.transform = CGAffineTransform(scaleX: -1, y: 1)
                        } else {
                            button.transform = CGAffineTransform.identity
                        }
                    }
                    
                    if let accessibilityHint = button.accessibilityHint, accessibilityHint.count > 0 {
                        button.setTitle(CommonMethods.getLocalizedStringForKey(accessibilityHint), for: .normal)
                    }
                } else if let label = subView as? UILabel {
                    // UILabel
                    if let accessibilityHint = label.accessibilityHint, accessibilityHint.count > 0 {
                        label.text = CommonMethods.getLocalizedStringForKey(accessibilityHint)
                    }
                } else if let textField = subView as? UITextField {
                    // UITextField
                    if let accessibilityHint = textField.accessibilityHint, accessibilityHint.count > 0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            textField.placeholder = CommonMethods.getLocalizedStringForKey(accessibilityHint)
                        }
                    }
                } else if let textView = subView as? UITextView {
                    // UITextView
                    if let accessibilityHint = textView.accessibilityHint, accessibilityHint.count > 0 {
                        textView.text = CommonMethods.getLocalizedStringForKey(accessibilityHint)
                    }
                } else if let imageView = subView as? UIImageView {
                    // UIImageView
                    if let accessibilityHint = imageView.accessibilityHint, accessibilityHint.count > 0 {
                        imageView.image = UIImage(named: CommonMethods.getLocalizedStringForKey(accessibilityHint))
                    }
                }
            }
        }
    }
}

enum Language {
    case Arabic
    case English
    // Add more languages if needed
}


