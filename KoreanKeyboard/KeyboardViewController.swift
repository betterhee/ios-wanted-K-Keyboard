//
//  KeyboardViewController.swift
//  KoreanKeyboard
//
//  Created by 홍다희 on 2022/09/30.
//

import UIKit
import os

final class KeyboardViewController: UIInputViewController {
    @IBOutlet private var letterButtons: [UIButton]!
    @IBOutlet var shiftButton: UIButton!

    private var keyboardView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureKeyboardView()
    }

    @IBAction
    private func didTapLetterButton(_ sender: UIButton) {
        if shiftButton.isSelected { didTapShiftButton() }

        guard let letter = sender.titleLabel?.text else { return }
        textDocumentProxy.insertText(letter)
    }

    @IBAction
    private func didTapShiftButton() {
        Logger.keyboard.debug(#function)
        shiftButton.isSelected.toggle()
        letterButtons.forEach { button in
            guard let letter = button.titleLabel?.text,
                  let caseSensitiveLetter = CaseSensitiveLetter(rawValue: letter) else { return }
            button.setTitle(caseSensitiveLetter.shiftedLetter.rawValue, for: .normal)
        }
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

