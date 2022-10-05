//
//  KeyboardViewController.swift
//  KoreanKeyboard
//
//  Created by 홍다희 on 2022/09/30.
//

import UIKit
import os

final class KeyboardViewController: UIInputViewController {

    // MARK: Properties

    @IBOutlet private var letterButtons: [UIButton]!
    @IBOutlet private var shiftButton: UIButton!

    private var keyboardView: UIView!
    private var keyboard: Keyboard!

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureKeyboard()
        configureKeyboardView()
    }

    private func configureKeyboard() {
        let beforeText = textDocumentProxy.documentContextBeforeInput
        keyboard = Keyboard(beforeText: beforeText)
    }

    // MARK: Actions

    @IBAction
    private func didTapLetterButton(_ sender: UIButton) {
        if shiftButton.isSelected { didTapShiftButton() }

        guard let title = sender.titleLabel?.text,
              let letter = HangulKeyCommand(rawValue: title) else { return }
        let output = keyboard.input(.letter(letter))
        textDocumentProxy.replace(output.beforeText, with: output.afterText)
    }

    @IBAction
    private func didTapShiftButton() {
        Logger.keyboard.debug(#function)
        shiftButton.isSelected.toggle()

        letterButtons.forEach { button in
            guard let title = button.titleLabel?.text,
                  let letter = HangulKeyCommand(rawValue: title) else { return }
            button.setTitle(letter.shifted.rawValue, for: .normal)
        }
    }

    @IBAction
    private func didTapEnterButton() {
        if shiftButton.isSelected { didTapShiftButton() }

        let output = keyboard.input(.nextLine)
        textDocumentProxy.replace(output.beforeText, with: output.afterText)
    }

    @IBAction
    private func didTapSpaceButton() {
        if shiftButton.isSelected { didTapShiftButton() }

        let output = keyboard.input(.space)
        textDocumentProxy.replace(output.beforeText, with: output.afterText)
    }

    @IBAction func didTapBackButton() {
        if shiftButton.isSelected { didTapShiftButton() }

        let output = keyboard.input(.back)
        textDocumentProxy.replace(output.beforeText, with: output.afterText)
    }

}

// MARK: - UI

private extension KeyboardViewController {

    func configureKeyboardView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "KeyboardView", bundle: bundle)
        keyboardView = nib.instantiate(withOwner: self).first as? UIView
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(keyboardView)
        NSLayoutConstraint.activate([
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor),
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        keyboardView.backgroundColor = view.backgroundColor
        configureButtons()
    }

    func configureButtons() {
        letterButtons.forEach { button in
            button.backgroundColor = Design.backgroundColor
            button.layer.shadowColor = Design.shadowColor
            button.layer.shadowOpacity = Design.shadowOpacity
            button.layer.shadowRadius = Design.shadowRadius
            button.layer.shadowOffset = Design.shadownOffset
        }
    }

    enum Design {
        static let backgroundColor: UIColor = .tertiarySystemGroupedBackground
        static let shadowColor: CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
        static let shadowOpacity: Float = 1
        static let shadowRadius: CGFloat = 6
        static let shadownOffset: CGSize = .init(width: 0, height: 2)
    }

}

