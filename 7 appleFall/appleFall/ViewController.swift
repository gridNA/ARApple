//
//  ViewController.swift
//  appleFall
//
//  Created by Kateryna Gridina on 21.05.18.
//  Copyright © 2018 zalando. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        let scene = SCNScene()
        sceneView.scene = scene
        scene.physicsWorld.gravity = SCNVector3(0, -1.622, 0)
        sceneView.delegate = self
        addGestureRecognizers()
        sceneView.isPlaying = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration)
    }

    func addGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleApplesFalling))
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    @objc func handleApplesFalling(gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        let hitResult = sceneView.hitTest(location, types: .existingPlaneUsingExtent)

        if let hitPoint = hitResult.first {
            let x = hitPoint.worldTransform.columns.3.x
            let y = hitPoint.worldTransform.columns.3.y
            let z = hitPoint.worldTransform.columns.3.z

            let appleScene = SCNScene(named: "art.scnassets/apple.scn")
            guard let apple = appleScene?.rootNode.childNode(withName: "Apple", recursively: false) else { return }
            let appleNode = SCNNode()


            appleNode.position = SCNVector3(x, y + 1.09282, z)

            let collider = SCNSphere(radius: 0.1)
            appleNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: SCNPhysicsShape(geometry: collider, options: nil))
            appleNode.physicsBody?.mass = 1.0
            appleNode.physicsBody?.restitution = 0.0
            appleNode.physicsBody?.friction = 1.0

            appleNode.addChildNode(apple)

            sceneView.scene.rootNode.addChildNode(appleNode)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
        let material = SCNMaterial()
        material.displacement.contents = UIColor.green
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        plane.materials = [material]
        let planeNode = SCNNode(geometry: plane)
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        planeNode.physicsBody = SCNPhysicsBody.static()
        planeNode.eulerAngles.x = -.pi/2
        node.addChildNode(planeNode)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane else { return }
        planeNode.simdPosition = float3(planeAnchor.center.x, 0, planeAnchor.center.z)
        plane.width = CGFloat(planeAnchor.extent.x)
        plane.height = CGFloat(planeAnchor.extent.z)
        planeNode.physicsBody?.physicsShape = SCNPhysicsShape()
    }

    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        return node
    }

//    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
//        print(camera.trackingState)
//    }

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
