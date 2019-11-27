//
//  PaddingTextField.swift
//  AllertyMessenger
//
//  Created by Ivan Ignatkov on 2019-11-26.
//  Copyright © 2019 TechCompetence. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class PaddingTextField: UITextField {
    
    
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray , NSAttributedString.Key.font : UIFont(name: "Helvetica", size: 15)! ])
        self.attributedPlaceholder = placeholder
    }
    
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
