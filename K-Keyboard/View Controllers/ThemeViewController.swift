//
//  ThemeViewController.swift
//  K-Keyboard
//
//  Created by sole on 2022/10/06.
//

import UIKit

final class ThemeViewController: UIViewController {
    
    @IBOutlet private var reviewTextField: UITextField!
    @IBOutlet private var toolbar: UIToolbar!
    @IBOutlet private var purchaseOrSaveButton: UIButton!
    @IBOutlet private var purchaseInformationView: UIStackView!
    @IBOutlet private var toolbarBottomContraint: NSLayoutConstraint!

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
    private var isPurchased: Bool = false

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureHierarchy()
        configureDataSource()
        configureSnapshot()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        addKeyboardNoticiationObserver()
    }

    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)

        removeKeyboardNotificationObserver()
    }

    // MARK: Functions

    private func configureHierarchy() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground

        view.insertSubview(collectionView, at: 0)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: toolbar.topAnchor),
        ])
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
            guard let kind = SupplymentaryItem(rawValue: kind) else { return nil }
            switch kind {
            case .sectionHeader:
                return self.collectionView.dequeueConfiguredReusableSupplementary(
                    using: sectionHeaderViewRegistration,
                    for: index
                )
            case .header:
                return self.collectionView.dequeueConfiguredReusableSupplementary(
                    using: headerViewRegistration,
                    for: index
                )
            }
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

    // MARK: Action Handlers

    @IBAction
    private func didTapPruchaseAndSaveButton() {
        if !isPurchased {
            isPurchased = true
            reviewTextField.isHidden = false
            purchaseOrSaveButton.setTitle("작성", for: .normal)
            purchaseInformationView.removeFromSuperview()
        } else {
            didTapSaveButton()
        }
    }

    private func didTapSaveButton() {
        if let content = reviewTextField.text,
           !content.isEmpty {
            let review: Item = .review(.init(content: content))
            var snapshot = dataSource.snapshot()
            snapshot.appendItems([review], toSection: .review)
            dataSource.apply(snapshot)
        }
        reviewTextField.clear()
        view.endEditing(true)
        collectionView.scrollToBottom(animated: false)
    }

    // MARK: Keyboard

    private func addKeyboardNoticiationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardNotificationObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc
    private func willShowKeyboard(_ notification: Notification) {
        if let userInfo = notification.userInfo,
           let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height
            toolbarBottomContraint.constant = keyboardHeight
        }
    }

    @objc
    private func willHideKeyboard(_ notification: Notification) {
        toolbarBottomContraint.constant = 0
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
            elementKind: SupplymentaryItem.sectionHeader.rawValue
        ) { supplementaryView, _, indexPath in
            guard let section = Section(rawValue: indexPath.section) else { return }
            if case .review = section {
                let snapshot = self.dataSource.snapshot()
                let numberOfReviews = snapshot.numberOfItems(inSection: section)
                supplementaryView.updateUI(section.title, numberOfReviews - 1)
            } else {
                supplementaryView.updateUI(section.title, nil)
            }
        }
    }
    
    private func headerViewRegistration() -> UICollectionView.SupplementaryRegistration<HeaderView> {
        return UICollectionView.SupplementaryRegistration(
            elementKind: SupplymentaryItem.header.rawValue
        ) { supplementaryView, _, _ in
            let owner = Owner(
                name: "크리에이터네임",
                themeName: "앙무",
                themeNickName: "코핀",
                themeImagePath: "theme.png",
                numberOfConsumer: 78
            )
            supplementaryView.updateUI(with: owner)
        }
    }
}
