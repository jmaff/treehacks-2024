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
    
    private var planeGeometry: SCNPlane!
    private var buttonNode: SCNNode!
    var lastSeen: TimeInterval?
    
    init(id: Int, size: CGFloat) {
        self.id = id
        self.size = size
        
        super.init()
        
        planeGeometry = SCNPlane(width: 0.15, height: 0.15)
        planeGeometry.cornerRadius = 0.02
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.gray
        material.transparency = 0.5 // Set the transparency level (0.0 to 1.0)
        material.lightingModel = .physicallyBased
        material.isDoubleSided = true
        
        planeGeometry.materials = [material]

        let planeNode = SCNNode(geometry: planeGeometry)
        addChildNode(planeNode)
        
        let buttonGeometry = SCNPlane(width: 0.1, height: 0.1)
        buttonGeometry.cornerRadius = 1
        let buttonMaterial = SCNMaterial()
        
        buttonMaterial.diffuse.contents = UIColor.white
        buttonMaterial.transparency = 0.5 // Set the transparency level (0.0 to 1.0)
        buttonMaterial.lightingModel = .physicallyBased
        buttonMaterial.isDoubleSided = true
        
        buttonGeometry.materials = [buttonMaterial]

        buttonNode = SCNNode(geometry: buttonGeometry)
        buttonNode.position = SCNVector3(0, 0, 0.001) // Adjust the position as needed
        buttonNode.name = "button"
        
//        let labelGeometry = SCNText(string: "Toggle", extrusionDepth: 0.5)
//        labelGeometry.scale = SCNVector3(0.01,0.01,0.01)
//        labelGeometry.font = UIFont.systemFont(ofSize: 1)
//        labelGeometry.flatness = 0.1
        
//        let labelMaterial = SCNMaterial()
//        labelMaterial.diffuse.contents = UIColor.blue
//        
//        labelGeometry.materials = [labelMaterial]
//        
//        let labelNode = SCNNode(geometry: labelGeometry)
//        labelNode.position = SCNVector3(0, 0, 0.01)
//        labelNode.scale = SCNVector3(0.001,0.001,0.001)

        addChildNode(buttonNode)
        addButtonLabel()
    }
    
    func addButtonLabel() {
        let iconImage = UIImage(named: "powerbutton.png")
        let planeGeometry = SCNPlane(width: size, height: size)
        let imageMaterial = SCNMaterial()
        imageMaterial.diffuse.contents = iconImage
        planeGeometry.materials = [imageMaterial]

        let planeNode = SCNNode(geometry: planeGeometry)
        planeNode.position = SCNVector3(0, 0, 0.002)
        planeNode.scale = SCNVector3(0.5, 0.5, 0.5)
        addChildNode(planeNode)
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
