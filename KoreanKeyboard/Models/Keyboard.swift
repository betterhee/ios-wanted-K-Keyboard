//
//  Keyboard.swift
//  KoreanKeyboard
//
//  Created by 홍다희 on 2022/10/03.
//

import Foundation
import os

class Keyboard {

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

    typealias OutputText = (beforeText: String, afterText: String)

    // MARK: Properites

    /// 입력 텍스트 중 현재 편집 중인 텍스트를 처리하기 위한 임시 저장 공간
    private var inputTextBuffer: HangulComponents
    /// 현재 버퍼의 상태
    private var state: State
    /// 편집이 완료된 입력 텍스트
    private var inputText: String

    /// 현재 편집 중인 텍스트와 편집이 완료된 텍스트
    private var outputText: String {
        inputText + inputTextBuffer.toSyllabel
    }

    // MARK: Init

    init(beforeText: String?) {
        self.state = .none
        self.inputTextBuffer = HangulComponents()
        self.inputText = beforeText ?? ""
    }

    // MARK: Functions

    /// 입력 전 텍스트와 입력 후 텍스트를 반환합니다.
    func input(_ keyCommand: KeyCommand) -> OutputText {
        let beforeOuputText = outputText

        switch keyCommand {
        case .space:
            performSpaceKeyCommand()
        case .nextLine:
            performNextLineKeyCommand()
        case .back:
            performBackspace()
        case let .letter(letter):
            performLetterKeyCommand(letter)
        }

        return (beforeOuputText, outputText)
    }

    private func performSpaceKeyCommand() {
        flush()
        inputText.append(" ")
        state = .none
    }

    private func performNextLineKeyCommand() {
        flush()
        inputText.append("\n")
        state = .none
    }

    private func performLetterKeyCommand(_ keyCommand: HangulKeyCommand) {
        let value = keyCommand.rawValue
        switch state {
        case .none:
            if !value.isVowel {
                inputTextBuffer.addComponent(value, for: .leadingConsonant)
                state = .leadingConsonant
            } else {
                inputTextBuffer.addComponent(value, for: .vowel)
                state = .singleVowel
            }
        case .leadingConsonant:
            if !value.isVowel {
                flush()
                inputTextBuffer.addComponent(value, for: .leadingConsonant)
                state = .leadingConsonant
            } else {
                inputTextBuffer.addComponent(value, for: .vowel)
                state = .leadingConsonantAndSingleVowel
            }
        case .leadingConsonantAndSingleVowel:
            if !value.isVowel {
                inputTextBuffer.addComponent(value, for: .trailingConsonant)
                state = .leadingConsonantAndVowelAndSingleTrailingConsonant
            } else {
                if (inputTextBuffer.vowel.firstCharacterAsString + value).isVowel {
                    inputTextBuffer.addComponent(value, for: .vowel)
                    state = .leadingConsonantAndDoubleVowel
                } else {
                    flush()
                    inputTextBuffer.addComponent(value, for: .vowel)
                    state = .singleVowel
                }
            }
        case .leadingConsonantAndDoubleVowel:
            if !value.isVowel {
                if value.isTrailingConsonant {
                    inputTextBuffer.addComponent(value, for: .trailingConsonant)
                    state = .leadingConsonantAndVowelAndSingleTrailingConsonant
                } else {
                    flush()
                    inputTextBuffer.addComponent(value, for: .leadingConsonant)
                    state = .leadingConsonant
                }
            } else {
                flush()
                inputTextBuffer.addComponent(value, for: .vowel)
                state = .singleVowel
            }
        case .leadingConsonantAndVowelAndSingleTrailingConsonant:
            if !value.isVowel {
                if (inputTextBuffer.trailingConsonant.firstCharacterAsString + value).isTrailingConsonant {
                    inputTextBuffer.addComponent(value, for: .trailingConsonant)
                    state = .leadingConsonantAndVowelAndDoubleTrailingConsonant
                } else {
                    flush()
                    inputTextBuffer.addComponent(value, for: .leadingConsonant)
                    state = .leadingConsonant
                }
            } else {
                let lastTrailingConsonant = inputTextBuffer.popLastComponent()
                flush()
                inputTextBuffer.addComponent(lastTrailingConsonant!, for: .leadingConsonant)
                inputTextBuffer.addComponent(value, for: .vowel)
                state = .leadingConsonantAndSingleVowel
            }
        case .leadingConsonantAndVowelAndDoubleTrailingConsonant:
            if !value.isVowel {
                flush()
                inputTextBuffer.addComponent(value, for: .leadingConsonant)
                state = .leadingConsonant
            } else {
                let lastTrailingConsonant = inputTextBuffer.popLastComponent()
                flush()
                inputTextBuffer.addComponent(lastTrailingConsonant!, for: .leadingConsonant)
                inputTextBuffer.addComponent(value, for: .vowel)
                state = .leadingConsonantAndSingleVowel
            }
        case .singleVowel:
            if !value.isVowel {
                flush()
                inputTextBuffer.addComponent(value, for: .leadingConsonant)
                state = .leadingConsonant
            } else {
                if (inputTextBuffer.vowel.firstCharacterAsString + value).isVowel {
                    inputTextBuffer.addComponent(value, for: .vowel)
                    state = .doubleVowel
                } else {
                    flush()
                    inputTextBuffer.addComponent(value, for: .vowel)
                    state = .singleVowel
                }
            }
        case .doubleVowel:
            if !value.isVowel {
                flush()
                inputTextBuffer.addComponent(value, for: .leadingConsonant)
                state = .leadingConsonant
            } else {
                flush()
                inputTextBuffer.addComponent(value, for: .vowel)
                state = .singleVowel
            }
        }
    }

    private func performBackspace() {
        switch state {
        case .none:
            if !inputText.isEmpty {
                inputText.removeLast()
            }
        case .leadingConsonant:
            inputTextBuffer.popLastComponent()
            state = .none
        case .leadingConsonantAndSingleVowel:
            inputTextBuffer.popLastComponent()
            state = .leadingConsonant
        case .leadingConsonantAndDoubleVowel:
            inputTextBuffer.popLastComponent()
            state = .leadingConsonantAndSingleVowel
        case .leadingConsonantAndVowelAndSingleTrailingConsonant:
            inputTextBuffer.popLastComponent()
            state = inputTextBuffer.vowel.count == 1 ?
                .leadingConsonantAndSingleVowel :
                .leadingConsonantAndDoubleVowel
        case .leadingConsonantAndVowelAndDoubleTrailingConsonant:
            inputTextBuffer.popLastComponent()
            state = .leadingConsonantAndVowelAndSingleTrailingConsonant
        case .singleVowel:
            inputTextBuffer.popLastComponent()
            state = .none
        case .doubleVowel:
            inputTextBuffer.popLastComponent()
            state = .singleVowel
        }
    }

    /// 입력 버퍼를 비웁니다.
    private func flush() {
        inputText.append(inputTextBuffer.toSyllabel)
        inputTextBuffer = HangulComponents()
    }

}
