//
//  ThemeViewController+.swift
//  K-Keyboard
//
//  Created by sole on 2022/10/06.
//

import UIKit

extension ThemeViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layout in
            let section = Section(rawValue: sectionIndex)!

            let sectionHeader = SupplymentaryItem.sectionHeader.info
            let header = SupplymentaryItem.header.info

            let spacing: CGFloat = 16
            let sectionSpacing = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
            let wideSectionSpacing = NSDirectionalEdgeInsets(top: spacing, leading: 0, bottom: spacing, trailing: 0)

            let item = NSCollectionLayoutItem(layoutSize: section.itemSize)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: section.groupSize, subitems: [item])

            switch section {
            case .event:
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                section.contentInsets = sectionSpacing
                section.boundarySupplementaryItems = [sectionHeader, header]
                return section
            case .tag:
                group.interItemSpacing = .fixed(4)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                section.contentInsets = sectionSpacing
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            case .reaction:
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                section.contentInsets = sectionSpacing
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            case .opinion:
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = sectionSpacing
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            case .banner:
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = wideSectionSpacing
                return section
            case .review:
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                section.contentInsets = sectionSpacing
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            }
        }
        return layout
    }
}
