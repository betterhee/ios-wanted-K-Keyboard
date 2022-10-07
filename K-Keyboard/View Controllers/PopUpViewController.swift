//
//  PopUpViewController.swift
//  K-Keyboard
//
//  Created by sole on 2022/10/07.
//

import UIKit

class PopUpViewController: UIViewController {
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var chargeButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtonTitleAppearance()
    }
    
    private func configureButtonTitleAppearance() {
        leftButton.setTitle("", for: .normal)
        rightButton.setTitle("", for: .normal)
        chargeButton.contentEdgeInsets = UIEdgeInsets(top: 4, left: 10, bottom: 4, right: 10)
    }
}
