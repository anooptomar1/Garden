//
//  ViewController.swift
//  GardenAR
//
//  Created by Jennifer Vilanda Hasler on 7/24/2560 BE.
//  Copyright © 2560 Jennifer Vilanda Hasler. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit
import ARKit


class ViewController: UIViewController, ARSCNViewDelegate, ARSKViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var addingBtn: UIButton!
    @IBOutlet weak var camBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var trashBtn: UIButton!
    
    enum NodeType{
        case redBox
        case blueBox
        case pinkBox
        case greenBox
        case yellowBox
        case orangeBox
        case PurpleBox
        case whiteBox
        case blackBox
        case brownBox
        case greyBox
    }
    var overlay: SKScene!
    var planes = [OverlayPlane]()
    // [nodeName: (["x": Int], ["color": "selectedColor"])]
    var eachBoxSize: [Int: ([String: CGFloat], [String: UIColor])] = [90000000: (["x": 0.2, "y": 0.2, "z": 0.2], ["color": UIColor.brown])]
    //var boxColor = String()
    var openedPanel = false
    //status
    var chosenStatus = NodeType.redBox
    //panel and items
    var panel = SKSpriteNode()
    var boxNodeNumber = 0
    var boxNodeNumbers = [Int]()
    var currentBoxNumber = Int()
    var plusScale = SKSpriteNode()
    var minusScale = SKSpriteNode()
    //icons
    var blockIcon = SKSpriteNode()
    var blueIcon = SKSpriteNode()
    var yellowIcon = SKSpriteNode()
    var greenIcon = SKSpriteNode()
    var orangeIcon = SKSpriteNode()
    var purpleIcon = SKSpriteNode()
    var pinkIcon = SKSpriteNode()
    var blackIcon = SKSpriteNode()
    var greyIcon = SKSpriteNode()
    var whiteIcon = SKSpriteNode()
    var brownIcon = SKSpriteNode()
    //
    var chooseBlock = false
    var boxNode = SCNNode()
    var boxGeometry = SCNBox()
    var boxNodes = [SCNNode]()
    var boxWidth = CGFloat(0.2)
    var boxHight = CGFloat(0.2)
    var boxLength = CGFloat(0.2)
    var boxColor = UIColor()
    var currentNode = SCNNode()
    var currentMovingNode = SCNNode()
    var lastMovingNode = SCNNode()
    var currentNodeGeo = SCNGeometry()
    var selected = Bool()
    var scaleAble = Bool()
    //var inProgress = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate

        sceneView.delegate = self
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        // Create a new scene
        let scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        overlay = SKScene(size:CGSize(width:375,height:750))
        overlay.scaleMode = .aspectFill
        overlay.zPosition = +10
        overlay.position = CGPoint(x: 0, y: 0)
        overlay.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        overlay.isUserInteractionEnabled = false
        sceneView.overlaySKScene = overlay
        createPanel()
        registerGestureRecognizers()
        registeredLongGestureRecognizer()
        registeredPanGestureRecognizer()
     
    }
    var tapGestureRecognizer = UITapGestureRecognizer()
    var panGestureRecognizer = UIPanGestureRecognizer()
    //var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
    private func registerGestureRecognizers() {
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    private func registeredLongGestureRecognizer(){
        let longTapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longTouch))
        self.sceneView.addGestureRecognizer(longTapGestureRecognizer)
    }
    private func registeredPanGestureRecognizer(){
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moving))
        self.sceneView.addGestureRecognizer(panGestureRecognizer)
    }
   
    @IBAction func scaleUp(_ sender: Any) {
        print("scaleable up is \(scaleAble)")
        if scaleAble{
            print("can scale u = \(scaleAble)")
            // check eachBoxSize is not nil
            guard eachBoxSize != nil else {
                return
            }
            // check eachBoxSize for currentBoxNumber is not nil
            guard eachBoxSize[currentBoxNumber] != nil else {
                print("there is no values in currentBoxNumber")
                return
            }
            // check values in eachBoxSize for currentBoxNumber are not nils
            guard eachBoxSize[currentBoxNumber]! != nil else{
                print("error1")
                return
            }
            guard eachBoxSize[currentBoxNumber]?.0 != nil else{
                print("error2")
                return
            }
            guard eachBoxSize[currentBoxNumber]!.0["x"] != nil && eachBoxSize[currentBoxNumber]?.0["y"] != nil && eachBoxSize[currentBoxNumber]?.0["z"] != nil else{
                print("error3")
                return
            }
           
            boxLength = eachBoxSize[currentBoxNumber]!.0["z"]! + 0.01
            boxHight = eachBoxSize[currentBoxNumber]!.0["y"]! + 0.01
            boxWidth = eachBoxSize[currentBoxNumber]!.0["x"]! + 0.01
            boxColor = eachBoxSize[currentBoxNumber]!.1["color"]!
            var geo = SCNGeometry()
            geo = SCNBox(width: boxWidth, height:  boxHight, length: boxLength, chamferRadius: 0)
            eachBoxSize[currentBoxNumber]!.0.updateValue(boxWidth, forKey: "x")
            eachBoxSize[currentBoxNumber]!.0.updateValue(boxHight, forKey: "y")
            eachBoxSize[currentBoxNumber]!.0.updateValue(boxLength, forKey: "z")
            eachBoxSize[currentBoxNumber]!.1.updateValue(boxColor, forKey: "color")
            print("eachboxSize  after scale is \(eachBoxSize)")
            currentNode.geometry = geo
            let material = SCNMaterial()
            material.diffuse.contents = boxColor
            geo.materials = [material]
            print(boxGeometry.width)
            print(boxGeometry.height)
            print(boxGeometry.length)
            print(currentNode.name)
        }
    }
    
    @IBAction func scaleDown(_ sender: Any) {
        print("scaleable down is \(scaleAble)")
        if scaleAble{
            print("can scale down = \(scaleAble)")
            // check eachBoxSize is not nil
            guard eachBoxSize != nil else {
                return
            }
            // check eachBoxSize for currentBoxNumber is not nil
            guard eachBoxSize[currentBoxNumber] != nil else {
                print("there is no values in currentBoxNumber")
                return
            }
            // check values in eachBoxSize for currentBoxNumber are not nils
            guard eachBoxSize[currentBoxNumber]! != nil else{
                print("error1")
                return
            }
            guard eachBoxSize[currentBoxNumber]?.0 != nil else{
                print("error2")
                return
            }
            guard eachBoxSize[currentBoxNumber]!.0["x"] != nil && eachBoxSize[currentBoxNumber]?.0["y"] != nil && eachBoxSize[currentBoxNumber]?.0["z"] != nil else{
                print("error3")
                return
            }
            boxLength = eachBoxSize[currentBoxNumber]!.0["z"]! - 0.01
            boxHight = eachBoxSize[currentBoxNumber]!.0["y"]! - 0.01
            boxWidth = eachBoxSize[currentBoxNumber]!.0["x"]! - 0.01
            boxColor = eachBoxSize[currentBoxNumber]!.1["color"]!
            //eachBoxSize[currentBoxNumber]
            var geo = SCNGeometry()
            geo = SCNBox(width: boxWidth, height: boxHight, length: boxLength, chamferRadius: 0)
            eachBoxSize[currentBoxNumber]!.0.updateValue(boxWidth, forKey: "x")
            eachBoxSize[currentBoxNumber]!.0.updateValue(boxHight, forKey: "y")
            eachBoxSize[currentBoxNumber]!.0.updateValue(boxLength, forKey: "z")
            eachBoxSize[currentBoxNumber]!.1.updateValue(boxColor, forKey: "color")
            currentNode.geometry = geo
            let material = SCNMaterial()
            material.diffuse.contents = boxColor
            geo.materials = [material]
            print(boxGeometry.width)
            print(boxGeometry.height)
            print(boxGeometry.length)
            print(currentNode.name)
        }
    }
    @IBAction func deleteAction(_ sender: Any) {
        print("delete")
        if scaleAble{
            print("in delete: nodes name is\(currentNode.name)")
           currentNode.removeFromParentNode()
        }
    }
    
    @objc func moving(recognizer: UIPanGestureRecognizer){
        //positioning and moving node
        // selected = false
        //inProgress = false
        //boxNode.opacity = 1.0
        let sceneView = recognizer.view as! ARSCNView
        let point = recognizer.location(in: sceneView)
        let result = sceneView.hitTest(point, types: .existingPlaneUsingExtent)
        if !result.isEmpty{
            guard let hitResult = result.first else{
                return
            }
            let location = recognizer.location(in: sceneView as ARSCNView)
            let hitList = sceneView.hitTest(location, options: nil)
            if let hitObject = hitList.first{
                let node = hitObject.node
                for boxNodeNumber in boxNodeNumbers{
                    //Workssss
                    if node.name == "boxNode\(boxNodeNumber)"{
                        print("touched on \(boxNodeNumber)")
                        node.position.x = hitResult.worldTransform.columns.3.x
                        node.position.z = hitResult.worldTransform.columns.3.z
                        node.position.y = hitResult.worldTransform.columns.3.y + Float(boxGeometry.height/2)
                    }else{
                        print("touch on screen tapGesture = \(tapGestureRecognizer.isEnabled) ")
                    }
                }
            }
        }
    }
    @objc func longTouch(recognizer: UILongPressGestureRecognizer){
        print("longpress")
        if recognizer.state == .began{
           // selected = true
            //boxNode.opacity = 0.5
        }
    }
    @objc func tapped(recognizer :UIGestureRecognizer) {
            let sceneView = recognizer.view as! ARSCNView
            let touchLocation = recognizer.location(in: sceneView)
            let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            if !hitTestResult.isEmpty {
                guard let hitResult = hitTestResult.first else {
                    return
                }
                // get the hittest of one cube site
                
                
                //pick the chosen color, add cube to scene in that color
                if chosenStatus == .redBox{
                addBox(hitResult: hitResult, color: UIColor.red)
                }else if chosenStatus == .blueBox{
                    addBox(hitResult: hitResult, color: UIColor(red:0.29, green:0.56, blue:0.89, alpha:1.0))
                }else if chosenStatus == .orangeBox{
                    addBox(hitResult: hitResult, color: UIColor.orange)
                }else if chosenStatus == .yellowBox{
                    addBox(hitResult: hitResult, color: UIColor.yellow)
                }else if chosenStatus == .greenBox{
                    addBox(hitResult: hitResult, color: UIColor.green)
                }else if chosenStatus == .PurpleBox{
                    addBox(hitResult: hitResult, color: UIColor.purple)
                }else if chosenStatus == .pinkBox{
                    addBox(hitResult: hitResult, color: UIColor(red:0.90, green:0.42, blue:1.00, alpha:1.0))
                }else if chosenStatus == .blackBox{
                    addBox(hitResult: hitResult, color: UIColor.black)
                }else if chosenStatus == .greyBox{
                    addBox(hitResult: hitResult, color: UIColor.gray)
                }else if chosenStatus == .brownBox{
                    addBox(hitResult: hitResult, color: UIColor.brown)
                }else if chosenStatus == .whiteBox{
                    addBox(hitResult: hitResult, color: UIColor.white)
                }
            }else if hitTestResult.isEmpty{
                print("touchlocation is empty")
            }
    }
    
  
    @IBAction func takeScreenshot(_ sender: Any) {
        print("screenshot")
    }
    @IBAction func addObjects(_ sender: Any) {
        
        if openedPanel == true{
           
            closePanel()
        }else if openedPanel == false{
            
            openPanel()
        }
        
    }
    var addingNewCube = Bool()
    private func addBox(hitResult :ARHitTestResult, color: UIColor) {
        //disactivate selected and scaleable
        scaleAble = false
        selected = false
        isMoving = false
        addingNewCube = true
        currentMovingNode.opacity = 1
        movingStatus = .currentMovingNotChosen
        //
        if addingNewCube{
        boxNodeNumber += 1
        boxNodeNumbers.append(boxNodeNumber)
        boxWidth = 0.2
        boxHight = 0.2
        boxLength = 0.2
        boxGeometry = SCNBox(width: boxWidth, height: boxHight, length: boxLength, chamferRadius: 0)
        let material = SCNMaterial()
        let top = SCNMaterial()
        let bottom = SCNMaterial()
        let left = SCNMaterial()
        let right = SCNMaterial()
        let front = SCNMaterial()
        let back = SCNMaterial()
        material.diffuse.contents = color
        boxGeometry.chamferRadius = 0
        boxGeometry.materials = [front, right, back, left, top, bottom]
        boxGeometry.materials = [material]
        boxNode = SCNNode(geometry: boxGeometry)
        boxNode.name = "boxNode\(boxNodeNumber)"
        eachBoxSize.updateValue((["x": boxGeometry.width, "y": boxGeometry.height, "z": boxGeometry.height], ["color": color]), forKey: boxNodeNumber)
        boxNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,hitResult.worldTransform.columns.3.y + Float(boxGeometry.height/2), hitResult.worldTransform.columns.3.z)
        self.sceneView.scene.rootNode.addChildNode(boxNode)
            print("added")
        }
    }
    
    
    
    
  
    //close and open panel
    func closePanel(){
        let moveDown = SKAction.moveTo(y: -(view.frame.height / 1.5), duration: 0.3)
        openedPanel = false
        panel.run(moveDown)
    }
    func openPanel(){
        let moveUp = SKAction.moveTo(y: -60, duration: 0.3)
        openedPanel = true
        panel.run(moveUp)
    }
    //choose item from panel
    func chooseBlockItem(boolien: Bool){
        //panel close
        closePanel()
        //item can be placed
        chooseBlock = boolien
    }
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
     
            if movingStatus == SelectionType.currentMovingChosen{
                currentMovingNode.opacity = 0.5
            }else if movingStatus == SelectionType.currentMovingNotChosen{
                currentMovingNode.opacity = 1
                //currentMovingNode.removeAllActions()
            }
      
        
        
    }
    var isMoving = Bool()
    enum SelectionType{
        case currentMovingChosen
        case currentMovingNotChosen
        case chooseNewMovingNode
    }
    var movingStatus = SelectionType.currentMovingNotChosen
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("***ismoving\(isMoving)")
        print("****is selected\(selected)")
        print(movingStatus)
        if let touch = touches.first{
            let location = touch.location(in: sceneView as ARSCNView)
            let hitList = sceneView.hitTest(location, options: nil)
            if let hitObject = hitList.first{
                //choosing sidenode
                if movingStatus == SelectionType.currentMovingChosen{
                    if isMoving{
                        if selected{
                            for boxNodeNumber in boxNodeNumbers{
                                let destinationNode = hitObject.node
                                /////***********
                                //A
                                /////******
                                if destinationNode.position.x == currentMovingNode.position.x{
                                    movingStatus = .currentMovingNotChosen
//                                    isMoving = false
//                                    selected = false
                                    print("the new destination was on the current node")
                                    print("moving status is \(movingStatus)")
                                    print("isMoving than is \(isMoving)")
                                    print("selected than is \(selected)")
                                    //currentMovingNode.removeFromParentNode()
                                }
                                /////***********
                                //3
                                /////******
                                if movingStatus == .currentMovingChosen{
                                if destinationNode.name == "boxNode\(boxNodeNumber)"{
                                    print("isMoving = \(isMoving)")
                                    print("selected = \(selected)")
                                    //Find the material for the clicked element
                                    print("destinationNode.position is \(destinationNode.position)")
                                    print("destinationNode is \(destinationNode.name)")
                                    let material = destinationNode.geometry?.materials[hitObject.geometryIndex]
                                    let moveToTappedNode = SCNAction.move(to: SCNVector3(destinationNode.position.x - 0.2, destinationNode.position.y, destinationNode.position.z), duration: 2)
                                    if movingStatus == .currentMovingChosen{
                                    currentMovingNode.runAction(moveToTappedNode)
                                    movingStatus = .currentMovingNotChosen
                                    currentMovingNode.opacity = 1
                                    }else{
                                        print("no cube is moving")
                                        print("status after... is\(movingStatus)")
                                    }
                                    //lastMovingNode = currentMovingNode
                                    //Do something with that material, for example:
                                    let highlight = CABasicAnimation(keyPath: "diffuse.contents")
                                    highlight.toValue = UIColor.red
                                    highlight.duration = 1.0
                                    highlight.autoreverses = true
                                    highlight.isRemovedOnCompletion = true
                                    material?.addAnimation(highlight, forKey: nil)
                                    selected = false
                                    isMoving = true
                                    print("execute")
                                    }
                                }else{
                                    print("the currrent cube was removed.. end of code")
                                }
                            }
                        }
                    }
                }
                
                for boxNodeNumber in boxNodeNumbers{
                    if movingStatus == .chooseNewMovingNode{
                        let node = hitObject.node
                        if node.name == "boxNode\(boxNodeNumber)"{
                        currentMovingNode = node
                            currentMovingNode.opacity = 0.5
                            isMoving = true
                            selected = true
                            movingStatus = .currentMovingChosen
                        print("should have changed  the currentNode")
                        }
                    }
                    
                    
                }
                //choosing currentmovingnode
                for boxNodeNumber in boxNodeNumbers{
                    let node = hitObject.node
                    if node.name == "boxNode\(boxNodeNumber)"{
                        
                        print("helloo")
                        if movingStatus == .currentMovingNotChosen{
                            //change status to
                            movingStatus = .chooseNewMovingNode
                        }
                        tapGestureRecognizer.isEnabled = false
                        //if selected cube is moving, than select a new destination, allow the current cube to move to all destinations that are tapped
                        //something is selected, and allows to move..
                        /////***********
                        //4
                        /////******
                        /////***********
                        //B
                        /////******
                        if  movingStatus == .currentMovingChosen{
                        if isMoving{
                            selected = true
                            tapGestureRecognizer.isEnabled = false
                            //movingStatus = SelectionType.currentMovingChosen
                            if movingStatus == SelectionType.currentMovingNotChosen{
                                print(" changing selected and moving to false to start over")
                                selected = false
                                isMoving = false
                                tapGestureRecognizer.isEnabled = false
                            }
                            print("ready to selected a new cube")
                            print("status is \(movingStatus)")
                            print("is selected is \(selected)")
                            print("isMoving is \(isMoving)")
                        }
                            tapGestureRecognizer.isEnabled = false
                        }
//*********************************************************************************************************************************************************************
                        //if no cube is moving and if nothing is selected to be moved, than tapped cube is the currentCubeNode to be moved
                        if movingStatus == .currentMovingNotChosen{
                        if isMoving && selected{
                            
//                            lastMovingNode = currentMovingNode
                            
                            print("am here to change moving and selected to false")
                            print("ismoving = \(isMoving)")
                            print("selected is \(selected)")
                        }
                        }
                        if !isMoving{
                            if selected == false {
                                //choose this selected cube to be the mover
                                if !isMoving{
                                    print("starting over")
                                    currentMovingNode = node
                                    movingStatus = .currentMovingChosen
                                    /////***********
                                    //1
                                    /////******
                                    print("this Cube chosen to be current cube\(currentMovingNode.name)")
                                    tapGestureRecognizer.isEnabled = false
                                }
                                //something is selected, and allows to move..
                                /////***********
                                //2
                                /////******
                                selected = true
                                isMoving = true
                                tapGestureRecognizer.isEnabled = false
                                print(movingStatus)
                                print("isMoving is\(isMoving)")
                                print("is selected \(selected)")
                            }
                        }
                        
                        //-----------------------------------------------
                            //this has nothing to do with moving cubes
                            currentBoxNumber = boxNodeNumber
                            currentNode = node
                            scaleAble = true
                            //doesnt allow to add box on existing box position
                            tapGestureRecognizer.isEnabled = false
                    }
                }
                
                
            }
        }
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: overlay)
        let touchedNode = overlay.atPoint(touchLocation)
        if(touchedNode.name == "boxIcon"){
            chosenStatus = NodeType.redBox
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "blueBoxIcon"){
            chosenStatus = NodeType.blueBox
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "orangeBoxIcon"){
            chosenStatus = NodeType.orangeBox
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "yellowBoxIcon"){
            chosenStatus = NodeType.yellowBox
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "greenBoxIcon"){
            chosenStatus = NodeType.greenBox
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "purpleBoxIcon"){
            chosenStatus = NodeType.PurpleBox
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "pinkBoxIcon"){
            chosenStatus = NodeType.pinkBox
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "brownBoxIcon"){
            chosenStatus = NodeType.brownBox
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "blackBoxIcon"){
            chosenStatus = NodeType.blackBox
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "greyBoxIcon"){
            chosenStatus = NodeType.greyBox
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "whiteBoxIcon"){
            chosenStatus = NodeType.whiteBox
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        //allow to touch again
        tapGestureRecognizer.isEnabled = true
        
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        //allow to touch again
        tapGestureRecognizer.isEnabled = true
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingSessionConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if !(anchor is ARPlaneAnchor) {
            return
        }
        let plane = OverlayPlane(anchor: anchor as! ARPlaneAnchor)
        self.planes.append(plane)
        node.addChildNode(plane)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {

        let plane = self.planes.filter { plane in
            return plane.anchor.identifier == anchor.identifier
            }.first
        if plane == nil {
            return
        }
        
        plane?.update(anchor: anchor as! ARPlaneAnchor)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    func createPanel(){
        panel = SKSpriteNode(imageNamed: "panel")
        panel.position = CGPoint(x: 0, y: -(view.frame.height / 1.5))
        //let scaleHeight = panel.size.width / panel.size.width * panel.size.height
        panel.size = CGSize(width: 300, height: 300)
        overlay.addChild(panel)
        //create red box
        blockIcon = SKSpriteNode(imageNamed: "blockIcon")
        blockIcon.name = "boxIcon"
        blockIcon.size = CGSize(width: 40, height: 40)
        blockIcon.zPosition = 100
        blockIcon.position = CGPoint(x: -100, y: 100)
        panel.addChild(blockIcon)
        //create blue box
        orangeIcon = SKSpriteNode(imageNamed: "orangeBlockIcon")
        orangeIcon.name = "orangeBoxIcon"
        orangeIcon.size = CGSize(width: 40, height: 40)
        orangeIcon.zPosition = 100
        orangeIcon.position = CGPoint(x: -50, y: 100)
        panel.addChild(orangeIcon)
        //create yellow box
        yellowIcon = SKSpriteNode(imageNamed: "yellowBlockIcon")
        yellowIcon.name = "yellowBoxIcon"
        yellowIcon.size = CGSize(width: 40, height: 40)
        yellowIcon.zPosition = 100
        yellowIcon.position = CGPoint(x: 0, y: 100)
        panel.addChild(yellowIcon)
        //create green box
        greenIcon = SKSpriteNode(imageNamed: "greenBlockIcon")
        greenIcon.name = "greenBoxIcon"
        greenIcon.size = CGSize(width: 40, height: 40)
        greenIcon.zPosition = 100
        greenIcon.position = CGPoint(x: +50, y: 100)
        panel.addChild(greenIcon)
        //create blue box
        blueIcon = SKSpriteNode(imageNamed: "blueBlockIcon")
        blueIcon.name = "blueBoxIcon"
        blueIcon.size = CGSize(width: 40, height: 40)
        blueIcon.zPosition = 100
        blueIcon.position = CGPoint(x: +100, y: 100)
        panel.addChild(blueIcon)
        //create purple box
        purpleIcon = SKSpriteNode(imageNamed: "purpleBlockIcon")
        purpleIcon.name = "purpleBoxIcon"
        purpleIcon.size = CGSize(width: 40, height: 40)
        purpleIcon.zPosition = 100
        purpleIcon.position = CGPoint(x: -100, y: 50)
        panel.addChild(purpleIcon)
        //create pink box
        pinkIcon = SKSpriteNode(imageNamed: "pinkBlockIcon")
        pinkIcon.name = "pinkBoxIcon"
        pinkIcon.size = CGSize(width: 40, height: 40)
        pinkIcon.zPosition = 100
        pinkIcon.position = CGPoint(x: -50, y: 50)
        panel.addChild(pinkIcon)
        //create brown box
        brownIcon = SKSpriteNode(imageNamed: "brownBlockIcon")
        brownIcon.name = "brownBoxIcon"
        brownIcon.size = CGSize(width: 40, height: 40)
        brownIcon.zPosition = 100
        brownIcon.position = CGPoint(x: 0, y: 50)
        panel.addChild(brownIcon)
        //create black box
        blackIcon = SKSpriteNode(imageNamed: "blackBockIcon")
        blackIcon.name = "blackBoxIcon"
        blackIcon.size = CGSize(width: 40, height: 40)
        blackIcon.zPosition = 100
        blackIcon.position = CGPoint(x: +50, y: 50)
        panel.addChild(blackIcon)
        //create grey box
        greyIcon = SKSpriteNode(imageNamed: "greyBlockIcon")
        greyIcon.name = "greyBoxIcon"
        greyIcon.size = CGSize(width: 40, height: 40)
        greyIcon.zPosition = 100
        greyIcon.position = CGPoint(x: +100, y: 50)
        panel.addChild(greyIcon)
        //create white box
        whiteIcon = SKSpriteNode(imageNamed: "whiteBlockicon")
        whiteIcon.name = "whiteBoxIcon"
        whiteIcon.size = CGSize(width: 40, height: 40)
        whiteIcon.zPosition = 100
        whiteIcon.position = CGPoint(x: -100, y: 0)
        panel.addChild(whiteIcon)
    }
    
}




