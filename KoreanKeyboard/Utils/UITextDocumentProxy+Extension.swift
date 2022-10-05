//
//  UITextDocumentProxy+Extension.swift
//  KoreanKeyboard
//
//  Created by 홍다희 on 2022/10/03.
//

import UIKit

extension UITextDocumentProxy {
    /// 지정된 텍스트를 다른 텍스트로 대체합니다.
    func replace(_ originalText: String, with newText: String) {
        let offset = originalText.count
        adjustTextPosition(byCharacterOffset: offset)
        deleteBackward(offset)
        insertText(newText)
    }

    /// 텍스트에서 지정된 수의 문자를 제거합니다.
    func deleteBackward(_ k: Int) {
        for _ in 0..<k { deleteBackward() }
    }
}

