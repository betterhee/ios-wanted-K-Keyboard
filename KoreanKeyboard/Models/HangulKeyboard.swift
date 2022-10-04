//
//  HangulKeyboard.swift
//  KoreanKeyboard
//
//  Created by 홍다희 on 2022/10/03.
//

import Foundation

class HangulKeyboard {

    // MARK: Type

    private enum State {
        /// 버퍼가 비워진 상태
        case none
        /// 버퍼에 초성이 있는 상태
        case leadingConsonant
        /// 버퍼에 초성과 홑모음 중성이 있는 상태
        case leadingConsonantAndSingleVowel
        /// 버퍼에 초성과 겹모음 중성이 있는 상태
        case leadingConsonantAndDoubleVowel
        /// 버퍼에 초성, 중성과 홑받침이 있는 상태
        case leadingConsonantAndVowelAndSingleTrailingConsonant
        /// 버퍼에 초성, 중성, 겹받침이 있는 상태
        case leadingConsonantAndVowelAndDoubleTrailingConsonant
        /// 버퍼에 홑모음 중성이 있는 상태
        case singleVowel
        /// 버퍼에 겹모음 중성이 있는 상태
        case doubleVowel
    }

    // MARK: Properites

    /// 현재 편집 중인 텍스트를 처리하기 위한 버퍼 (임시 저장 공간)
    private var buffer: HangulComponents
    /// 버퍼의 상태
    private var state: State
    /// 편집이 끝난 텍스트
    private var editedText: String

    /// 현재 편집 중인 텍스트와 이전에 편집이 완료된 텍스트
    private var fullText: String {
        editedText + buffer.toSyllabel
    }

    // MARK: Init

    init(beforeInput: String?) {
        self.state = .none
        self.buffer = HangulComponents()
        self.editedText = beforeInput ?? ""
    }

    // MARK: Functions

    /// 입력 전 텍스트와 입력 후 텍스트를 반환합니다.
    func input(_ input: String) -> (String, String) {
        let before = fullText

        if let keyCommand = HangulKeyCommand(rawValue: input)?.rawValue {
            switch state {
            case .none: // empty, none
                if !keyCommand.isVowel {
                    buffer.addComponent(keyCommand, for: .leadingConsonant)
                    state = .leadingConsonant
                } else {
                    buffer.addComponent(keyCommand, for: .vowel)
                    state = .singleVowel
                }
            case .leadingConsonant: // 자음, 모음, 받침1개 2개 - 초성
                if !keyCommand.isVowel {
                    flush()
                    buffer.addComponent(keyCommand, for: .leadingConsonant)
                    state = .leadingConsonant
                } else {
                    buffer.addComponent(keyCommand, for: .vowel)
                    state = .leadingConsonantAndSingleVowel
                }
            case .leadingConsonantAndSingleVowel:
                if !keyCommand.isVowel {
                    buffer.addComponent(keyCommand, for: .trailingConsonant)
                    state = .leadingConsonantAndVowelAndSingleTrailingConsonant
                } else {
                    // TODO
                    if (buffer.vowel.firstCharacterAsString + keyCommand).isVowel {
                        buffer.addComponent(keyCommand, for: .vowel)
                        state = .leadingConsonantAndDoubleVowel
                    } else {
                        flush()
                        buffer.addComponent(keyCommand, for: .vowel)
                        state = .singleVowel
                    }
                }
            case .leadingConsonantAndDoubleVowel:
                if !keyCommand.isVowel {
                    if keyCommand.isTrailingConsonant {
                        buffer.addComponent(keyCommand, for: .trailingConsonant)

                        state = .leadingConsonantAndVowelAndSingleTrailingConsonant
                    } else {
                        flush()
                        buffer.addComponent(keyCommand, for: .leadingConsonant)
                        state = .leadingConsonant
                    }
                } else {
                    flush()
                    buffer.addComponent(keyCommand, for: .vowel)
                    state = .singleVowel
                }
            case .leadingConsonantAndVowelAndSingleTrailingConsonant:
                if !keyCommand.isVowel {
                    if (buffer.trailingConsonant.firstCharacterAsString + keyCommand).isTrailingConsonant {
                        buffer.addComponent(keyCommand, for: .trailingConsonant)
                        state = .leadingConsonantAndVowelAndDoubleTrailingConsonant
                    } else {
                        flush()
                        buffer.addComponent(keyCommand, for: .leadingConsonant)
                        state = .leadingConsonant
                    }
                } else {
                    let jongseong = buffer.popLastComponent()
                    flush()
                    buffer.addComponent(jongseong!, for: .leadingConsonant)
                    buffer.addComponent(keyCommand, for: .vowel)
                    state = .leadingConsonantAndSingleVowel
                }
            case .leadingConsonantAndVowelAndDoubleTrailingConsonant:
                if !keyCommand.isVowel {
                    flush()
                    buffer.addComponent(keyCommand, for: .leadingConsonant)
                    state = .leadingConsonant
                } else {
                    let jongseong = buffer.popLastComponent()
                    flush()
                    buffer.addComponent(jongseong!, for: .leadingConsonant)
                    buffer.addComponent(keyCommand, for: .vowel)
                    state = .leadingConsonantAndSingleVowel
                }
            case .singleVowel:
                if !keyCommand.isVowel {
                    flush()
                    buffer.addComponent(keyCommand, for: .leadingConsonant)
                    state = .leadingConsonant
                } else {
                    // TODO: 에러처리
                    if (buffer.vowel.firstCharacterAsString + keyCommand).isVowel {
                        buffer.addComponent(keyCommand, for: .vowel)
                        state = .doubleVowel
                    } else {
                        flush()
                        buffer.addComponent(keyCommand, for: .vowel)
                        state = .singleVowel
                    }
                }
            case .doubleVowel:
                if !keyCommand.isVowel {
                    flush()
                    buffer.addComponent(keyCommand, for: .leadingConsonant)
                    state = .leadingConsonant
                } else {
                    flush()
                    buffer.addComponent(keyCommand, for: .vowel)
                    state = .singleVowel
                }
            }
        } else {
            flush()
            editedText.append(input)
            state = .none
        }
        return (before, fullText)
    }

    /// 입력된 낱글자를 모아 입력 버퍼를 비운다.
    private func flush() {
        editedText.append(buffer.toSyllabel)
        buffer = HangulComponents()
    }

}
