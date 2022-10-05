//
//  HangulKeyCommand.swift
//  KoreanKeyboard
//
//  Created by 홍다희 on 2022/10/03.
//

import Foundation

enum HangulKeyCommand: String {
    case ㅂ
    case ㅈ
    case ㄷ
    case ㄱ
    case ㅅ
    case ㅃ
    case ㅉ
    case ㄸ
    case ㄲ
    case ㅆ
    case ㅁ
    case ㄴ
    case ㅇ
    case ㄹ
    case ㅎ
    case ㅋ
    case ㅌ
    case ㅊ
    case ㅍ
    case ㅛ
    case ㅕ
    case ㅑ
    case ㅐ
    case ㅔ
    case ㅒ
    case ㅖ
    case ㅗ
    case ㅓ
    case ㅏ
    case ㅣ
    case ㅠ
    case ㅜ
    case ㅡ
    case space = " "
    case nextLine = "\n"
    case back

    var isVowel: Bool {
        rawValue.isVowel
    }

    var shifted: HangulKeyCommand {
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
        default:
            return self
        }
    }
}
