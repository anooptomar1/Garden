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
import ReplayKit
import QuartzCore
import GameKit
import GoogleMobileAds
import Firebase

//extension of UIImage
extension UIImage {
    class func imageWithView(view: UIView) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
//extension UIImage {
//    convenience init(_ view: UIView) {
//        UIGraphicsBeginImageContext(view.frame.size)
//        view.layer.render(in: UIGraphicsGetCurrentContext()!)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        self.init(cgImage: (image?.cgImage)!)
//    }
//}
extension UIView {
    
    // Using a function since `var image` might conflict with an existing variable
    // (like on `UIImageView`)
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

class ViewController: UIViewController, ARSCNViewDelegate, ARSKViewDelegate, GADBannerViewDelegate, RPPreviewViewControllerDelegate, GADInterstitialDelegate {

    //AdMob Banner
    
    @IBOutlet var bannerView: GADBannerView!
  
    
    
    
    //
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var addingBtn: UIButton!
    @IBOutlet weak var camBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var trashBtn: UIButton!
    //import metal

    
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
        
        case bambooBox
        case oakFloorBox
        case rustyBox
        case greesMetalBox
        case streakMetal
        case rustIronBox
        case rockBox
        case syntheticRubberBox
        case plasticPatterBox
        case mahagoniBox
        
    }
    var overlay: SKScene!
    var planes = [OverlayPlane]()
    // [nodeName: (["x": Int], ["color": "selectedColor"])]
    var eachBoxSize: [Int: ([String: CGFloat], [String: UIImage], [String: UIImage], [String: UIImage], [String: UIImage] )] = [90000000: (["x": 0.2, "y": 0.2, "z": 0.2], ["color": UIImage(named: "scuffed-plastic-albedo")!], ["metal": UIImage(named: "scuffed-plastic-metal")!], ["roughness": UIImage(named: "scuffed-plastic-roughness")!], ["normal": UIImage(named: "scuffed-plastic-normal")!])]
    //var boxColor = String()
    var openedPanel = false
    //status
    var chosenStatus = NodeType.redBox
    //panel and items
    var panel = SKSpriteNode()
    var boxNodeNumber = 0
    var boxNodeNumbers = [Int]()
    var shadows = [SCNNode]()
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
    var bambusIcon = SKSpriteNode()
    var oakIcon = SKSpriteNode()
    var rustyIcon = SKSpriteNode()
    var rustIronIcon = SKSpriteNode()
    var greasyIronIcon = SKSpriteNode()
    var streakMetal = SKSpriteNode()
    var rustedIronIcon = SKSpriteNode()
    var roockBoxIcon = SKSpriteNode()
    var rubberIcon = SKSpriteNode()
    var plasticIcon = SKSpriteNode()
    var mahagoni = SKSpriteNode()
    //
    var chooseBlock = false
    var boxNode = SCNNode()
    var boxGeometry = SCNBox()
    var boxNodes = [SCNNode]()
    var boxWidth = CGFloat(0.2)
    var boxHight = CGFloat(0.2)
    var boxLength = CGFloat(0.2)
    var boxColor = UIImage()
    var boxMetal = UIImage()
    var boxRoughness = UIImage()
    var boxNormal = UIImage()
    var boxWidthD = CGFloat(0.2)
    var boxHightD = CGFloat(0.2)
    var boxLengthD = CGFloat(0.2)
    var boxColorD = UIImage()
    var boxMetalD = UIImage()
    var boxRoughnessD = UIImage()
    var boxNormalD = UIImage()

    
    var currentNode = SCNNode()
    var currentMovingNode = SCNNode()
    var lastMovingNode = SCNNode()
    var currentNodeGeo = SCNGeometry()
    var selected = Bool()
    var scaleAble = Bool()

    
    func showBannerAd(){
        //banner ad
        let request = GADRequest()
        request.testDevices = ["997a25edf07df666778ec70835e67aa7", kGADSimulatorID]
        var bannerView: GADBannerView!
        if UIDevice.current.userInterfaceIdiom == .pad{
            bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
            bannerView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 - self.view.frame.height / 2 + 45)
        }
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.load(request)
        let view = bannerView
        let image = UIImage.imageWithView(view: view!)
        self.view.addSubview(bannerView)
    }
    //interstitial Ad
    var interstitial: GADInterstitial!
    var interstitialCount = 0
    func loadInterstitialAd(){
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1323381872235473/6056276465")
        let request = GADRequest()
        request.testDevices = ["997a25edf07df666778ec70835e67aa7", kGADSimulatorID]
        interstitial.load(request)
    }
    func createAd() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-1323381872235473/6056276465")
        interstitial.load(GADRequest())
        return interstitial
    }
    func showInterstitialAd(){
        if interstitial.isReady{
            interstitial.present(fromRootViewController: self)
            interstitial = createAd()
            print("ad should be displaying")
        }else{
            print("ad isnt ready")
        }
    }
    //interstitial Ad 2********************
    var interstitial2: GADInterstitial!
    func loadInterstitialAd2(){
        interstitial2 = GADInterstitial(adUnitID: "ca-app-pub-1323381872235473/4640388487")
        let request = GADRequest()
        request.testDevices = ["997a25edf07df666778ec70835e67aa7", kGADSimulatorID]
        interstitial2.load(request)
    }
    func createAd2() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-1323381872235473/4640388487")
        interstitial.load(GADRequest())
        return interstitial
    }
    func showInterstitialAd2(){
        if interstitial2.isReady{
            interstitial2.present(fromRootViewController: self)
            interstitial2 = createAd()
            print("ad should be displaying")
        }else{
            print("ad isnt ready")
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // admob
        showBannerAd()
        loadInterstitialAd()
        loadInterstitialAd2()
        interstitialCount = 0
//        let request = GADRequest()
//        request.testDevices = ["997a25edf07df666778ec70835e67aa7", kGADSimulatorID]
//        adViewDidReceiveAd(view: bannerAR)
//        bannerAR.adUnitID = "ca-app-pub-3940256099942544/2934735716"
//        bannerAR.rootViewController = self
//        bannerAR.delegate = self
//        bannerAR.load(request)
        
        
        
        // Set the view's delegate
        sceneView.delegate = self
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        // Create a new scene
        let scene = SCNScene()
        // Set the scene to the view
        sceneView.scene = scene
        
        sceneView.autoenablesDefaultLighting = false
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
        
        blurrEfect(bg: middleBig)
        blurrEfect(bg: middleSmall)
        blurrEfect(bg: plusImg)
        blurrEfect(bg: minusImg)
        blurrEfect(bg: trashImg)
        blurrEfect(bg: copyImg)
        blurrEfect(bg: takesPhotobtnImg)
        blurrEfectForPanel()
                    UIView.animate(withDuration: 4, animations: {
                        self.displayLbl.alpha = 1
                        self.displayLbl.text = "Move to scan the floor"
                        self.camer360Img.alpha = 1
                    }) { (finished) in
                    }

        insertSpotLight(position: SCNVector3(0.0,2,0.1))

    }
    var spotLight = SCNLight()
    private func insertSpotLight(position: SCNVector3){
         spotLight = SCNLight()
        spotLight.type = .directional
        spotLight.spotInnerAngle = 40
        spotLight.spotOuterAngle = 40
        spotLight.castsShadow = true
        spotLight.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        //spotLight.shadowRadius = 100
        spotLight.shadowBias = 0.5
        

        let spotNode = SCNNode()
        spotNode.name = "SpotNode"
        spotNode.light = spotLight
        spotNode.position = position
        
        //spotNode.light?.orthographicScale = 100
        
        spotNode.eulerAngles = SCNVector3(-Double.pi/2,0,-0.2)
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

        confirmOn.alpha = 1

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
            boxMetal = eachBoxSize[currentBoxNumber]!.2["metal"]!
            boxRoughness = eachBoxSize[currentBoxNumber]!.3["roughness"]!
            boxNormal = eachBoxSize[currentBoxNumber]!.4["normal"]!
            
            var geo = SCNGeometry()
            geo = SCNBox(width: boxWidth, height:  boxHight, length: boxLength, chamferRadius: 0)
            eachBoxSize[currentBoxNumber]!.0.updateValue(boxWidth, forKey: "x")
            eachBoxSize[currentBoxNumber]!.0.updateValue(boxHight, forKey: "y")
            eachBoxSize[currentBoxNumber]!.0.updateValue(boxLength, forKey: "z")
            eachBoxSize[currentBoxNumber]!.1.updateValue(boxColor, forKey: "color")
            eachBoxSize[currentBoxNumber]!.2.updateValue(boxMetal, forKey: "metal")
            eachBoxSize[currentBoxNumber]!.3.updateValue(boxRoughness, forKey: "roughness")
            eachBoxSize[currentBoxNumber]!.4.updateValue(boxNormal, forKey: "normal")
            
            print("eachboxSize  after scale is \(eachBoxSize)")
            currentNode.geometry = geo
            let top = SCNMaterial()
            top.diffuse.contents = boxColor
            top.lightingModel = SCNMaterial.LightingModel.physicallyBased
            top.roughness.contents = boxRoughness
            top.metalness.contents = boxMetal
            top.normal.contents = boxNormal
            let bottom = SCNMaterial()
            bottom.diffuse.contents = boxColor
            bottom.lightingModel = SCNMaterial.LightingModel.physicallyBased
            bottom.roughness.contents = boxRoughness
            bottom.metalness.contents = boxMetal
            bottom.normal.contents = boxNormal
            let left = SCNMaterial()
            left.diffuse.contents = boxColor
            left.lightingModel = SCNMaterial.LightingModel.physicallyBased
            left.roughness.contents = boxRoughness
            left.metalness.contents = boxMetal
            left.normal.contents = boxNormal
            let right = SCNMaterial()
            right.diffuse.contents = boxColor
            right.lightingModel = SCNMaterial.LightingModel.physicallyBased
            right.roughness.contents = boxRoughness
            right.metalness.contents = boxMetal
            right.normal.contents = boxNormal
            let front = SCNMaterial()
            front.diffuse.contents = boxColor
            front.lightingModel = SCNMaterial.LightingModel.physicallyBased
            front.roughness.contents = boxRoughness
            front.metalness.contents = boxMetal
            front.normal.contents = boxNormal
            //let back = SCNMaterial()
            let back = SCNMaterial()
            back.diffuse.contents = boxColor
            back.lightingModel = SCNMaterial.LightingModel.physicallyBased
            back.roughness.contents = boxRoughness
            back.metalness.contents = boxMetal
            back.normal.contents = boxNormal
            geo.materials = [front, right, back, left, top, bottom]
            print(boxGeometry.width)
            print(boxGeometry.height)
            print(boxGeometry.length)
            print(currentNode.name)
            //print("added node \(eachBoxSize)")
        }
    }
    
    @IBAction func scaleDown(_ sender: Any) {

        confirmOn.alpha = 1

        
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
            boxMetal = eachBoxSize[currentBoxNumber]!.2["metal"]!
            boxRoughness = eachBoxSize[currentBoxNumber]!.3["roughness"]!
            boxNormal = eachBoxSize[currentBoxNumber]!.4["normal"]!
            
            //eachBoxSize[currentBoxNumber]
            var geo = SCNGeometry()
            geo = SCNBox(width: boxWidth, height: boxHight, length: boxLength, chamferRadius: 0)
            eachBoxSize[currentBoxNumber]!.0.updateValue(boxWidth, forKey: "x")
            eachBoxSize[currentBoxNumber]!.0.updateValue(boxHight, forKey: "y")
            eachBoxSize[currentBoxNumber]!.0.updateValue(boxLength, forKey: "z")
            eachBoxSize[currentBoxNumber]!.1.updateValue(boxColor, forKey: "color")
            eachBoxSize[currentBoxNumber]!.2.updateValue(boxMetal, forKey: "metal")
            eachBoxSize[currentBoxNumber]!.3.updateValue(boxRoughness, forKey: "roughness")
            eachBoxSize[currentBoxNumber]!.4.updateValue(boxNormal, forKey: "normal")
            currentNode.geometry = geo
            let top = SCNMaterial()
            top.diffuse.contents = boxColor
            top.lightingModel = SCNMaterial.LightingModel.physicallyBased
            top.roughness.contents = boxRoughness
            top.metalness.contents = boxMetal
            top.normal.contents = boxNormal
            let bottom = SCNMaterial()
            bottom.diffuse.contents = boxColor
            bottom.lightingModel = SCNMaterial.LightingModel.physicallyBased
            bottom.roughness.contents = boxRoughness
            bottom.metalness.contents = boxMetal
            bottom.normal.contents = boxNormal
            let left = SCNMaterial()
            left.diffuse.contents = boxColor
            left.lightingModel = SCNMaterial.LightingModel.physicallyBased
            left.roughness.contents = boxRoughness
            left.metalness.contents = boxMetal
            left.normal.contents = boxNormal
            let right = SCNMaterial()
            right.diffuse.contents = boxColor
            right.lightingModel = SCNMaterial.LightingModel.physicallyBased
            right.roughness.contents = boxRoughness
            right.metalness.contents = boxMetal
            right.normal.contents = boxNormal
            let front = SCNMaterial()
            front.diffuse.contents = boxColor
            front.lightingModel = SCNMaterial.LightingModel.physicallyBased
            front.roughness.contents = boxRoughness
            front.metalness.contents = boxMetal
            front.normal.contents = boxNormal
            let back = SCNMaterial()
            back.diffuse.contents = boxColor
            back.lightingModel = SCNMaterial.LightingModel.physicallyBased
            back.roughness.contents = boxRoughness
            back.metalness.contents = boxMetal
            back.normal.contents = boxNormal
            geo.materials = [front, right, back, left, top, bottom]
            print(boxRoughness)
            print(boxGeometry.width)
            print(boxGeometry.height)
            print(boxGeometry.length)
            print(currentNode.name)
            print("added node \(eachBoxSize)")
        }
    }
    @IBAction func deleteAction(_ sender: Any) {
        print("delete")
        if scaleAble{
            print("in delete: nodes name is\(currentNode.name)")
            //remove node
           currentNode.removeFromParentNode()
            //display confirm text
           createDeleteText()
            //take away panel
            displayAllBtns(toAlpha: 0.0)
            confirmOn.alpha = 0.0
            addingBtn.alpha = 1.0
            scaleAble = false
        }
    }
    
    @objc func moving(recognizer: UIPanGestureRecognizer){
       
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

    }
    enum PanelOpened{
        case panelOpened
        case panelClosed
    }
    enum AddObject {
        case addAble
        case notAddAble
    }
    
    var panelState = PanelOpened.panelClosed
    var addingState = AddObject.addAble
    @objc func tapped(recognizer :UIGestureRecognizer) {
        
        
            let sceneView = recognizer.view as! ARSCNView
            let touchLocation = recognizer.location(in: sceneView)
            let hitTestResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            if !hitTestResult.isEmpty {
                guard let hitResult = hitTestResult.first else {
                    return
                }
                //Admob interstitial count
                //+1 on interstitial count every 5th box has an interstitial ad
                interstitialCount += 1
                if interstitialCount == 7{
                    showInterstitialAd()
                    loadInterstitialAd2()
                }
                if interstitialCount == 14{
                    showInterstitialAd2()
                    loadInterstitialAd()
                    interstitialCount = 0
                }
                //no text display while adding box or tapping screen
                self.displayLbl.text = ""
                //copy the chosen node
                if movingStatus == .chooseToCopy{
                    boxLength = eachBoxSize[currentBoxNumber]!.0["z"]!
                    boxHight = eachBoxSize[currentBoxNumber]!.0["y"]!
                    boxWidth = eachBoxSize[currentBoxNumber]!.0["x"]!
                    boxColor = eachBoxSize[currentBoxNumber]!.1["color"]!
                    boxMetal = eachBoxSize[currentBoxNumber]!.2["metal"]!
                    boxRoughness = eachBoxSize[currentBoxNumber]!.3["roughness"]!
                    boxNormal = eachBoxSize[currentBoxNumber]!.4["normal"]!
                    //add new cube
                    addCopiedBox(hitResult: hitResult, color: boxColor, metal: boxMetal, roughness: boxRoughness, normal: boxNormal, width: boxWidth, height: boxHight, length: boxLength)
                    //add copy text and take off panel
                    displayAllBtns(toAlpha: 0.0)
                    addingBtn.alpha = 1.0
                    confirmOn.alpha = 0.0
                    createCopyText()
                    //change moving state
                    movingStatus = .currentMovingNotChosen
                    //show pink display
                    

                }
                if addingState == .addAble{
                //pick the chosen color, add cube to scene in that color
                    
                if chosenStatus == .redBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "blockIcon")!, metal: UIImage(named: "scuffed-plastic-metal")!, roughness: UIImage(named: "scuffed-plastic-roughness")!, normal: UIImage(named: "scuffed-plastic-normal")!)
                }else if chosenStatus == .blueBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "blueBlockIcon")!, metal: UIImage(named: "scuffed-plastic-metal")!, roughness: UIImage(named: "scuffed-plastic-roughness")!, normal: UIImage(named: "scuffed-plastic-normal")!)
                }else if chosenStatus == .orangeBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "orangeBlockIcon")!, metal: UIImage(named: "scuffed-plastic-metal")!, roughness: UIImage(named: "scuffed-plastic-roughness")!, normal: UIImage(named: "scuffed-plastic-normal")!)
                }else if chosenStatus == .yellowBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "yellowBlockIcon")!, metal: UIImage(named: "scuffed-plastic-metal")!, roughness: UIImage(named: "scuffed-plastic-roughness")!, normal: UIImage(named: "scuffed-plastic-normal")!)
                }else if chosenStatus == .greenBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "greenBlockIcon")!, metal: UIImage(named: "scuffed-plastic-metal")!, roughness: UIImage(named: "scuffed-plastic-roughness")!, normal: UIImage(named: "scuffed-plastic-normal")!)
                }else if chosenStatus == .PurpleBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "purpleBlockIcon")!, metal: UIImage(named: "scuffed-plastic-metal")!, roughness: UIImage(named: "scuffed-plastic-roughness")!, normal: UIImage(named: "scuffed-plastic-normal")!)
                }else if chosenStatus == .pinkBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "pinkBlockIcon")!, metal: UIImage(named: "scuffed-plastic-metal")!, roughness: UIImage(named: "scuffed-plastic-roughness")!, normal: UIImage(named: "scuffed-plastic-normal")!)
                }else if chosenStatus == .blackBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "blackBockIcon")!, metal: UIImage(named: "scuffed-plastic-metal")!, roughness: UIImage(named: "scuffed-plastic-roughness")!, normal: UIImage(named: "scuffed-plastic-normal")!)
                }else if chosenStatus == .greyBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "greyBlockIcon")!, metal: UIImage(named: "scuffed-plastic-metal")!, roughness: UIImage(named: "scuffed-plastic-roughness")!, normal: UIImage(named: "scuffed-plastic-normal")!)
                }else if chosenStatus == .brownBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "brownBlockIcon")!, metal: UIImage(named: "scuffed-plastic-metal")!, roughness: UIImage(named: "scuffed-plastic-roughness")!, normal: UIImage(named: "scuffed-plastic-normal")!)
                }else if chosenStatus == .whiteBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "whiteBlockicon")!, metal: UIImage(named: "scuffed-plastic-metal")!, roughness: UIImage(named: "scuffed-plastic-roughness")!, normal: UIImage(named: "scuffed-plastic-normal")!)
                }else if chosenStatus == .bambooBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "bamboo-wood-semigloss-albedo")!, metal: UIImage(named: "bamboo-wood-semigloss-metal")!, roughness: UIImage(named: "bamboo-wood-semigloss-roughness")!, normal: UIImage(named: "bamboo-wood-semigloss-normal")!)
                }else if chosenStatus == .oakFloorBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "oakfloor2-albedo")!, metal: UIImage(named: "bamboo-wood-semigloss-metal")!, roughness: UIImage(named: "oakfloor2-roughness")!, normal: UIImage(named: "oakfloor2-normal")!)
                }else if chosenStatus == .rustyBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "rustediron-streaks-albedo")!, metal: UIImage(named: "rustediron-streaks-metal")!, roughness: UIImage(named: "rustediron-streaks-roughness")!, normal: UIImage(named: "rustediron-streaks-normal")!)
                }else if chosenStatus == .greesMetalBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "greasy-metal-pan1-albedo")!, metal: UIImage(named: "greasy-metal-pan1-metal")!, roughness: UIImage(named: "greasy-metal-pan1-roughness")!, normal: UIImage(named: "greasy-metal-pan1-normal")!)
                }else if chosenStatus == .streakMetal{
                    addBox(hitResult: hitResult, color: UIImage(named: "streakedmetal-albedo")!, metal: UIImage(named: "streakedmetal-metalness")!, roughness: UIImage(named: "streakedmetal-roughness")!, normal: UIImage(named: "rustediron2_normal")!)
                }else if chosenStatus == .rustIronBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "rustediron2_basecolor")!, metal: UIImage(named: "rustediron2_metallic")!, roughness: UIImage(named: "rustediron2_roughness")!, normal: UIImage(named: "rustediron2_normal")!)
                }else if chosenStatus == .rockBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "holey-rock1-albedo")!, metal: UIImage(named: "holey-rock1-metalness")!, roughness: UIImage(named: "holey-rock1-roughness")!, normal: UIImage(named: "holey-rock1-normal-ue")!)
                }else if chosenStatus == .syntheticRubberBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "synth-rubber-albedo")!, metal: UIImage(named: "synth-rubber-metalness")!, roughness: UIImage(named: "synth-rubber-roughness")!, normal: UIImage(named: "synth-rubber-normal")!)
                }else if chosenStatus == .plasticPatterBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "plasticpattern1-albedo")!, metal: UIImage(named: "plasticpattern1-metalness")!, roughness: UIImage(named: "plasticpattern1-roughness2")!, normal: UIImage(named: "plasticpattern1-normal2b")!)
                }else if chosenStatus == .mahagoniBox{
                    addBox(hitResult: hitResult, color: UIImage(named: "mahogfloor_basecolor")!, metal: UIImage(named: "mahogfloor_AO")!, roughness: UIImage(named: "mahogfloor_roughness")!, normal: UIImage(named: "mahogfloor_normal")!)
                }
               
            }else if hitTestResult.isEmpty{
                print("touchlocation is empty")
            }
        }
    }
  


    @IBOutlet var cancelBtn: UIButton!
    @IBAction func cancelSceneAction(_ sender: Any) {
        
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, animations: {
                self.blurBarImg.center.x = self.cancelBtn.center.x
                self.isOnScan = false
            }) { (finished) in
            }
            group.leave()
        }
        group.notify(queue: .main){
            self.reloadViewFromNib()
            
        }
 
    }
    
    @IBAction func takeScreenshot(_ sender: Any) {
        //the camera button, changing to alpha 1
        UIView.animate(withDuration: 0.1, animations: {
            self.blurBarImg.center.x = self.camBtn.center.x
            self.isOnScan = false
        }) { (finished) in
        }
        print("pushed photo1")
        UIView.animate(withDuration: 0.3, animations: {
            self.takesPhotoBtn.alpha = 1.0
            self.takesPhotoBtn.layer.zPosition = 11
            self.takesPhotobtnImg.alpha = 1.0
            self.takesPhotobtnImg.layer.zPosition = 11
            //change alpha of all buttons in scene
            self.addingBtn.alpha = 0
            self.camBtn.alpha = 0.0
            self.cancelBtn.alpha = 0.0
            self.scanBtn.alpha = 0.0
            self.pinkPanel.alpha = 0.0
            self.blurBarImg.alpha = 0.0
        }) { (finished) in
        }
    }
    
    func screenshotAnimation(){
        let screen = SKSpriteNode(imageNamed: "blackScreen")
        screen.size = overlay.size
        screen.alpha = 0
        overlay.addChild(screen)
        let action1 = SKAction.fadeIn(withDuration: 0.1)
        let wait = SKAction.wait(forDuration: 0.1)
        let action2 = SKAction.fadeOut(withDuration: 0.1)
        let remove = SKAction.removeFromParent()
        screen.run(SKAction.sequence([action1, wait, action2, remove]))
    }
    @IBOutlet var takesPhotobtnImg: UIImageView!
    @IBOutlet var takesPhotoBtn: UIButton!
    
    enum ShootingCase{
        case takingScreenshoot
        case doneTakingScreenshot
    }
    var screenshotImage = UIImageView()
    var screenshotStatus = ShootingCase.doneTakingScreenshot
    @IBAction func takesPhoto(_ sender: Any) {
        screenshotImage.removeFromSuperview()
        // taking screenshot, and changing button back to alpha 0.0
        print("screenshot")
        //
        let bounds = overlay.view?.bounds
        UIGraphicsBeginImageContextWithOptions((bounds?.size)!, true, UIScreen.main.scale)
        overlay.view?.drawHierarchy(in: bounds!, afterScreenUpdates: true)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
        screenshotImage = UIImageView(image: screenshot)
        screenshotImage.bounds.size = view.bounds.size / 6
        //screenshotImage.center = self.view.center
        screenshotImage.center.y = self.view.center.y + 250
        screenshotImage.center.x = self.view.center.x + 315
        self.view.addSubview(screenshotImage)
        
        //
        func changeStatus(){
            screenshotStatus = .takingScreenshoot
        }
        let activityVC = UIActivityViewController(activityItems: [screenshot], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: changeStatus)
        //
        screenshotAnimation()
        UIView.animate(withDuration: 0.3, animations: {
            self.takesPhotoBtn.alpha = 0.0
            self.takesPhotobtnImg.alpha = 0.0
            //change alpha of all buttons in scene
            self.addingBtn.alpha = 1
            self.camBtn.alpha = 1
            self.cancelBtn.alpha = 1
            self.scanBtn.alpha = 1
            self.pinkPanel.alpha = 1
            self.blurBarImg.alpha = 1
        }) { (finished) in
        }
    }
    
    

    @IBAction func addObjects(_ sender: Any) {
        //screenshotsaction disable
        if screenshotStatus == .takingScreenshoot{
            screenshotStatus = .doneTakingScreenshot
            screenshotImage.removeFromSuperview()
        }
        //
        displayAllBtns(toAlpha: 0.0)
        confirmOn.alpha = 0
        if openedPanel == true{
            closePanel()
        }else if openedPanel == false{
            openPanel()
        }   
    }
    var shadowYposition = Float()
    var addingNewCube = Bool()
    private func addBox(hitResult :ARHitTestResult, color: UIImage, metal: UIImage, roughness: UIImage, normal: UIImage) {
        
        
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
            boxMetal = metal
            boxRoughness = roughness
            boxNormal = normal
        boxGeometry = SCNBox(width: boxWidth, height: boxHight, length: boxLength, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = color
        let top = SCNMaterial()
        top.diffuse.contents = color
            top.lightingModel = SCNMaterial.LightingModel.physicallyBased
            top.roughness.contents = boxRoughness
            top.metalness.contents = boxMetal
            top.normal.contents = boxNormal
        let bottom = SCNMaterial()
        bottom.diffuse.contents = color
            bottom.lightingModel = SCNMaterial.LightingModel.physicallyBased

            bottom.roughness.contents = boxRoughness
            bottom.metalness.contents = boxMetal
            bottom.normal.contents = boxNormal
        let left = SCNMaterial()
        left.diffuse.contents = color
            left.lightingModel = SCNMaterial.LightingModel.physicallyBased
            left.roughness.contents = boxRoughness
            left.metalness.contents = boxMetal
            left.normal.contents = boxNormal
        let right = SCNMaterial()
        right.diffuse.contents = color
            right.lightingModel = SCNMaterial.LightingModel.physicallyBased
            right.roughness.contents = boxRoughness
            right.metalness.contents = boxMetal
            right.normal.contents = boxNormal
        let front = SCNMaterial()
        front.diffuse.contents = color
            front.lightingModel = SCNMaterial.LightingModel.physicallyBased
            front.roughness.contents = boxRoughness
            front.metalness.contents = boxMetal
            front.normal.contents = boxNormal
        let back = SCNMaterial()
        back.diffuse.contents = color
            back.lightingModel = SCNMaterial.LightingModel.physicallyBased
            back.roughness.contents = boxRoughness
            back.metalness.contents = boxMetal
            back.normal.contents = boxNormal
            
            print(boxRoughness)
        boxGeometry.chamferRadius = 0
        boxGeometry.materials = [front, right, back, left, top, bottom]

        boxNode = SCNNode(geometry: boxGeometry)
        boxNode.light?.castsShadow = true
        boxNode.name = "boxNode\(boxNodeNumber)"
            eachBoxSize.updateValue((["x": boxGeometry.width, "y": boxGeometry.height, "z": boxGeometry.height], ["color": color], ["metal": boxMetal], ["roughness": boxRoughness], ["normal": boxNormal]), forKey: boxNodeNumber)
        boxNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,hitResult.worldTransform.columns.3.y + Float(boxGeometry.height/2), hitResult.worldTransform.columns.3.z)
        self.sceneView.scene.rootNode.addChildNode(boxNode)
        print("added node \(eachBoxSize)")
   
        }
    }
    private func addCopiedBox(hitResult :ARHitTestResult, color: UIImage, metal: UIImage, roughness: UIImage, normal: UIImage, width: CGFloat, height: CGFloat, length: CGFloat) {
        //disactivate selected and scaleable
        scaleAble = false
        selected = false
        isMoving = false
        addingNewCube = true
        currentMovingNode.opacity = 1
       // movingStatus = .currentMovingNotChosen
        //
        if addingNewCube{
            boxNodeNumber += 1
            boxNodeNumbers.append(boxNodeNumber)
            boxWidth = width
            boxHight = height
            boxLength = length
            boxMetal = metal
            boxRoughness = roughness
            boxNormal = normal
            boxGeometry = SCNBox(width: boxWidth, height: boxHight, length: boxLength, chamferRadius: 0)
            let material = SCNMaterial()
            material.diffuse.contents = color
            let top = SCNMaterial()
            top.diffuse.contents = color
            top.lightingModel = SCNMaterial.LightingModel.physicallyBased
            top.roughness.contents = boxRoughness
            top.metalness.contents = boxMetal
            top.normal.contents = boxNormal
            let bottom = SCNMaterial()
            bottom.diffuse.contents = color
            bottom.lightingModel = SCNMaterial.LightingModel.physicallyBased
            
            bottom.roughness.contents = boxRoughness
            bottom.metalness.contents = boxMetal
            bottom.normal.contents = boxNormal
            let left = SCNMaterial()
            left.diffuse.contents = color
            left.lightingModel = SCNMaterial.LightingModel.physicallyBased
            left.roughness.contents = boxRoughness
            left.metalness.contents = boxMetal
            left.normal.contents = boxNormal
            let right = SCNMaterial()
            right.diffuse.contents = color
            right.lightingModel = SCNMaterial.LightingModel.physicallyBased
            right.roughness.contents = boxRoughness
            right.metalness.contents = boxMetal
            right.normal.contents = boxNormal
            let front = SCNMaterial()
            front.diffuse.contents = color
            front.lightingModel = SCNMaterial.LightingModel.physicallyBased
            front.roughness.contents = boxRoughness
            front.metalness.contents = boxMetal
            front.normal.contents = boxNormal
            let back = SCNMaterial()
            back.diffuse.contents = color
            back.lightingModel = SCNMaterial.LightingModel.physicallyBased
            back.roughness.contents = boxRoughness
            back.metalness.contents = boxMetal
            back.normal.contents = boxNormal
            
            print(boxRoughness)
            boxGeometry.chamferRadius = 0
            boxGeometry.materials = [front, right, back, left, top, bottom]
            
            boxNode = SCNNode(geometry: boxGeometry)
            
            boxNode.name = "boxNode\(boxNodeNumber)"
            eachBoxSize.updateValue((["x": boxGeometry.width, "y": boxGeometry.height, "z": boxGeometry.height], ["color": color], ["metal": boxMetal], ["roughness": boxRoughness], ["normal": boxNormal]), forKey: boxNodeNumber)
            boxNode.position = SCNVector3(hitResult.worldTransform.columns.3.x,hitResult.worldTransform.columns.3.y + Float(boxGeometry.height/2), hitResult.worldTransform.columns.3.z)
            self.sceneView.scene.rootNode.addChildNode(boxNode)
            print("added node \(eachBoxSize)")
            
        }
    }
    
    //close and open panel
    func closePanel(){
        panelState = .panelClosed
        let moveDown = SKAction.moveTo(y: -(view.frame.height / 1.5), duration: 0.3)
        openedPanel = false
        panel.run(moveDown)
        self.displayLbl.text = ""
        tapGestureRecognizer.isEnabled = true
    }
    func openPanel(){
        panelState = .panelOpened
        let moveUp = SKAction.moveTo(y: -30, duration: 0.3)
        openedPanel = true
        panel.run(moveUp)
        self.displayLbl.text = "Select an object"
        tapGestureRecognizer.isEnabled = false
    }
    //choose item from panel
    func chooseBlockItem(boolien: Bool){
        //panel close
        closePanel()
        //item can be placed
        chooseBlock = boolien
    }
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let estimate = self.sceneView.session.currentFrame?.lightEstimate
        if estimate == nil{
            return
        }
        //let intensity = (estimate?.ambientIntensity)! / 1000
        let spotNode = self.sceneView.scene.rootNode.childNode(withName: "SpotNode", recursively: true)
        //spotNode?.light?.intensity = intensity
        spotNode?.light?.intensity = (estimate?.ambientIntensity)!

    }
    func updateAllCordinates(){

    
        eachBoxSize[currentBoxNumber]!.0.updateValue(boxHight, forKey: "y")
        eachBoxSize[currentBoxNumber]!.0.updateValue(boxLength, forKey: "z")
        eachBoxSize[currentBoxNumber]!.1.updateValue(boxColor, forKey: "color")
        eachBoxSize[currentBoxNumber]!.2.updateValue(boxMetal, forKey: "metal")
        eachBoxSize[currentBoxNumber]!.3.updateValue(boxRoughness, forKey: "roughness")
        eachBoxSize[currentBoxNumber]!.4.updateValue(boxNormal, forKey: "normal")
        eachBoxSize[currentBoxNumber]!.0.updateValue(boxWidth, forKey: "x")
        eachBoxSize[currentBoxNumber]!.0.updateValue(boxHight, forKey: "y")
        eachBoxSize[currentBoxNumber]!.0.updateValue(boxLength, forKey: "z")
        eachBoxSize[currentBoxNumber]!.1.updateValue(boxColor, forKey: "color")
        eachBoxSize[currentBoxNumber]!.2.updateValue(boxMetal, forKey: "metal")
        eachBoxSize[currentBoxNumber]!.3.updateValue(boxRoughness, forKey: "roughness")
        eachBoxSize[currentBoxNumber]!.4.updateValue(boxNormal, forKey: "normal")
        eachBoxSize[destinationBoxNumber]!.0.updateValue(boxWidthD, forKey: "x")
        eachBoxSize[destinationBoxNumber]!.0.updateValue(boxHightD, forKey: "y")
        eachBoxSize[destinationBoxNumber]!.0.updateValue(boxLengthD, forKey: "z")
        eachBoxSize[destinationBoxNumber]!.1.updateValue(boxColorD, forKey: "color")
        eachBoxSize[destinationBoxNumber]!.2.updateValue(boxMetalD, forKey: "metal")
        eachBoxSize[destinationBoxNumber]!.3.updateValue(boxRoughnessD, forKey: "roughness")
        eachBoxSize[destinationBoxNumber]!.4.updateValue(boxNormalD, forKey: "normal")
    }
    func importAllCoordinates(){

        boxLength = eachBoxSize[currentBoxNumber]!.0["z"]!
        boxHight = eachBoxSize[currentBoxNumber]!.0["y"]!
        boxWidth = eachBoxSize[currentBoxNumber]!.0["x"]!
        boxColor = eachBoxSize[currentBoxNumber]!.1["color"]!
        boxMetal = eachBoxSize[currentBoxNumber]!.2["metal"]!
        boxRoughness = eachBoxSize[currentBoxNumber]!.3["roughness"]!
        boxNormal = eachBoxSize[currentBoxNumber]!.4["normal"]!
        boxLengthD = eachBoxSize[destinationBoxNumber]!.0["z"]!
        boxHightD = eachBoxSize[destinationBoxNumber]!.0["y"]!
        boxWidthD = eachBoxSize[destinationBoxNumber]!.0["x"]!
        boxColorD = eachBoxSize[destinationBoxNumber]!.1["color"]!
        boxMetalD = eachBoxSize[destinationBoxNumber]!.2["metal"]!
        boxRoughnessD = eachBoxSize[destinationBoxNumber]!.3["roughness"]!
        boxNormalD = eachBoxSize[destinationBoxNumber]!.4["normal"]!
    }
    func showHiglightOfDestinationFace(material: SCNMaterial){
        let highlight = CABasicAnimation(keyPath: "opacity")
        highlight.fromValue = 0.0
        highlight.toValue = 1.0
        highlight.duration = 1.0
        highlight.autoreverses = true
        highlight.isRemovedOnCompletion = true
        material.addAnimation(highlight, forKey: nil)

    }
    
    var isMoving = Bool()
    var currentSelctedCopyNode = SCNNode()
    var copyBoxNmber = Int()
    enum SelectionType{
        case currentMovingChosen
        case currentMovingNotChosen
        case chooseNewMovingNode
        case chooseToCopy
    }
    func displayAllBtns(toAlpha: CGFloat){
        UIView.animate(withDuration: 0.3, animations: {
            //coordinates
            self.upBtn.alpha = toAlpha
            self.downBtn.alpha = toAlpha
            self.leftBtn.alpha = toAlpha
            self.rightBtn.alpha = toAlpha
            self.in1Btn.alpha = toAlpha
            self.out1Btn.alpha = toAlpha
            self.middleRound.alpha = toAlpha
            self.middleSmall.alpha = toAlpha
            self.middleBig.alpha = toAlpha
            //scales
            self.minusBtn.alpha = toAlpha
            self.minusImg.alpha = toAlpha
            self.plusBtn.alpha = toAlpha
            self.plusImg.alpha = toAlpha
            //copy
            self.copyBtn.alpha = toAlpha
            self.copyImg.alpha = toAlpha
            //trash
            self.trashBtn.alpha = toAlpha
            self.trashImg.alpha = toAlpha
        }) { (finished) in
        }
    }
    
    
    @IBAction func confirm360Action(_ sender: Any) {
        let configuration = self.sceneView.session.configuration as! ARWorldTrackingSessionConfiguration
        configuration.isLightEstimationEnabled = true
        configuration.planeDetection = []
        self.sceneView.session.run(configuration, options: [])
        
        for plane in self.planes{
            spotLight.shadowMode = .deferred
            plane.planeGeometry.materials.forEach({ (material) in
                material.diffuse.contents = UIImage(named: "planeBlue")
                //material.colorBufferWriteMask = SCNColorMask(rawValue: 0)
                self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
                //set plane to fix
                planeFix = true
            })
        }
        UIView.animate(withDuration: 0.3, animations: {
            self.camBtn.alpha = 1
            self.camBtn.layer.zPosition = 2
            self.blurBarImg.alpha = 1
            self.blurBarImg.layer.zPosition = 2
            self.scanBtn.alpha = 1
            self.scanBtn.layer.zPosition = 2
            self.cancelBtn.alpha = 1
            self.cancelBtn.layer.zPosition = 2
            self.blurBarImg.alpha = 1
            self.blurBarImg.layer.zPosition = 2
            self.pinkPanel.alpha = 1
            self.pinkPanel.layer.zPosition = 0
            self.confirm360.alpha = 0
            self.camer360Img.alpha = 0
            self.camera360ImgGreen.alpha = 0
            self.displayLbl.text = ""
            self.addingBtn.alpha = 1
            self.addingBtn.layer.zPosition = 10
            print("called pink panel and the rest")
        }) { (finished) in
        }
        //get in addButton
    }
    
    //reloads again whole scene
    func reloadViewFromNib() {
        
        nodeOverPlane.removeFromParentNode()
        planes.removeAll()
        self.viewDidLoad()
        self.viewWillAppear(true)
        
        let parent = view.superview
        view.removeFromSuperview()
        view = nil
        parent?.addSubview(view) // This line causes the view to be reloaded
    }
    var planeFix = false
    var nodeOverPlane = SCNNode()
    var isOnScan = false
    @IBAction func scanAction(_ sender: Any) {
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.1, animations: {
            
                if self.isOnScan == false{
                self.blurBarImg.center.x = self.scanBtn.center.x
                self.isOnScan = true
                }
            }) { (finished) in
            }
            group.leave()
        }
        group.notify(queue: .main){
 
            if self.planeFix{
                
                self.scanBtn.setImage(UIImage(named: "scanEmpty"), for: .normal)
                let configuration = self.sceneView.session.configuration as! ARWorldTrackingSessionConfiguration
                configuration.isLightEstimationEnabled = true
                configuration.planeDetection = []
                self.sceneView.session.run(configuration, options: [])
                
                self.nodeOverPlane.removeFromParentNode()
                for plane in self.planes{
                    
                    plane.planeGeometry.materials.forEach({ (material) in
                        material.diffuse.contents = UIColor.white
                        material.colorBufferWriteMask = SCNColorMask(rawValue: 0)
                        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin]
                    })
                }
                self.planeFix = false
            }else{
                
                self.scanBtn.setImage(UIImage(named: "scanFill"), for: .normal)
                self.nodeOverPlane.removeFromParentNode()
                for plane in self.planes{
                    
                    
                    
                    plane.planeGeometry.materials.forEach({ (material) in
                        
                        let request = GADRequest()
                        request.testDevices = ["997a25edf07df666778ec70835e67aa7", kGADSimulatorID]
                        var bannerView: GADBannerView!
                        if UIDevice.current.userInterfaceIdiom == .pad{
                            bannerView = GADBannerView(adSize: kGADAdSizeFullBanner)
                            bannerView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2 - self.view.frame.height / 2 + 45)
                        }
                        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
                        bannerView.delegate = self
                        bannerView.rootViewController = self
                        bannerView.load(request)
                        
                        let view = bannerView
                        let image = UIImage.imageWithView(view: view!)
                        
                        
                        
                        
                        var geometry = SCNGeometry()
                        geometry = plane.planeGeometry
                        let material = SCNMaterial()
                        material.diffuse.contents = image as! UIImage
                        geometry.materials = [material]
                        self.nodeOverPlane = SCNNode(geometry: geometry)
                        self.nodeOverPlane.transform = SCNMatrix4MakeRotation(Float(-Double.pi / 2.0), 1.0, 0.0, 0.0);
                        plane.addChildNode(self.nodeOverPlane)
                    })
                }
                self.planeFix = true
            }
        }
        
    }
    
    
    
    var movingStatus = SelectionType.currentMovingNotChosen
    enum CubeFace: Int {
        case Front, Right, Back, Left, Top, Bottom
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if screenshotStatus == .takingScreenshoot{
            screenshotStatus = .doneTakingScreenshot
            screenshotImage.removeFromSuperview()
        }
        if let touch = touches.first{
            let location = touch.location(in: sceneView as ARSCNView)
            let hitList = sceneView.hitTest(location, options: nil)
            if let hitObject = hitList.first{
                
                if movingStatus ==  .currentMovingNotChosen && panelState == .panelClosed{
                    for boxNodeNumber in boxNodeNumbers{
                        let node = hitObject.node
                        if node.name == "boxNode\(boxNodeNumber)"{
                            let group = DispatchGroup()
                            group.enter()
                            DispatchQueue.main.async {
                                self.currentNode = node
                                self.currentMovingNode = node
                                self.currentBoxNumber = boxNodeNumber
                                self.currentSelctedCopyNode = node
                                print("currentMovingNode name is\(self.currentMovingNode.name)")
                                //
                                self.addingState = .notAddAble
                                self.scaleAble = true
                                self.currentMovingNode.opacity = 0.7
                                self.currentSelctedCopyNode.opacity = 0.7
                                self.currentNode.opacity = 0.7
                                print("selected boxwidth is \(self.boxGeometry.width)")
                                //show coordinates
                                self.displayAllBtns(toAlpha: 1.0)
                                self.displayLbl.text = ""
                                self.confirmOn.alpha = 1
                                self.addingBtn.alpha = 0
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
                            self.displayLbl.text = ""
                            displayAllBtns(toAlpha: 0.0)
                            confirmOn.alpha = 0
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
                                   // currentMovingNode.childNode(withName: "shadow\(currentBoxNumber)", recursively: true)?.position.y += 0.01
                                    
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
                            
                                self.displayAllBtns(toAlpha: 0.0)
                               self.displayLbl.text = ""
                                self.confirmOn.alpha = 0
                                self.addingBtn.alpha = 1
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
                            currentMovingNode.opacity = 0.7
                            isMoving = true
                            selected = true
                            movingStatus = .currentMovingChosen
                            print("should have changed  the currentNode")
                            tapGestureRecognizer.isEnabled = false
                            //fade in coordinate buttons
                            
                           displayAllBtns(toAlpha: 0.0)
                          self.displayLbl.text = ""
                            confirmOn.alpha = 0.0

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
        if(touchedNode.name == "bambusBoxIcon"){
            chosenStatus = NodeType.bambooBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "oakBoxIcon"){
            chosenStatus = NodeType.oakFloorBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "rustyBoxIcon"){
            chosenStatus = NodeType.rustyBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        //
        if(touchedNode.name == "rustIronBoxIcon"){
            chosenStatus = NodeType.rustyBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "greasyIronBoxIcon"){
            chosenStatus = NodeType.greesMetalBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "streakIcon"){
            chosenStatus = NodeType.streakMetal
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "rustedIcon"){
            chosenStatus = NodeType.rustIronBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "rockIcon"){
            chosenStatus = NodeType.rockBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "rubberBoxIcon"){
            chosenStatus = NodeType.syntheticRubberBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "plasticIronBoxIcon"){
            chosenStatus = NodeType.plasticPatterBox
            addingState = .addAble
            tapGestureRecognizer.isEnabled = false
            closePanel()
        }
        if(touchedNode.name == "mahagoniIronBoxIcon"){
            chosenStatus = NodeType.mahagoniBox
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
        
        let group = DispatchGroup()
        group.enter()
        DispatchQueue.main.async {
            let plane = OverlayPlane(anchor: anchor as! ARPlaneAnchor)
            self.planes.append(plane)
            node.addChildNode(plane)
            print("node scaleL is \(node.scale.length())")
            print("node scaleX is \(node.scale.x)")
            print("node scaleZ is \(node.scale.z)")
            print("plane scale is \(self.planes.count)")
            self.tapGestureRecognizer.isEnabled = false
            if self.planes.count >= 1{
            self.tapGestureRecognizer.isEnabled = false
                group.leave()
            }
            
        }
        group.notify(queue: .main){
            //cant touch screen yet
            self.tapGestureRecognizer.isEnabled = false
            //displays green confirm image and enables the confirmbutton
            self.camer360Img.image = UIImage(named: "360Green")
            self.confirm360.alpha = 1
            self.displayLbl.text = "Ground is big enough!"
            
        }
        
        
        
    
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

   
    @IBAction func upAction(_ sender: Any) {
        if movingStatus == .currentMovingChosen{
            currentMovingNode.position.y += 0.01
           
        }
       
    }
    @IBAction func rightAction(_ sender: Any) {
        if movingStatus == .currentMovingChosen{

            currentMovingNode.position.x += 0.01
        }
    }
    @IBAction func downAction(_ sender: Any) {
        if movingStatus == .currentMovingChosen{

            currentMovingNode.position.y -= 0.01
            
        }
    }
    @IBAction func leftAction(_ sender: Any) {
        if movingStatus == .currentMovingChosen{

            currentMovingNode.position.x -= 0.01
        }
    }
    @IBAction func outAction(_ sender: Any) {
        if movingStatus == .currentMovingChosen{

            currentMovingNode.position.z -= 0.01
         print("out")
        }
    }
    @IBAction func inAction(_ sender: Any) {
        if movingStatus ==  .currentMovingChosen{

            currentMovingNode.position.z += 0.01
            print("in")
        }
    }

    @IBAction func confirmAction(_ sender: Any) {
      print("confirm")
        confirmOn.alpha = 1
        currentMovingNode.opacity = 1
        movingStatus = .currentMovingNotChosen
        displayAllBtns(toAlpha: 0.0)
        UIView.animate(withDuration: 0.3, animations: {
            self.confirmOn.alpha = 0.0
            self.addingBtn.alpha = 1
            self.createConfirmText()
        }) { (finished) in
        }
        
    }
    @IBAction func copyAction(_ sender: Any) {
        //change status
        movingStatus = .chooseToCopy
        displayLbl.text = "Tap on the ground to place object"
    }
 
    
    
    func createConfirmText(){
        let text = SKLabelNode(text: "DONE!")
        text.fontName = "Avenir Next Bold"
        text.fontSize = 14
        text.position = CGPoint(x: 0, y: -30)
        overlay.addChild(text)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.8)
        text.run(SKAction.sequence([fadeIn, fadeOut]))
    }
    func createCopyText(){
        let text = SKLabelNode(text: "PASTE!")
        text.fontName = "Avenir Next Bold"
        text.fontSize = 14
        text.position = CGPoint(x: 0, y: -30)
        overlay.addChild(text)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.8)
        text.run(SKAction.sequence([fadeIn, fadeOut]))
    }
    func createDeleteText(){
        let text = SKLabelNode(text: "DELETE!")
        text.fontName = "Avenir Next Bold"
        text.fontSize = 14
        text.position = CGPoint(x: 0, y: -30)
        overlay.addChild(text)
        let fadeIn = SKAction.fadeIn(withDuration: 0.2)
        let fadeOut = SKAction.fadeOut(withDuration: 0.8)
        text.run(SKAction.sequence([fadeIn, fadeOut]))
    }
    //All myUIButtons and UIImages
    @IBOutlet var upBtn: UIButton!
    @IBOutlet var rightBtn: UIButton!
    @IBOutlet var downBtn: UIButton!
    @IBOutlet var leftBtn: UIButton!
    @IBOutlet var in1Btn: UIButton!
    @IBOutlet var out1Btn: UIButton!
    @IBOutlet var confirmOn: UIButton!
  
    @IBOutlet var middleRound: UIImageView!
    @IBOutlet var copyBtn: UIButton!
    @IBOutlet var middleSmall: UIImageView!
    @IBOutlet var middleBig: UIImageView!
    @IBOutlet var minusImg: UIImageView!
    @IBOutlet var plusImg: UIImageView!
    @IBOutlet var trashImg: UIImageView!
    @IBOutlet var copyImg: UIImageView!
    @IBOutlet var blurBarImg: UIImageView!
    @IBOutlet var displayLbl: UILabel!
    @IBOutlet var confirm360: UIButton!
    @IBOutlet var camer360Img: UIImageView!
    @IBOutlet var camera360ImgGreen: UIImageView!
    
    @IBOutlet var scanBtn: UIButton!
    //pink panel and items
    @IBOutlet var pinkPanel: UIImageView!
    
    

    func blurrEfect(bg: UIImageView){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = bg.bounds
        //blurView.layer.borderWidth = 1
        blurView.layer.cornerRadius = bg.frame.height / 2
        blurView.clipsToBounds = true
        bg.addSubview(blurView)
    }
    func blurrEfectForPanel(){
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = pinkPanel.bounds
        //blurView.layer.borderWidth = 1
        //blurView.layer.cornerRadius = bg.frame.height / 2
        //blurView.clipsToBounds = true
        pinkPanel.addSubview(blurView)
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
        bambusIcon = SKSpriteNode(imageNamed: "bamboo-wood-semigloss-albedo")
        bambusIcon.name = "bambusBoxIcon"
        bambusIcon.size = CGSize(width: 40, height: 40)
        bambusIcon.zPosition = 100
        bambusIcon.position = CGPoint(x: -50, y: 0)
        panel.addChild(bambusIcon)
        oakIcon = SKSpriteNode(imageNamed: "oakfloor2-albedo")
        oakIcon.name = "oakBoxIcon"
        oakIcon.size = CGSize(width: 40, height: 40)
        oakIcon.zPosition = 100
        oakIcon.position = CGPoint(x: 0, y: 0)
        panel.addChild(oakIcon)
        mahagoni = SKSpriteNode(imageNamed: "mahogfloor_basecolor")
        mahagoni.name = "mahagoniIronBoxIcon"
        mahagoni.size = CGSize(width: 40, height: 40)
        mahagoni.zPosition = 100
        mahagoni.position = CGPoint(x: +50, y: 0)
        panel.addChild(mahagoni)
        rustIronIcon = SKSpriteNode(imageNamed: "metal3")
        rustIronIcon.name = "rustIronBoxIcon"
        rustIronIcon.size = CGSize(width: 40, height: 40)
        rustIronIcon.zPosition = 100
        rustIronIcon.position = CGPoint(x: +100, y: 0)
        panel.addChild(rustIronIcon)
        greasyIronIcon = SKSpriteNode(imageNamed: "greasy-metal-pan1-albedo")
        greasyIronIcon.name = "greasyIronBoxIcon"
        greasyIronIcon.size = CGSize(width: 40, height: 40)
        greasyIronIcon.zPosition = 100
        greasyIronIcon.position = CGPoint(x: -100, y: -50)
        panel.addChild(greasyIronIcon)
        streakMetal = SKSpriteNode(imageNamed: "metal1")
        streakMetal.name = "streakIcon"
        streakMetal.size = CGSize(width: 40, height: 40)
        streakMetal.zPosition = 100
        streakMetal.position = CGPoint(x: -50, y: -50)
        panel.addChild(streakMetal)
        rustedIronIcon = SKSpriteNode(imageNamed: "metal2")
        rustedIronIcon.name = "rustedIcon"
        rustedIronIcon.size = CGSize(width: 40, height: 40)
        rustedIronIcon.zPosition = 100
        rustedIronIcon.position = CGPoint(x: 0, y: -50)
        panel.addChild(rustedIronIcon)
        roockBoxIcon = SKSpriteNode(imageNamed: "holey-rock1-albedo")
        roockBoxIcon.name = "rockIcon"
        roockBoxIcon.size = CGSize(width: 40, height: 40)
        roockBoxIcon.zPosition = 100
        roockBoxIcon.position = CGPoint(x: +50, y: -50)
        panel.addChild(roockBoxIcon)
        rubberIcon = SKSpriteNode(imageNamed: "synth-rubber-albedo")
        rubberIcon.name = "rubberBoxIcon"
        rubberIcon.size = CGSize(width: 40, height: 40)
        rubberIcon.zPosition = 100
        rubberIcon.position = CGPoint(x: +100, y: -50)
        panel.addChild(rubberIcon)
        plasticIcon = SKSpriteNode(imageNamed: "RubberImage")
        plasticIcon.name = "plasticIronBoxIcon"
        plasticIcon.size = CGSize(width: 40, height: 40)
        plasticIcon.zPosition = 100
        plasticIcon.position = CGPoint(x: -100, y: -100)
        panel.addChild(plasticIcon)
        
        

        

        
    }
    
}





