//
//  ThingView.swift
//  Immersed IoT
//
//  Created by Joseph Maffetone on 2/17/24.
//

import UIKit

class ThingView: UIView {
    var button: UIButton = {
        let button = ClickableView(type: .system)
        button.setTitle("Press me", for: .normal)
        button.configuration = .filled()
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }

    func setupUI() {
        backgroundColor = UIColor.white

        // Add button to the view
        addSubview(button)

        // Set up button constraints to center it in the view
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }

    @objc func buttonPressed() {
        // Add your button action here
        print("Button pressed!")
    }
}
