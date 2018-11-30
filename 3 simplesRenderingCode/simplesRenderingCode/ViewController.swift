//
//  ViewController.swift
//  simplesRenderingCode
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
        sceneView.delegate = self

        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/apple.scn")!
        // Set the scene to the view
        let scene = SCNScene()
        let appleShape = SCNSphere(radius: 0.3)
//        appleShape.firstMaterial?.diffuse.contents = UIImage(named: "art.scnassets/appleD.jpg")
//        appleShape.firstMaterial?.multiply.contents = UIColor.green
//        appleShape.firstMaterial?.diffuse.intensity = 4
        let material = SCNMaterial()
        material.diffuse.intensity = 3
        material.diffuse.contents = UIColor.red
        appleShape.materials = [material]
        let appleNode = SCNNode(geometry: appleShape)
        appleNode.position = SCNVector3(0.2, 0.2, 0.2)
        scene.rootNode.addChildNode(appleNode)
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    }

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

    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        switch(camera.trackingState) {
        case .notAvailable:
            print("Cannot start ARSession!")
        case .limited(.initializing):
            print("Learning about surrounding. Try moving around")
        case .limited(.insufficientFeatures):
            print("Try turning on more lights and moving around")
        case .limited(.excessiveMotion):
            print("Try moving your phone slower")
        case .normal:
            print("normal")
        case .limited(.relocalizing):
            print("limited")
        }
    }
}
