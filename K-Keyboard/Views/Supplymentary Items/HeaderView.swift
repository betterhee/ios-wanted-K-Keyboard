//
//  HeaderView.swift
//  K-Keyboard
//
//  Created by sole on 2022/10/06.
//

import UIKit

final class HeaderView: UICollectionReusableView {
    
    private let themeImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        view.layer.shadowColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 1
        return view
    }()
    
    private let themeNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        return label
    }()
    
    private let themeNickNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let numberOfConsumerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .systemPink
        return label
    }()
    
    private let consumerDescriptionLabel: UILabel = {
       let label = UILabel()
        label.text = "명이 참여했어요!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        return label
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

    private func configure() {
        [
            themeImageView,
            themeNameLabel,
            themeNickNameLabel,
            numberOfConsumerLabel,
            consumerDescriptionLabel
        ].forEach { addSubview($0) }

        NSLayoutConstraint.activate([
            themeImageView.topAnchor.constraint(equalTo: topAnchor),
            themeImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            themeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            themeNameLabel.topAnchor.constraint(equalTo: themeImageView.bottomAnchor, constant: 20),
            themeNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            themeNickNameLabel.topAnchor.constraint(equalTo: themeNameLabel.bottomAnchor, constant: 10),
            themeNickNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),

            numberOfConsumerLabel.topAnchor.constraint(equalTo: themeNickNameLabel.bottomAnchor, constant: 20),
            numberOfConsumerLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            numberOfConsumerLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),

            consumerDescriptionLabel.centerYAnchor.constraint(equalTo: numberOfConsumerLabel.centerYAnchor),
            consumerDescriptionLabel.leadingAnchor.constraint(equalTo: numberOfConsumerLabel.trailingAnchor),
            consumerDescriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    func updateUI(with owner: Owner) {
        themeImageView.image = UIImage(named: owner.themeImagePath)
        themeNameLabel.text = owner.themeName
        themeNickNameLabel.text = owner.themeNickName
        numberOfConsumerLabel.text = String(owner.numberOfConsumer)
    }
}

