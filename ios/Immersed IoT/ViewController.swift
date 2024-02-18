//
//  ViewController.swift
//  Immersed IoT
//
//  Created by Joseph Maffetone on 2/17/24.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate, ARSessionObserver {

    @IBOutlet var sceneView: ARSCNView!
    var mutexlock = false;
    
    let ArucoMarkerSize = 0.133;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.showsStatistics = true
//        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        sceneView.delegate = self
        sceneView.session.delegate = self
        
        sceneView.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        sceneView.addGestureRecognizer(tapGesture)
        
        
    }
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(location, options: nil)

        for result in hitTestResults {
            if let nodeName = result.node.name, nodeName == "button" {
                print("Button pressed!")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.isLightEstimationEnabled = true
        configuration.worldAlignment = .gravity

        // Run the view's session
        sceneView.autoenablesDefaultLighting = true;
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func updateContentNodeCache(targTransforms: Array<SKWorldTransform>, cameraTransform:SCNMatrix4) {
        
        for transform in targTransforms {
            
            let targTransform = SCNMatrix4Mult(transform.transform, cameraTransform);
            
            if let box = findCube(arucoId: Int(transform.arucoId)) {
                box.setWorldTransform(targTransform);
                box.seen()
            } else {
                let arucoCube = TagNode(id: Int(transform.arucoId), size: ArucoMarkerSize)
                sceneView.scene.rootNode.addChildNode(arucoCube);
                arucoCube.setWorldTransform(targTransform);
                arucoCube.seen()
            }
        }
    }
    
    func findCube(arucoId:Int) -> TagNode? {
        for node in sceneView.scene.rootNode.childNodes {
            if node is TagNode {
                let box = node as! TagNode
                if (arucoId == box.id) {
                    return box
                }
            }
        }
        return nil
    }
    
    // MARK: - ARSessionDelegate

    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        
        if self.mutexlock {
            return;
        }

        self.mutexlock = true;
        for node in sceneView.scene.rootNode.childNodes {
            if node is TagNode {
                let tag = node as! TagNode
                if tag.hasExpired() {
                    node.removeFromParentNode()
                }
            }
        }
        
        let pixelBuffer = frame.capturedImage

        let transMatrixArray:Array<SKWorldTransform> = TagDetector.estimatePose(pixelBuffer, withIntrinsics: frame.camera.intrinsics, andMarkerSize: Float64(ArucoMarkerSize)) as! Array<SKWorldTransform>;

        if(transMatrixArray.count == 0) {
            self.mutexlock = false;
            return;
        }

        let cameraMatrix = SCNMatrix4.init(frame.camera.transform);
        
        DispatchQueue.main.async(execute: {
            self.updateContentNodeCache(targTransforms: transMatrixArray, cameraTransform:cameraMatrix)
            
            self.mutexlock = false;
        })
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
    }

    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//        NSLog("%s", __FUNC__)
    }
    
    func session(_ session: ARSession, didRemove anchors: [ARAnchor]) {
    }
    
    // MARK: - ARSessionObserver

    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
    }
    
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
    }
}
