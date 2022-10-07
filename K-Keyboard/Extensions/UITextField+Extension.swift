//
//  UITextField+Extension.swift
//  K-Keyboard
//
//  Created by 홍다희 on 2022/10/07.
//

import UIKit

extension UITextField {
    func clear() {
        text = ""
        attributedText = NSAttributedString(string: "")
    }
}
