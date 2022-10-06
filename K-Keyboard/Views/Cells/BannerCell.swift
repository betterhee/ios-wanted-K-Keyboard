//
//  BannerCell.swift
//  K-Keyboard
//
//  Created by sole on 2022/10/06.
//

import UIKit

final class BannerCell: UICollectionViewCell {

    // MARK: Properties

    private let bannerView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view 
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
        // TODO: - 이미지 비율 맞게
        //        contentMode = .scaleAspectFill
        contentView.addSubview(bannerView)

        NSLayoutConstraint.activate([
            bannerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            bannerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bannerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bannerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }

    func updateUI(with item: Banner) {
        bannerView.image = UIImage(named: item.imagePath)
    }
    
}
