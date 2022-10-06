//
//  ThemeViewController.swift
//  K-Keyboard
//
//  Created by sole on 2022/10/06.
//

import UIKit

final class ThemeViewController: UIViewController {
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
        configureSnapshot()
    }
    
    private func configureHierarchy() {
        collectionView = UICollectionView.init(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }
    
    private func configureDataSource() {
        let eventCellRegistration = eventCellRegistration()
        let tagCellRegistration = tagCellRegistration()
        let reactionCellRegistration = reactionCellRegistration()
        let opinionCellRegistration = opinionCellRegistration()
        let bannerCellRegistration = bannerCellRegistration()
        let reviewCellRegistration = reviewCellRegistration()
        let sectionHeaderViewRegistration = sectionHeaderViewRegistration()
        let headerViewRegistration = headerViewRegistration()
        let footerViewRegistration = footerViewRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(
            collectionView: collectionView,
            cellProvider: { collectionView, indexPath, identifier -> UICollectionViewCell? in
                switch identifier {
                case .event(let event):
                    return collectionView.dequeueConfiguredReusableCell(using: eventCellRegistration, for: indexPath, item: event)
                case .tag(let tag):
                    return collectionView.dequeueConfiguredReusableCell(using: tagCellRegistration, for: indexPath, item: tag)
                case .reaction(let reaction):
                    return collectionView.dequeueConfiguredReusableCell(using: reactionCellRegistration, for: indexPath, item: reaction)
                case .opinion(let opinion):
                    return collectionView.dequeueConfiguredReusableCell(using: opinionCellRegistration, for: indexPath, item: opinion)
                case .banner(let banner):
                    return collectionView.dequeueConfiguredReusableCell(using: bannerCellRegistration, for: indexPath, item: banner)
                case .review(let review):
                    return collectionView.dequeueConfiguredReusableCell(using: reviewCellRegistration, for: indexPath, item: review)
                }
            })
        
        dataSource.supplementaryViewProvider = { _, kind, index in
            switch kind {
            case SectionHeaderView.elementKind:
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: sectionHeaderViewRegistration,
                                                                                  for: index)
            case HeaderView.elementKind:
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerViewRegistration,
                                                                                  for: index)
            case FooterView.elementKind:
                return self.collectionView.dequeueConfiguredReusableSupplementary(using: footerViewRegistration, for: index)
            default: break
            }
            return nil
        }
    }
    
    private func configureSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        Section.allCases.forEach { section in
            snapshot.appendSections([section])
            snapshot.appendItems(MockDataController.shared.items(for: section), toSection: section)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

/// - CellRegistration
extension ThemeViewController {
    private func eventCellRegistration() -> UICollectionView.CellRegistration<EventCell, Event> {
        return UICollectionView.CellRegistration { cell, _, item in
            cell.updateUI(with: item)
        }
    }
    
    private func tagCellRegistration() -> UICollectionView.CellRegistration<TagCell, Tag> {
        return UICollectionView.CellRegistration { cell, _, item in
            cell.updateUI(with: item)
        }
    }
    
    private func reactionCellRegistration() -> UICollectionView.CellRegistration<ReactionCell, Reaction> {
        return UICollectionView.CellRegistration { cell, _, item in
            cell.updateUI(with: item)
        }
    }
    
    private func opinionCellRegistration() -> UICollectionView.CellRegistration<OpinionCell, Opinion> {
        return UICollectionView.CellRegistration { cell, _, item in
            cell.updateUI(with: item)
        }
    }
    
    private func bannerCellRegistration() -> UICollectionView.CellRegistration<BannerCell, Banner> {
        return UICollectionView.CellRegistration { cell, _, item in
            cell.updateUI(with: item)
        }
    }
    
    private func reviewCellRegistration() -> UICollectionView.CellRegistration<ReviewCell, Review> {
        return UICollectionView.CellRegistration { cell, _, item in
            cell.updateUI(with: item)
        }
    }
    
    private func sectionHeaderViewRegistration() -> UICollectionView.SupplementaryRegistration<SectionHeaderView> {
        return UICollectionView.SupplementaryRegistration<SectionHeaderView>(
            elementKind: SectionHeaderView.elementKind,
            handler: { supplementaryView, _, indexPath in
                guard let section = Section(rawValue: indexPath.section) else { return }
                if case .review = section {
                    let snapshot = self.dataSource.snapshot()
                    let numberOfReviews = snapshot.numberOfItems(inSection: section)
                    supplementaryView.updateUI(section.title, numberOfReviews - 1)
                } else {
                    supplementaryView.updateUI(section.title, nil)
                }
            })
    }
    
    private func headerViewRegistration() -> UICollectionView.SupplementaryRegistration<HeaderView> {
        return UICollectionView.SupplementaryRegistration(
            elementKind: HeaderView.elementKind
        ) { supplementaryView, _, _ in
            var owner = Owner(nickName: "크리에이터명", themeName: "앙무", themeNickName: "코핀", themeImagePath: "theme.png")
            owner.numberOfConsumer = 78
            supplementaryView.updateUI(owner: owner)
        }
    }
    
    private func footerViewRegistration() -> UICollectionView.SupplementaryRegistration<FooterView> {
        return UICollectionView.SupplementaryRegistration(elementKind: FooterView.elementKind) { supplementaryView, _, _ in
            // TODO: - update할꺼 아직 없음
            supplementaryView.updateUI()
        }
    }
}
