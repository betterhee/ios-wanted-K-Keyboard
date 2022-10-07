//
//  UIScrollView+Extension.swift
//  K-Keyboard
//
//  Created by 홍다희 on 2022/10/07.
//

import UIKit

extension UIScrollView {
    func scrollToBottom(animated: Bool = true) {
        let offset: CGPoint = .init(
            x: contentOffset.x,
            y: max(0, contentSize.height - bounds.height) + contentInset.bottom
        )
        setContentOffset(offset, animated: animated)
    }
}
