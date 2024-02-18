//
//  TagNode.swift
//  Immersed IoT
//
//  Created by Joseph Maffetone on 2/17/24.
//

import Foundation
import ARKit
import UIKit
import SwiftUI

class TagNode : SCNNode {
    public let id: Int
    var size: CGFloat
    
    private var titleNode: SCNNode?
    private var buttonNode: SCNNode?
    private var buttonLabelNode: SCNNode?
    
    var lastSeen: TimeInterval?
    
    init(thing: Thing, size: CGFloat) {
        self.id = thing.tagID
        self.size = size
        
        super.init()
        
        // backdrop
        let planeGeometry = SCNPlane(width: 0.15, height: 0.15)
        planeGeometry.cornerRadius = 0.02
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.gray
        material.transparency = 0.5 // Set the transparency level (0.0 to 1.0)
        material.lightingModel = .physicallyBased
        material.isDoubleSided = true
        
        planeGeometry.materials = [material]

        let planeNode = SCNNode(geometry: planeGeometry)
        addChildNode(planeNode)
        
        // circular button
        let buttonGeometry = SCNPlane(width: 0.1, height: 0.1)
        buttonGeometry.cornerRadius = 1
        let buttonMaterial = SCNMaterial()
        
        buttonMaterial.diffuse.contents = UIColor.systemBlue
        buttonMaterial.transparency = 0.5 // Set the transparency level (0.0 to 1.0)
        buttonMaterial.lightingModel = .physicallyBased
        buttonMaterial.isDoubleSided = true
        
        buttonGeometry.materials = [buttonMaterial]

        buttonNode = SCNNode(geometry: buttonGeometry)
        buttonNode!.position = SCNVector3(0, 0, 0.001) // Adjust the position as needed
        buttonNode!.name = Thing.getButtonName(tagID: self.id)

        addChildNode(buttonNode!)
        
        updateFromThing(thing: thing)
    }
    
    func setButtonLabelData(data: Double) {
        if let buttonLabel = self.buttonLabelNode {
            buttonLabel.removeFromParentNode()
        }
        
        let labelGeometry = SCNText(string: String(data), extrusionDepth: 0.1)
        
        let labelMaterial = SCNMaterial()
        labelMaterial.diffuse.contents = UIColor.white
        
        labelGeometry.materials = [labelMaterial]
        
        buttonLabelNode = SCNNode(geometry: labelGeometry)
        buttonLabelNode!.position = SCNVector3(-0.04, -0.03, 0.01)
        buttonLabelNode!.scale = SCNVector3(0.003,0.003,0.003)
        
        addChildNode(buttonLabelNode!)
    }
    
    func setButtonLabelImage(filename: String) {
        if let buttonLabel = self.buttonLabelNode {
            buttonLabel.removeFromParentNode()
        }
        
        let iconImage = UIImage(named: filename)
        let planeGeometry = SCNPlane(width: size, height: size)
        let imageMaterial = SCNMaterial()
        imageMaterial.diffuse.contents = iconImage
        planeGeometry.materials = [imageMaterial]

        buttonLabelNode = SCNNode(geometry: planeGeometry)
        buttonLabelNode!.position = SCNVector3(0, 0, 0.002)
        buttonLabelNode!.scale = SCNVector3(0.5, 0.5, 0.5)
        buttonLabelNode!.name = Thing.getButtonName(tagID: self.id)
        addChildNode(buttonLabelNode!)
    }
    
    func setTitleName(title: String) {
        if let titleLabel = self.titleNode {
            titleLabel.removeFromParentNode()
        }
        
        let labelGeometry = SCNText(string: title, extrusionDepth: 0.2)
//        labelGeometry.font = UIFont.systemFont(ofSize: 1)
//        labelGeometry.flatness = 0.1
        
        let labelMaterial = SCNMaterial()
        labelMaterial.diffuse.contents = UIColor.white
        
        labelGeometry.materials = [labelMaterial]
        
        titleNode = SCNNode(geometry: labelGeometry)
        titleNode!.position = SCNVector3(-0.06, 0.05, 0.01)
        titleNode!.scale = SCNVector3(0.001,0.001,0.003)
        
        addChildNode(titleNode!)
    }
    
    func updateFromThing(thing: Thing) {
        if thing.type.lowercased() == "led" {
            setButtonLabelImage(filename: "powerbutton.png")
        } else if thing.type != "Loading..." {
            setButtonLabelData(data: thing.mostRecentState)
        }

        setTitleName(title: String(format: "%@ (Tag #%d)", thing.type, thing.tagID))
        
    }
    
    func seen() {
        lastSeen = Date().timeIntervalSince1970
    }

    func hasExpired() -> Bool {
        guard let lastCheckTimestamp = lastSeen else {
            // If there is no last check timestamp, consider it has been more than 5 seconds
            return true
        }

        let currentTime = Date().timeIntervalSince1970
        let elapsedTime = currentTime - lastCheckTimestamp

        return elapsedTime > 5
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
