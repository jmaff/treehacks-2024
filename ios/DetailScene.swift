//
//  DetailScene.swift
//  Immersed IoT
//
//  Created by Joseph Maffetone on 2/17/24.
//

import SpriteKit

class DetailScene: SKScene {

    override func didMove(to view: SKView) {
        // Create a clickable button
        let button = SKLabelNode(text: "Click me!")
        button.position = CGPoint(x: size.width / 2, y: size.height / 2)
        button.fontSize = 20
        button.fontColor = SKColor.white
        button.name = "clickableButton"
        addChild(button)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)

            // Check if the touched node is the clickable button
            if touchedNode.name == "clickableButton" {
                // Handle button click here
                print("Button clicked!")
            }
        }
    }
}
