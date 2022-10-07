//
//  ReviewCell.swift
//  K-Keyboard
//
//  Created by sole on 2022/10/06.
//

import UIKit

final class ReviewCell: UICollectionViewCell {

    // MARK: Properties

    private let profileImageView: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let ownerLabel: UILabel = {
        let label = PaddingLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .caption2)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .systemBackground
        label.backgroundColor = .systemPink
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.textAlignment = .center
        label.text = "크리에이터"
        return label
    }()
    
    private let view: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.8940888047, green: 0.8955119252, blue: 0.8738973737, alpha: 1)
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let vStackView: UIStackView = {
       let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 5
        view.alignment = .leading
        view.distribution = .fill
        return view
    }()
    
    private let nickNameLabel: UILabel = {
       let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        return label
    }()
    
    private let reviewLabel: UILabel = {
       let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.numberOfLines = 0
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .callout)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        return label
    }()
    
    private let reportButton: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), for: .normal)
        button.setTitle("신고", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
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

    private func configure() {
        [
            profileImageView,
            view,
            vStackView,
            timeLabel,
            reportButton,
            ownerLabel
        ].forEach { contentView.addSubview($0) }

        [nickNameLabel, reviewLabel].forEach { vStackView.addArrangedSubview($0) }

        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 60),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),

            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 20),
            view.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor),

            vStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            vStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            vStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            vStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),

            timeLabel.topAnchor.constraint(equalTo: vStackView.bottomAnchor, constant: 15),
            timeLabel.leadingAnchor.constraint(equalTo: vStackView.leadingAnchor),

            reportButton.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            reportButton.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 10),
            reportButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

            ownerLabel.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor, constant: -5),
            ownerLabel.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 5),
            ownerLabel.centerYAnchor.constraint(equalTo: profileImageView.bottomAnchor),
        ])
    }

    func updateUI(with item: Review) {
        profileImageView.image = UIImage(named: "profile.png")
        nickNameLabel.text = item.nickName
        reviewLabel.text = item.content
        ownerLabel.isHidden = !item.isOwner
        // TODO: - 시간계산하기 (현재시간 - 작성시간)
        let formatter = DateFormatter()
        formatter.dateFormat = "mm분"
        timeLabel.text = formatter.string(from: Date())
    }

}
