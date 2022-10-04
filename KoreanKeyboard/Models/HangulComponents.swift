//
//  HangulComponents.swift
//  KoreanKeyboard
//
//  Created by 홍다희 on 2022/10/04.
//

import Foundation

struct HangulComponents {

    // MARK: Type

    enum Component: CaseIterable {
        /// 초성 식별자
        case leadingConsonant
        /// 중성 식별자
        case vowel
        /// 종성 식별자
        case trailingConsonant
    }

    // MARK: Properties

    /// 초성
    private(set) var leadingConsonant = ""
    /// 중성
    private(set) var vowel = ""
    /// 종성
    private(set) var trailingConsonant = ""

    /// 초성, 중성, 종성을 결합하여 구성된 음절을 반환합니다.
    var toSyllabel: String {
        Component.allCases
            .compactMap { value(for: $0) }
            .string
    }

    // MARK: Functions

    /// 지정된 구성 요소에 낱글자를 추가합니다.
    mutating func addComponent(_ value: String, for component: Self.Component) {
        switch component {
        case .leadingConsonant:
            leadingConsonant += value
        case .vowel:
            vowel += value
        case .trailingConsonant:
            trailingConsonant += value
        }
    }

    /// 마지막 낱글자를 제거하고 반환합니다.
    @discardableResult
    mutating func popLastComponent() -> String? {
        if let last = trailingConsonant.popLast() {
            return last.string
        } else if let last = vowel.popLast() {
            return last.string
        } else if let last = leadingConsonant.popLast() {
            return last.string
        }
        return nil
    }

    /// 지정된 구성 요소의 Unicode Scalar 값을 반환합니다.
    private func value(for component: Self.Component) -> Unicode.Scalar? {
        switch component {
        case .leadingConsonant:
            guard let index =  HangulComponentsTable.leadingConsonant.firstIndex(of: leadingConsonant) else { return nil }
            return UnicodeScalar(0x1100 + index)
        case .vowel:
            guard let index =  HangulComponentsTable.vowel.firstIndex(of: vowel) else { return nil }
            return UnicodeScalar(0x1161 + index)
        case .trailingConsonant:
            guard let index =  HangulComponentsTable.trailingConsonant.firstIndex(of: trailingConsonant) else { return nil }
            return UnicodeScalar(0x11a8 + index)
        }
    }

}
