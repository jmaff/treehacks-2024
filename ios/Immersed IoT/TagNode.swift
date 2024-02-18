//
//  TagNode.swift
//  Immersed IoT
//
//  Created by Joseph Maffetone on 2/17/24.
//

import Foundation
import ARKit

class TagNode : SCNNode {
    public let id: Int
    var size: CGFloat
    
    init(id: Int, size: CGFloat) {
        self.id = id
        self.size = size
        
        super.init()
        
        // TODO: replace with interactive View
        self.geometry = SCNBox(width: size, height: size, length: 0.05, chamferRadius: 0)
        
        let mat = SCNMaterial()
        mat.diffuse.contents = UIColor.blue
        self.geometry?.materials = [mat]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
