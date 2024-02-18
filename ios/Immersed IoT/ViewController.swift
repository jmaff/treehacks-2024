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
    
    // tagID -> Thing
    var things: [Int: Thing] = [
        77: Thing(tagID: 77, particleID: "todo", type: "Loading...", mostRecentState: 0.0),
        55: Thing(tagID: 55, particleID: "todo", type: "Loading...", mostRecentState: 0.0),
    ]
    
    func fetchThingAndUpdateDictionary(tagID: Int) {
        let requestData: [String: Any] = ["tagID": tagID]

        if let url = URL(string: "https://5vq78p52f0.execute-api.us-east-1.amazonaws.com/prod/getDeviceState") {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: requestData, options: [])
            } catch {
                print("Error encoding JSON: \(error)")
                return
            }

            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error: \(error)")
                    return
                }

                // Process the data or response here
                if let data = data {
                    // Parse the response data, e.g., decode JSON
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                        print("Response JSON: \(json ?? [:])")
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }

                    do {
                        let decodedThing = try JSONDecoder().decode(Thing.self, from: data)

                        // Update or add the Thing to the dictionary
                        self.things[tagID] = decodedThing
                        if let node = self.findTagNode(arucoId: tagID) {
                            node.updateFromThing(thing: decodedThing)
                        }
                        print("Successfully fetched and updated the Thing.")
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
        }

            // Start the data task
            task.resume()
        }
    }

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
            if let nodeName = result.node.name, nodeName == Thing.getButtonName(tagID: 55) {
                fetchThingAndUpdateDictionary(tagID: 55)
            }
            if let nodeName = result.node.name, nodeName == Thing.getButtonName(tagID: 77) {
                print("Button pressed!")
                let requestData: [String: Any] = ["tagID": 77, "functionName": "LED"]

                if let url = URL(string: "https://5vq78p52f0.execute-api.us-east-1.amazonaws.com/prod/toggleDevice") {
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

                    do {
                        request.httpBody = try JSONSerialization.data(withJSONObject: requestData, options: [])
                    } catch {
                        print("Error encoding JSON: \(error)")
                        return
                    }

                    let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                        if let error = error {
                            print("Error: \(error)")
                            return
                        }

                        // Process the data or response here
                        if let data = data {
                            // Parse the response data, e.g., decode JSON
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                                print("Response JSON: \(json ?? [:])")
                            } catch {
                                print("Error decoding JSON: \(error)")
                            }
                        }
                    }

                    // Start the data task
                    task.resume()
                }
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
            let tagID = Int(transform.arucoId)
            
            if let box = findTagNode(arucoId: Int(transform.arucoId)) {
                box.setWorldTransform(targTransform);
                box.seen()
            } else {
                let thing = things[tagID] ?? Thing(tagID: Int(transform.arucoId), particleID: "", type: "Loading...", mostRecentState: 0.0)
                
                if things[tagID] == nil {
                    print(String(format: "New Tag ID %d", Int(transform.arucoId)))
                }
                things[thing.tagID] = thing
                
                let tagNode = TagNode(thing: thing, size: ArucoMarkerSize)
                sceneView.scene.rootNode.addChildNode(tagNode);
                
                tagNode.setWorldTransform(targTransform);
                tagNode.seen()
                
                Task.detached {
                    try await self.fetchThingAndUpdateDictionary(tagID: tagID)
                    print("API responded")
                }
            }
        }
    }
    
    func findTagNode(arucoId:Int) -> TagNode? {
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
                } else if tag.needsUpdate() {
                    fetchThingAndUpdateDictionary(tagID: tag.id)
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
