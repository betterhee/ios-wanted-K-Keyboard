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

            let sectionHeader = SupplymentaryItem.sectionHeader.info
            let header = SupplymentaryItem.header.info
            let footer = SupplymentaryItem.footer.info

            let spacing = CGFloat(16)
            let sectionSpacing = NSDirectionalEdgeInsets(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
            let wideSectionSpacint = NSDirectionalEdgeInsets(top: spacing, leading: 0, bottom: spacing, trailing: 0)


            switch sectionIndex {
            case 0:
                let item = NSCollectionLayoutItem(layoutSize: Section.event.itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: Section.event.groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                section.contentInsets = sectionSpacing
                section.boundarySupplementaryItems = [sectionHeader, header]
                return section
            case 1:
                let item = NSCollectionLayoutItem(layoutSize: Section.tag.itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: Section.tag.groupSize, subitems: [item])
                group.interItemSpacing = .fixed(spacing)
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                section.contentInsets = sectionSpacing
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            case 2:
                let item = NSCollectionLayoutItem(layoutSize: Section.reaction.itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: Section.reaction.groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                section.contentInsets = sectionSpacing
                section.orthogonalScrollingBehavior = .continuous
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            case 3:
                let item = NSCollectionLayoutItem(layoutSize: Section.opinion.itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: Section.opinion.groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = sectionSpacing
                section.boundarySupplementaryItems = [sectionHeader]
                return section
            case 4:
                let item = NSCollectionLayoutItem(layoutSize: Section.banner.itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: Section.banner.groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = wideSectionSpacint
                return section
            default:
                let item = NSCollectionLayoutItem(layoutSize: Section.review.itemSize)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: Section.review.groupSize, subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = spacing
                section.contentInsets = sectionSpacing
                section.boundarySupplementaryItems = [sectionHeader, footer]
                return section
            }
        }
        return layout
    }
}
