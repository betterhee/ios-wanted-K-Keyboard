//
//  CaseSensitiveLetter.swift
//  KoreanKeyboard
//
//  Created by 홍다희 on 2022/09/30.
//

import Foundation

enum CaseSensitiveLetter: String {
    case ㅂ, ㅈ, ㄷ, ㄱ, ㅅ, ㅐ, ㅔ, ㅃ, ㅉ, ㄸ, ㄲ, ㅆ, ㅒ, ㅖ

    var shiftedLetter: CaseSensitiveLetter {
        switch self {
        case .ㅂ: return .ㅃ
        case .ㅈ: return .ㅉ
        case .ㄷ: return .ㄸ
        case .ㄱ: return .ㄲ
        case .ㅅ: return .ㅆ
        case .ㅐ: return .ㅒ
        case .ㅔ: return .ㅖ
        case .ㅃ: return .ㅂ
        case .ㅉ: return .ㅈ
        case .ㄸ: return .ㄷ
        case .ㄲ: return .ㄱ
        case .ㅆ: return .ㅅ
        case .ㅒ: return .ㅐ
        case .ㅖ: return .ㅔ
        }
    }
}
