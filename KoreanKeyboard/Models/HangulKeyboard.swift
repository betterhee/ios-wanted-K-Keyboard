//
//  HangulKeyboard.swift
//  KoreanKeyboard
//
//  Created by 홍다희 on 2022/10/03.
//

import Foundation
import os

class HangulKeyboard {

    // MARK: Type

    private enum State: String {
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
    func input(_ input: HangulKeyCommand) -> (String, String) {
        let before = fullText
        switch input {
        case .space, .nextLine:
            flush()
            editedText.append(input.rawValue)
            state = .none
        case .back:
            inputBack()
        default:
            inputLetter(input.rawValue)
        }
        let after = fullText
        return (before, after)
    }

    private func inputLetter(_ letter: String) {
        switch state {
        case .none: // empty, none
            if !letter.isVowel {
                buffer.addComponent(letter, for: .leadingConsonant)
                state = .leadingConsonant
            } else {
                buffer.addComponent(letter, for: .vowel)
                state = .singleVowel
            }
        case .leadingConsonant: // 자음, 모음, 받침1개 2개 - 초성
            if !letter.isVowel {
                flush()
                buffer.addComponent(letter, for: .leadingConsonant)
                state = .leadingConsonant
            } else {
                buffer.addComponent(letter, for: .vowel)
                state = .leadingConsonantAndSingleVowel
            }
        case .leadingConsonantAndSingleVowel:
            if !letter.isVowel {
                buffer.addComponent(letter, for: .trailingConsonant)
                state = .leadingConsonantAndVowelAndSingleTrailingConsonant
            } else {
                if (buffer.vowel.firstCharacterAsString + letter).isVowel {
                    buffer.addComponent(letter, for: .vowel)
                    state = .leadingConsonantAndDoubleVowel
                } else {
                    flush()
                    buffer.addComponent(letter, for: .vowel)
                    state = .singleVowel
                }
            }
        case .leadingConsonantAndDoubleVowel:
            if !letter.isVowel {
                if letter.isTrailingConsonant {
                    buffer.addComponent(letter, for: .trailingConsonant)
                    state = .leadingConsonantAndVowelAndSingleTrailingConsonant
                } else {
                    flush()
                    buffer.addComponent(letter, for: .leadingConsonant)
                    state = .leadingConsonant
                }
            } else {
                flush()
                buffer.addComponent(letter, for: .vowel)
                state = .singleVowel
            }
        case .leadingConsonantAndVowelAndSingleTrailingConsonant:
            if !letter.isVowel {
                if (buffer.trailingConsonant.firstCharacterAsString + letter).isTrailingConsonant {
                    buffer.addComponent(letter, for: .trailingConsonant)
                    state = .leadingConsonantAndVowelAndDoubleTrailingConsonant
                } else {
                    flush()
                    buffer.addComponent(letter, for: .leadingConsonant)
                    state = .leadingConsonant
                }
            } else {
                let lastTrailingConsonant = buffer.popLastComponent()
                flush()
                buffer.addComponent(lastTrailingConsonant!, for: .leadingConsonant)
                buffer.addComponent(letter, for: .vowel)
                state = .leadingConsonantAndSingleVowel
            }
        case .leadingConsonantAndVowelAndDoubleTrailingConsonant:
            if !letter.isVowel {
                flush()
                buffer.addComponent(letter, for: .leadingConsonant)
                state = .leadingConsonant
            } else {
                let lastTrailingConsonant = buffer.popLastComponent()
                flush()
                buffer.addComponent(lastTrailingConsonant!, for: .leadingConsonant)
                buffer.addComponent(letter, for: .vowel)
                state = .leadingConsonantAndSingleVowel
            }
        case .singleVowel:
            if !letter.isVowel {
                flush()
                buffer.addComponent(letter, for: .leadingConsonant)
                state = .leadingConsonant
            } else {
                if (buffer.vowel.firstCharacterAsString + letter).isVowel {
                    buffer.addComponent(letter, for: .vowel)
                    state = .doubleVowel
                } else {
                    flush()
                    buffer.addComponent(letter, for: .vowel)
                    state = .singleVowel
                }
            }
        case .doubleVowel:
            if !letter.isVowel {
                flush()
                buffer.addComponent(letter, for: .leadingConsonant)
                state = .leadingConsonant
            } else {
                flush()
                buffer.addComponent(letter, for: .vowel)
                state = .singleVowel
            }
        }
    }

    private func inputBack() {
        switch state {
        case .none:
            if !editedText.isEmpty {
                editedText.removeLast()
            }
        case .leadingConsonant:
            buffer.popLastComponent()
            state = .none
        case .leadingConsonantAndSingleVowel:
            buffer.popLastComponent()
            state = .leadingConsonant
        case .leadingConsonantAndDoubleVowel:
            buffer.popLastComponent()
            state = .leadingConsonantAndSingleVowel
        case .leadingConsonantAndVowelAndSingleTrailingConsonant:
            buffer.popLastComponent()
            state = buffer.vowel.count == 1 ?
                .leadingConsonantAndSingleVowel :
                .leadingConsonantAndDoubleVowel
        case .leadingConsonantAndVowelAndDoubleTrailingConsonant:
            buffer.popLastComponent()
            state = .leadingConsonantAndVowelAndSingleTrailingConsonant
        case .singleVowel:
            buffer.popLastComponent()
            state = .none
        case .doubleVowel:
            buffer.popLastComponent()
            state = .singleVowel
        }
    }

    /// 입력된 낱글자를 모아 입력 버퍼를 비운다.
    private func flush() {
        editedText.append(buffer.toSyllabel)
        buffer = HangulComponents()
    }

}
