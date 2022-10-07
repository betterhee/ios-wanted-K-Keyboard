//
//  PaddingLabel.swift
//  K-Keyboard
//
//  Created by 홍다희 on 2022/10/07.
//

import UIKit

class PaddingLabel: UILabel {
    private var padding = UIEdgeInsets(top: 2, left: 6, bottom: 2, right: 6)

    convenience init(padding: UIEdgeInsets) {
        self.init()
        self.padding = padding
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += padding.top + padding.bottom
        contentSize.width += padding.left + padding.right
        return contentSize
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
}

