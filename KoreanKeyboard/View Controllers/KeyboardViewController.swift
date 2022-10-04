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
    private var keyboard: HangulKeyboard!

    // MARK: View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureKeyboard()
        configureKeyboardView()
    }

    private func configureKeyboard() {
        let beforeInput = textDocumentProxy.documentContextBeforeInput
        keyboard = HangulKeyboard(beforeInput: beforeInput)
    }

    // MARK: Actions

    @IBAction
    private func didTapLetterButton(_ sender: UIButton) {
        if shiftButton.isSelected { didTapShiftButton() }

        guard let keyCommand = sender.titleLabel?.text else { return }
        let result = keyboard.input(keyCommand)
        textDocumentProxy.replace(result.0, with: result.1)
    }

    @IBAction
    private func didTapShiftButton() {
        Logger.keyboard.debug(#function)
        shiftButton.isSelected.toggle()

        letterButtons.forEach { button in
            guard let title = button.titleLabel?.text,
                  let keyCommand = HangulKeyCommand(rawValue: title) else { return }
            button.setTitle(keyCommand.shifted.rawValue, for: .normal)
        }
    }

    @IBAction
    private func didTapEnterButton() {
        if shiftButton.isSelected { didTapShiftButton() }

        let output = keyboard.input("\n")
        textDocumentProxy.replace(output.0, with: output.1)
    }

    @IBAction
    private func didTapSpaceButton() {
        if shiftButton.isSelected { didTapShiftButton() }

        let result = keyboard.input(" ")
        textDocumentProxy.replace(result.0, with: result.1)
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
            button.backgroundColor = .tertiarySystemGroupedBackground
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.15).cgColor
            button.layer.shadowOpacity = 1
            button.layer.shadowRadius = 6
            button.layer.shadowOffset = CGSize(width: 0, height: 2)
        }
    }

}

