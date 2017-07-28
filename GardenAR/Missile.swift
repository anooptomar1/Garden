//
//  Missile.swift
//  GardenAR
//
//  Created by Jennifer Vilanda Hasler on 7/24/2560 BE.
//  Copyright © 2560 Jennifer Vilanda Hasler. All rights reserved.
//

import Foundation
import SceneKit
import ARKit


class Missile : SCNNode {
    
    
    private var scene :SCNScene!
    
    init(scene :SCNScene) {
        super.init()
        
        self.scene = scene
        
        setup()
    }
    
    init(missileNode :SCNNode) {
        super.init()
        
        // self.missileNode = missileNode
        
        setup()
    }
    
    private func setup() {
        
        guard let missileNode = self.scene.rootNode.childNode(withName: "missileNode", recursively: true),
            let smokeNode = self.scene.rootNode.childNode(withName: "smokeNode", recursively: true)
            else {
                fatalError("Node not found!")
        }
        
        let smoke = SCNParticleSystem(named: "smoke.scnp", inDirectory: nil)
        smokeNode.addParticleSystem(smoke!)
        
        self.addChildNode(missileNode)
        self.addChildNode(smokeNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}

