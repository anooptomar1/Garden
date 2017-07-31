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
import QuartzCore


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
    var destinationBoxNumber = Int()
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
    var boxWidthD = CGFloat(0.2)
    var boxHightD = CGFloat(0.2)
    var boxLengthD = CGFloat(0.2)
    var boxColorD = UIColor()
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
        //sceneView.autoenablesDefaultLighting = true
let env = UIImage(named: "spherical")
sceneView.scene.lightingEnvironment.contents = env
sceneView.scene.lightingEnvironment.intensity = 2.0
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
     
        //insertSpotLight(position: SCNVector3(0,1.0,0))
    }
    private func insertSpotLight(position: SCNVector3){
        let spotLight = SCNLight()
        spotLight.type = .ambient
        spotLight.spotInnerAngle = 45
        spotLight.spotOuterAngle = 45
        spotLight.castsShadow = true
        let spotNode = SCNNode()
        spotNode.name = "SpotNode"
        spotNode.light = spotLight
        spotNode.position = position
        
        spotNode.eulerAngles = SCNVector3(-Double.pi/2.0,0,-0.2)
        self.sceneView.scene.rootNode.addChildNode(spotNode)
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
//        print("longpress")
//        if recognizer.state == .began{
//           // selected = true
//            //boxNode.opacity = 0.5
//        }
    }
    enum AddObject {
        case addAble
        case notAddAble
    }
    var addingState = AddObject.addAble
    @objc func tapped(recognizer :UIGestureRecognizer) {
        if addingState == .addAble{
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
        material.diffuse.contents = color
        let top = SCNMaterial()
        top.diffuse.contents = color
            top.lightingModel = SCNMaterial.LightingModel.physicallyBased
            top.roughness.contents = UIImage(named: "scuffed-plastic-roughness")
            top.metalness.contents = UIImage(named: "scuffed-plastic-metal")
            top.normal.contents = UIImage(named: "scuffed-plastic-normal")
        let bottom = SCNMaterial()
        bottom.diffuse.contents = color
            bottom.lightingModel = SCNMaterial.LightingModel.physicallyBased
            bottom.roughness.contents = UIImage(named: "scuffed-plastic-roughness")
            bottom.metalness.contents = UIImage(named: "scuffed-plastic-metal")
            bottom.normal.contents = UIImage(named: "scuffed-plastic-normal")
        let left = SCNMaterial()
        left.diffuse.contents = color
            left.lightingModel = SCNMaterial.LightingModel.physicallyBased
            left.roughness.contents = UIImage(named: "scuffed-plastic-roughness")
            left.metalness.contents = UIImage(named: "scuffed-plastic-metal")
            left.normal.contents = UIImage(named: "scuffed-plastic-normal")
        let right = SCNMaterial()
        right.diffuse.contents = color
            right.lightingModel = SCNMaterial.LightingModel.physicallyBased
            right.roughness.contents = UIImage(named: "scuffed-plastic-roughness")
            right.metalness.contents = UIImage(named: "scuffed-plastic-metal")
            right.normal.contents = UIImage(named: "scuffed-plastic-normal")
        let front = SCNMaterial()
        front.diffuse.contents = color
            front.lightingModel = SCNMaterial.LightingModel.physicallyBased
            front.roughness.contents = UIImage(named: "scuffed-plastic-roughness")
            front.metalness.contents = UIImage(named: "scuffed-plastic-metal")
            front.normal.contents = UIImage(named: "scuffed-plastic-normal")
        let back = SCNMaterial()
        back.diffuse.contents = color
            back.lightingModel = SCNMaterial.LightingModel.physicallyBased
            back.roughness.contents = UIImage(named: "scuffed-plastic-roughness")
            back.metalness.contents = UIImage(named: "scuffed-plastic-metal")
            back.normal.contents = UIImage(named: "scuffed-plastic-normal")
            
            
        boxGeometry.chamferRadius = 0
        boxGeometry.materials = [front, right, back, left, top, bottom]
        //boxGeometry.materials = [material]
        boxNode = SCNNode(geometry: boxGeometry)
        boxNode.name = "boxNode\(boxNodeNumber)"
        eachBoxSize.updateValue((["x": boxGeometry.width, "y": boxGeometry.height, "z": boxGeometry.height], ["color": color]), forKey: boxNodeNumber)
        boxNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,hitResult.worldTransform.columns.3.y + Float(boxGeometry.height/2), hitResult.worldTransform.columns.3.z)
        self.sceneView.scene.rootNode.addChildNode(boxNode)
        print("added node \(boxNode.name)")
            
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
        
//        let estimate = self.sceneView.session.currentFrame?.lightEstimate
//        if estimate == nil{
//            return
//        }
//        let spotNode = self.sceneView.scene.rootNode.childNode(withName: "SpotNode", recursively: true)
//        spotNode?.light?.intensity = (estimate?.ambientIntensity)!
    }
    func updateAllCordinates(){
        eachBoxSize[currentBoxNumber]!.0.updateValue(boxWidth, forKey: "x")
        eachBoxSize[currentBoxNumber]!.0.updateValue(boxHight, forKey: "y")
        eachBoxSize[currentBoxNumber]!.0.updateValue(boxLength, forKey: "z")
        eachBoxSize[currentBoxNumber]!.1.updateValue(boxColor, forKey: "color")
        eachBoxSize[destinationBoxNumber]!.0.updateValue(boxWidthD, forKey: "x")
        eachBoxSize[destinationBoxNumber]!.0.updateValue(boxHightD, forKey: "y")
        eachBoxSize[destinationBoxNumber]!.0.updateValue(boxLengthD, forKey: "z")
        eachBoxSize[destinationBoxNumber]!.1.updateValue(boxColorD, forKey: "color")
    }
    func importAllCoordinates(){
        boxLength = eachBoxSize[currentBoxNumber]!.0["z"]!
        boxHight = eachBoxSize[currentBoxNumber]!.0["y"]!
        boxWidth = eachBoxSize[currentBoxNumber]!.0["x"]!
        boxColor = eachBoxSize[currentBoxNumber]!.1["color"]!
        boxLengthD = eachBoxSize[destinationBoxNumber]!.0["z"]!
        boxHightD = eachBoxSize[destinationBoxNumber]!.0["y"]!
        boxWidthD = eachBoxSize[destinationBoxNumber]!.0["x"]!
        boxColorD = eachBoxSize[destinationBoxNumber]!.1["color"]!
    }
    func showHiglightOfDestinationFace(material: SCNMaterial){
        let highlight = CABasicAnimation(keyPath: "diffuse.contents")
        highlight.toValue = UIColor.white
        highlight.duration = 1.0
        highlight.autoreverses = true
        highlight.isRemovedOnCompletion = true
        material.addAnimation(highlight, forKey: nil)
    }
    
    var isMoving = Bool()
    
    enum SelectionType{
        case currentMovingChosen
        case currentMovingNotChosen
        case chooseNewMovingNode
    }
    
    var movingStatus = SelectionType.currentMovingNotChosen
    enum CubeFace: Int {
        case Front, Right, Back, Left, Top, Bottom
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first{
            let location = touch.location(in: sceneView as ARSCNView)
            let hitList = sceneView.hitTest(location, options: nil)
            if let hitObject = hitList.first{
                
                if movingStatus ==  .currentMovingNotChosen{
                    for boxNodeNumber in boxNodeNumbers{
                        let node = hitObject.node
                        if node.name == "boxNode\(boxNodeNumber)"{
                            let group = DispatchGroup()
                            group.enter()
                            DispatchQueue.main.async {
                                self.currentNode = node
                                self.currentMovingNode = node
                                self.currentBoxNumber = boxNodeNumber
                                print("currentMovingNode name is\(self.currentMovingNode.name)")
                                //
                                self.addingState = .notAddAble
                                self.scaleAble = true
                                self.currentMovingNode.opacity = 0.5
                                group.leave()
                            }
                            group.notify(queue: .main){
                                self.movingStatus = .currentMovingChosen
                            }
                            tapGestureRecognizer.isEnabled = false
                            print("tapped on a node")
                        }else{
                            print("didnt tap on a node")
                        }
                    }
                }else if movingStatus == .currentMovingChosen{
                  print("in currentMovingChosen but didnt choose any node, node wasnt selected")
    //--------------------
                    for boxNodeNumber in boxNodeNumbers{
                        print("run")
                        let destinationNode = hitObject.node
                        if destinationNode.name == "boxNode\(boxNodeNumber)"{
                            print("destinationNodes name is\(destinationNode.name)")
                            print("run2")
                        if destinationNode.position.x == currentMovingNode.position.x && destinationNode.position.y == currentMovingNode.position.y && destinationNode.position.z == currentMovingNode.position.z{
                            movingStatus = .currentMovingNotChosen
                            currentMovingNode.opacity = 1
                            print("run.......")
                        }else{
                            print("run3")
                            let group = DispatchGroup()
                            group.enter()
                            DispatchQueue.main.async {
                                print("in async for ")
                                self.destinationBoxNumber = boxNodeNumber
                                //Find the material for the clicked element
                                let material = destinationNode.geometry?.materials[hitObject.geometryIndex]
                               self.importAllCoordinates()
                                if hitObject.geometryIndex == 0{
                                    let moveToTappedNode = SCNAction.move(to: SCNVector3(destinationNode.position.x, destinationNode.position.y, (destinationNode.position.z + Float(self.self.boxLengthD)/2) +  (Float(self.boxLength)/2)), duration: 0.5)
                                    self.updateAllCordinates()
                                    self.currentMovingNode.runAction(moveToTappedNode)
                                    print("front")
                                }else if hitObject.geometryIndex == 1{
                                    let moveToTappedNode = SCNAction.move(to: SCNVector3((destinationNode.position.x + Float(self.boxWidthD)/2) + (Float(self.boxWidth)/2), destinationNode.position.y, destinationNode.position.z), duration: 0.5)
                                    self.updateAllCordinates()
                                    self.self.currentMovingNode.runAction(moveToTappedNode)
                                    print("right")
                                }else if hitObject.geometryIndex == 2{
                                    let moveToTappedNode = SCNAction.move(to: SCNVector3(destinationNode.position.x, destinationNode.position.y, (destinationNode.position.z - Float(self.boxLengthD)/2) - (Float(self.boxLength)/2)), duration: 0.5)
                                    self.updateAllCordinates()
                                    self.currentMovingNode.runAction(moveToTappedNode)
                                    print("back")
                                }else if hitObject.geometryIndex == 3{
                                    let moveToTappedNode = SCNAction.move(to: SCNVector3((destinationNode.position.x - Float(self.boxWidthD)/2) - (Float(self.boxWidth)/2), destinationNode.position.y, destinationNode.position.z), duration: 0.5)
                                    self.updateAllCordinates()
                                    self.currentMovingNode.runAction(moveToTappedNode)
                                    print("left")
                                }else if hitObject.geometryIndex == 4{
                                    let moveToTappedNode = SCNAction.move(to: SCNVector3(destinationNode.position.x, (destinationNode.position.y + Float(self.boxHightD)/2) + (Float(self.boxHight)/2), destinationNode.position.z), duration: 0.5)
                                    self.updateAllCordinates()
                                    self.currentMovingNode.runAction(moveToTappedNode)
                                    print("top")
                                }else if hitObject.geometryIndex == 5{
                                    let moveToTappedNode = SCNAction.move(to: SCNVector3(destinationNode.position.x, (destinationNode.position.y - Float(self.boxHightD)/2) - (Float(self.boxHight)/2), destinationNode.position.z), duration: 0.5)
                                    self.updateAllCordinates()
                                    self.currentMovingNode.runAction(moveToTappedNode)
                                    print("bottom")
                                }
                                self.currentMovingNode.opacity = 1
                                self.showHiglightOfDestinationFace(material: material!)
                                
                                group.leave()
                            }
                            group.notify(queue: .main){
                                self.movingStatus = .currentMovingNotChosen
                                print("left status currentmoving chosen")
                                }
                            }
                            tapGestureRecognizer.isEnabled = false
                        }
                    }
   //--------------------
                }else if movingStatus == .chooseNewMovingNode{
                    for boxNodeNumber in boxNodeNumbers{
                        let node = hitObject.node
                        if node.name == "boxNode\(boxNodeNumber)"{
                            currentMovingNode = node
                            currentMovingNode.opacity = 0.5
                            isMoving = true
                            selected = true
                            movingStatus = .currentMovingChosen
                            print("should have changed  the currentNode")
                            tapGestureRecognizer.isEnabled = false
                        }
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
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "blueBoxIcon"){
            chosenStatus = NodeType.blueBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "orangeBoxIcon"){
            chosenStatus = NodeType.orangeBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "yellowBoxIcon"){
            chosenStatus = NodeType.yellowBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "greenBoxIcon"){
            chosenStatus = NodeType.greenBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "purpleBoxIcon"){
            chosenStatus = NodeType.PurpleBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "pinkBoxIcon"){
            chosenStatus = NodeType.pinkBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "brownBoxIcon"){
            chosenStatus = NodeType.brownBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "blackBoxIcon"){
            chosenStatus = NodeType.blackBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "greyBoxIcon"){
            chosenStatus = NodeType.greyBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "whiteBoxIcon"){
            chosenStatus = NodeType.whiteBox
            addingState = .addAble
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




