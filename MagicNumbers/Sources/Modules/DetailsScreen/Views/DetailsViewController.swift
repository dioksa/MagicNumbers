//
//  DetailsViewController.swift
//  MagicNumbers
//
//  Created by Oksana Dionisieva on 18.09.2025.
//

import UIKit

final class DetailsViewController: UIViewController {
    @IBOutlet private var numberLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var numberBackgroudView: UIView!

    private var numberText: String?
    private var factText: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About the number"
        configureLabel()
        numberLabel.text = numberText
        descriptionLabel.text = factText
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        numberLabel.text = nil
        descriptionLabel.text = nil
    }

    // MARK: - Public method
    func configure(with number: String?, fact: String?) {
        numberText = number
        factText = fact
    }

    // MARK: - Private method
    private func configureLabel() {
        numberBackgroudView.layer.cornerRadius = 12
        numberBackgroudView.layer.masksToBounds = false

        numberBackgroudView.layer.shadowColor = UIColor.black.cgColor
        numberBackgroudView.layer.shadowOpacity = 0.4
        numberBackgroudView.layer.shadowOffset = CGSize(width: 0, height: 6)
        numberBackgroudView.layer.shadowRadius = 10
        numberBackgroudView.layer.shadowPath = UIBezierPath(roundedRect: numberBackgroudView.bounds, cornerRadius: 12).cgPath
    }
}
