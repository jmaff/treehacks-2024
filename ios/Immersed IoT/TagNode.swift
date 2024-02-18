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
    
    init(id: Int, size: CGFloat) {
        self.id = id
        self.size = size
        
        super.init()
        
        // TODO: replace with interactive View
//        self.geometry = SCNBox(width: size, height: size, length: 0.05, chamferRadius: 0)
        
        self.geometry = SCNPlane(width: size, height: size)
        
        //2. Create A New Material
        let material = SCNMaterial()

        //3. Create A UIView As A Holder For Content
        let viewToAdd = UIView(frame: CGRect(x: 150, y: 150, width: 300, height: 300))
        viewToAdd.backgroundColor = .white

        //4. Create Two Subviews
        let thingView = ThingView()
        viewToAdd.addSubview(thingView)
//        let redView = UIView(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
//        redView.backgroundColor = .red
//        viewToAdd.addSubview(redView)
//
//        let cyanView = UIView(frame: CGRect(x: 110, y: 10, width: 100, height: 100))
//        cyanView.backgroundColor = .cyan
//        viewToAdd.addSubview(cyanView)

        //5. Set The Materials Contents
        material.diffuse.contents = viewToAdd

        //6. Set The 1st Material Of The Plane
        self.geometry?.firstMaterial = material
        material.isDoubleSided = true
        
//        self.geometry = SCNPlane(width: size, height: size)
//        self.geometry?.firstMaterial?.diffuse.contents = thingView
//        self.geometry?.firstMaterial?.isDoubleSided = true
        
//        let mat = SCNMaterial()
//        mat.diffuse.contents = UIColor.blue
//        self.geometry?.materials = [mat]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
