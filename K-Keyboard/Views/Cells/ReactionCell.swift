//
//  ReactionCell.swift
//  K-Keyboard
//
//  Created by sole on 2022/10/06.
//

import UIKit

final class ReactionCell: UICollectionViewCell {

    // MARK: Properties
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 15
        view.alignment = .center
        view.distribution = .fill
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private let imageView = UIImageView()
    
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
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
        layer.shadowColor = UIColor.systemGray5.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 8
        layer.shadowOpacity = 1
        contentView.layer.cornerRadius = 15
        contentView.backgroundColor = .systemBackground

        contentView.addSubview(stackView)
        [imageView, keywordLabel].forEach { stackView.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),

            imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)
        ])
    }

    func updateUI(with item: Reaction) {
        imageView.image = UIImage(named: item.imagePath)
        keywordLabel.text = item.keyword
    }

}
