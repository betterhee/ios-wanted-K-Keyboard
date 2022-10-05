//
//  Logger+Extension.swift
//  KoreanKeyboard
//
//  Created by 홍다희 on 2022/09/30.
//

import Foundation
import os

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let keyboard = Logger(subsystem: subsystem, category: "keyboard")
}
