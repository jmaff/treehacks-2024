//
//  ClickableView.swift
//  Immersed IoT
//
//  Created by Joseph Maffetone on 2/17/24.
//

class ClickableView: UIButton{

    override init(frame: CGRect) {

    super.init(frame: frame)

    self.addTarget(self, action:  #selector(objectTapped(_:)), for: .touchUpInside)

    self.backgroundColor = .red

}

required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

/// Detects Which Object Was Tapped
///
/// - Parameter sender: UIButton
@objc func objectTapped(_ sender: UIButton){

    print("Object With Tag \(tag)")

   }

}
