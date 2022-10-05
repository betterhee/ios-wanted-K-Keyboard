//
//  Foundation+Extension.swift
//  KoreanKeyboard
//
//  Created by 홍다희 on 2022/10/04.
//

import Foundation

extension String {
    /// 초성에 올 수 있는 낱글자인지 여부를 나타내는 Boolean 값입니다.
    var isLeadingConsonant: Bool {
        HangulComponentsTable.leadingConsonant.contains(self)
    }

    /// 중성에 올 수 있는 낱글자인지 여부를 나타내는 Boolean 값입니다.
    var isVowel: Bool {
        HangulComponentsTable.vowel.contains(self)
    }

    /// 종성에 올 수 있는 낱글자인지 여부를 나타내는 Boolean 값입니다.
    var isTrailingConsonant: Bool {
        HangulComponentsTable.trailingConsonant.contains(self)
    }

    var firstCharacterAsString: String {
        return first!.string
    }
}

extension Character {
    var string: String {
        return String(self)
    }
}

extension Array where Element == Unicode.Scalar {
    var string: String {
        self.map(String.init)
            .joined()
    }
}
