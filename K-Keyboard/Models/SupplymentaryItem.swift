//
//  SupplymentaryItem.swift
//  K-Keyboard
//
//  Created by sole on 2022/10/06.
//

import UIKit

enum SupplymentaryItem: String, CaseIterable {
    case sectionHeader
    case header
    
    var size: NSCollectionLayoutSize {
        switch self {
        case .sectionHeader:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .absolute(65)
            )
        case .header:
            return NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(50)
            )
        }
    }

    var info: NSCollectionLayoutBoundarySupplementaryItem {
        NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: size,
            elementKind: rawValue,
            alignment: .top
        )
    }
}
