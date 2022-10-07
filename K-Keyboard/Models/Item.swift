//
//  Item.swift
//  K-Keyboard
//
//  Created by sole on 2022/10/06.
//

import UIKit

enum Item: Hashable {
    case event(Event)
    case tag(Tag)
    case reaction(Reaction)
    case opinion(Opinion)
    case banner(Banner)
    case review(Review)
}

struct Event: Hashable {
    let content: String
}

struct Tag: Hashable {
    let keyword: String
}

struct Reaction: Hashable {
    let keyword: String
    let imagePath: String
}

struct Opinion: Hashable {
    let keyword: String
    let emoji: String
    let count = 0
}

struct Banner: Hashable {
    let imagePath: String
}

struct Review: Hashable {
    let content: String
    let nickName: String
    let time: Date
    let isOwner: Bool
}

struct Owner: Hashable {
    let name: String
    var themeName: String
    var themeNickName: String
    var themeImagePath: String
    var numberOfConsumer: Int
}

extension Review {
    init(content: String) {
        self.init(content: content, nickName: "o달밤o", time: Date(), isOwner: false)
    }
}
