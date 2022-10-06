//
//  TagCell.swift
//  K-Keyboard
//
//  Created by sole on 2022/10/06.
//

import UIKit

final class TagCell: UICollectionViewCell {

    enum Design {
        static let font: UIFont = .preferredFont(forTextStyle: .body)
        static let titleColor: UIColor = .label
        static let backgroundColor: UIColor = .tertiarySystemGroupedBackground
        static let cornerRadius: CGFloat = 18
        static let contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
    }

    private let tagButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.titleLabel?.font = Design.font
        button.setTitleColor(Design.titleColor, for: .normal)
        button.backgroundColor = Design.backgroundColor
        button.contentEdgeInsets = Design.contentEdgeInsets
        button.layer.cornerRadius = Design.cornerRadius
        return button
    }()

    // MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

    // MARK: Functions

    func configure() {
        contentView.addSubview(tagButton)

        NSLayoutConstraint.activate([
            tagButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tagButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tagButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            tagButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func updateUI(with item: Tag) {
        tagButton.setTitle(item.keyword, for: .normal)
    }

}
