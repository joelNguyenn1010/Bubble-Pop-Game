//
//  GameViewController.swift
//  bublePop
//
//  Created by Nguyễn Ngọc Anh on 24/4/18.
//  Copyright © 2018 Nguyễn Ngọc Anh. All rights reserved.
//
import Firebase
import UIKit
import SceneKit
import AVFoundation
class GamePlayView: UIViewController {
    var audioPlayer: AVAudioPlayer!
    var numberOfBubble: Float = 15
    var count: Int = 5
    var timer: Timer?
    var sceneView: SCNView!
    var sceneScene: SCNScene!
    var cameraNode: SCNNode!
    var spawnTime: TimeInterval = 0
    var scores: Double = 0
    var scoreLabel: UILabel!
    var timeLabel: UILabel!
    var scoreForBoom: Double = -10
    var scoreForGreen: Double = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        count = Int(Setting.playTime)
        setupView()
        setupScene()
        setupCamera()
        spawnBubbles()
        createLabel()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(Countdown), userInfo: nil, repeats: true)
        Countdown()
    }

    func createLabel() { //creating label for score, time
        
        scoreLabel = UILabel(frame: CGRect(x: 535, y: 0, width: 150, height: 30))
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.text = "Score: 0"
        scoreLabel.font = UIFont.init(name: "Marker Felt", size: 18.0)?.with(traits: .traitBold)
        self.view.addSubview(scoreLabel)
        scoreLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        scoreLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        timeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.text = "60"
        timeLabel.font = UIFont.init(name: "Marker Felt", size: 18.0)?.with(traits: .traitBold)
        self.view.addSubview(timeLabel)
        timeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 25).isActive = true
        timeLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    func setupHighScore(){
        let defaults = UserDefaults.standard
        var highscore =  Int()
        highscore = defaults.integer(forKey: "highscore")
        if Int(scores) > highscore {
            defaults.set(scores, forKey: "highscore")
        }

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        playerScore()
        setupHighScore()
        self.timer?.invalidate()
        self.timer = nil
        scores = 0
    }
    @objc func Countdown() {
        count = count - 1
        if count > 0 {
            timeLabel.text = "\(count)"
        }
        if count == 0 {
            playerScore()
            performSegue(withIdentifier: "endGame", sender: nil)
        }
    }
 
    override var prefersStatusBarHidden: Bool {//hide status bar
        return true
    }
    
    func playAudio(bubble: Double){
        if bubble == scoreForGreen {
        let soundURL = Bundle.main.url(forResource: "pop", withExtension: "mp3")
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
        }
        catch {
            print(error)
        }
        }
        else{
            let soundURL = Bundle.main.url(forResource: "boom", withExtension: "mp3")
            do{
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL!)
            }
            catch {
                print(error)
            }
        }
        audioPlayer.play()
    }
    func playerScore() {
        let playerStorage = PlayerManament()
        let thePlayer = Player()
        thePlayer.playerScore = Int(scores)
        do {
        try playerStorage.saveData(thePlayer: thePlayer)
        }
        catch {
            print(error)
        }
        setupHighScore()
    }
    func setupView() {
        sceneView = self.view as! SCNView
        sceneView.allowsCameraControl = false //do not allow user to rotate to some where else
        sceneView.delegate = self
        sceneView.isPlaying = true
    }
    
    func setupScene() {
        sceneScene = SCNScene() //load scene
        sceneView.scene = sceneScene //load scene
        sceneScene.background.contents = "background.scnassets/background.png" //apply background
    }
    func setupCamera() {
        let screenHeight = self.view.frame.height//apply camera constraint to every devices
        let cameraPosition = Float(screenHeight)*(0.01) //let camera position in front of the screen
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: Float(cameraPosition), z: 15)
        sceneScene.rootNode.addChildNode(cameraNode)
    }
    
    func updateScore(_ scoreForBubble: Double) {
        scores += scoreForBubble
        scoreLabel.text = "Score: \(Int(scores))"
        playAudio(bubble: scoreForBubble)
    }
    
    
    func scoreBubble(node: SCNNode) {
        if node.name == "green" {
                updateScore(scoreForGreen)
                node.removeFromParentNode()
        }
        if node.name == "boom" {
            updateScore(scoreForBoom)
            node.removeFromParentNode()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {//create touch to bubble geometry
        let bubbleTouched = touches.first!
        let location = bubbleTouched.location(in: sceneView)
        let hitResults = sceneView.hitTest(location, options: nil)
        if let result = hitResults.first {
            scoreBubble(node: result.node)
        }
    }
    
    func spawnBubbles() {//create Bubble
        var bubble: SCNGeometry//assign bubble to Geometry
        bubble = SCNSphere(radius: 1)// assign bubble to Shphere Geometry
        let bubbleNode = SCNNode(geometry: bubble)
        sceneScene.rootNode.addChildNode(bubbleNode)
        
        bubbleNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)//apply physic so they can be fall down by gravity
        let randomForX = Float.random(min: -4, max: 4)
        let force = SCNVector3(x: randomForX, y: 16, z: 0)
        let position = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
        bubbleNode.physicsBody?.applyForce(force, at: position, asImpulse: true)//apply force to push bubble
        let bubbleColor = UIColor.random()
        bubble.materials.first?.diffuse.contents = bubbleColor

        if bubbleColor == UIColor.green {//assign bubbleNode name to green if the bubble is green
            bubbleNode.name = "green"
        }
        else if bubbleColor == UIColor.boom {//assign bubbleNode name to pink if the bubble is pink
            bubbleNode.name = "boom"
        }
    }

    func cleanBubbleOutSideOfBound() {//Delete bubbles outside of the scene
        for bubbleNodes in sceneScene.rootNode.childNodes {
            if bubbleNodes.presentation.position.y < -3 {
                bubbleNodes.removeFromParentNode()
            }
        }
    }
}
extension GamePlayView: SCNSceneRendererDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if time > spawnTime {
            spawnBubbles()
            spawnTime = time + TimeInterval(0.3)
        }
        cleanBubbleOutSideOfBound()
    }
}
//https://stackoverflow.com/questions/4713236/how-do-i-set-bold-and-italic-on-uilabel-of-iphone-ipad/21777132#21777132
    extension UIFont {
        var bold: UIFont {
            return with(traits: .traitBold)
        } // bold
        
        var italic: UIFont {
            return with(traits: .traitItalic)
        } // italic
        
        var boldItalic: UIFont {
            return with(traits: [.traitBold, .traitItalic])
        } // boldItalic
        
        
        func with(traits: UIFontDescriptorSymbolicTraits) -> UIFont {
            guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
                return self
            } // guard
            
            return UIFont(descriptor: descriptor, size: 0)
        } // with(traits:)
}
