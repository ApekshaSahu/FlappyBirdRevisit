//
//  GameScene.swift
//  FlappyBirdRevisit
//
//  Created by Apeksha Sahu on 8/6/18.
//  Copyright © 2018 Apeksha Sahu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
  
    var score = 0
    var scoreLabel = SKLabelNode()
    var gameoverLabel = SKLabelNode()
    var bird = SKSpriteNode()
   var bg = SKSpriteNode()
    var pipe1 = SKSpriteNode()
    var pipe2 = SKSpriteNode()
    var i : CGFloat = 0
    var gameOver:Bool = false
    var movingObjects = SKSpriteNode()
    var labelContainer = SKLabelNode()
    enum ColliderType: UInt32 {
        case Bird = 1
        case Object = 2
        case Gap = 4
    }
  
    func makeBG() {
        
        let bgTexture = SKTexture(imageNamed: "bg.png")
        bg = SKSpriteNode(texture: bgTexture)
        //bg.zPosition = -2
        
        
        let movebg = SKAction.moveBy(x: -bgTexture.size().width, y: 0, duration: 9)
        let replacebg = SKAction.moveBy(x: bgTexture.size().width, y: 0, duration: 0)
        let movebgforever = SKAction.repeatForever(SKAction.sequence([movebg,replacebg]))
        
        while i < 3  {
            
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width/4 + bgTexture.size().width * i, y: frame.midY)
            bg.size.height = self.frame.height
            
            bg.run(movebgforever)
            movingObjects.addChild(bg)
            i = i + 1
        }
    }
    
    
    override func sceneDidLoad() {
        self.physicsWorld.contactDelegate = self
        self.addChild(movingObjects)
        
       makeBG()
        
        scoreLabel.fontName = "Helvetica"
        scoreLabel.fontSize = 60
        scoreLabel.text = "\(score)"
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.maxY - 100)
        labelContainer.addChild(scoreLabel)
        
        let birdTexture1 = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animate(with: [birdTexture1,birdTexture2], timePerFrame: 0.2)
        let makeBirdFlap = SKAction.repeatForever(animation)
        bird = SKSpriteNode(texture: birdTexture1)
        
        bird.position = CGPoint(x: frame.midX, y: frame.midY)
        bird.run(makeBirdFlap)
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture1.size().height/2)
        bird.physicsBody?.affectedByGravity = true
        bird.physicsBody?.isDynamic = true
        
        bird.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        bird.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        
    
       
        self.addChild(bird)
        
        let ground = SKNode()
        ground.position = CGPoint(x: frame.minX, y: frame.minY + 200)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 50))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        ground.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        self.addChild(ground)
        
        
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: (#selector(GameScene.makePipes)), userInfo: nil, repeats: true)
       
    }
    
    @objc func makePipes() {
        let gapheight = bird.size.height * 4
        let moveAmount = arc4random() % UInt32(frame.size.height / 2)
        let pipeoffset = CGFloat(moveAmount) - frame.size.height / 4
        let movePipes = SKAction.moveBy(x: self.frame.size.width * 2, y: 0, duration: TimeInterval(self.size.width / 100))
        
        let removePipes = SKAction.removeFromParent()
        let moveAndRemovePipes = SKAction.sequence([movePipes,removePipes])
        
       
        
        let pip1Texture = SKTexture(imageNamed: "pipes1.png")
        let pipe2Texture = SKTexture(imageNamed: "pipes2.png")
        pipe1 = SKSpriteNode(texture: pip1Texture)
        pipe2 = SKSpriteNode(texture: pipe2Texture)
        //pipe1.size = CGSize(width: 100, height: 200)
        //pipe2.size = CGSize(width: 100, height: 200)
        pipe1.position = CGPoint(x: frame.midX, y: frame.midY + pip1Texture.size().height / 2 + gapheight / 2 + pipeoffset)
        pipe1.run(moveAndRemovePipes)
        pipe1.physicsBody = SKPhysicsBody(rectangleOf: pip1Texture.size())
        
        pipe1.physicsBody?.isDynamic = false
        pipe1.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        pipe1.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
      //  pipe1.physicsBody?.affectedByGravity = false
        
          movingObjects.addChild(pipe1)
        
       
        pipe2.position = CGPoint(x: frame.midX, y: frame.midY - pipe2Texture.size().height / 2 - gapheight / 2 + pipeoffset)
        pipe2.run(moveAndRemovePipes)
        pipe2.physicsBody = SKPhysicsBody(rectangleOf: pipe2Texture.size())
        pipe2.physicsBody?.isDynamic = false
        pipe2.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        pipe2.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
       // pipe2.physicsBody?.affectedByGravity = false
      
        movingObjects.addChild(pipe2)
        
        let gaps = SKNode()
        gaps.position = CGPoint(x: frame.midX, y: frame.midY + pipeoffset)
        gaps.run(moveAndRemovePipes)
        gaps.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.pipe1.size.width, height: gapheight))
        gaps.physicsBody?.isDynamic = false
        gaps.physicsBody?.categoryBitMask = ColliderType.Gap.rawValue
        gaps.physicsBody?.contactTestBitMask = ColliderType.Bird.rawValue
        gaps.physicsBody?.collisionBitMask = ColliderType.Gap.rawValue
        movingObjects.addChild(gaps)
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
       
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == ColliderType.Gap.rawValue || contact.bodyB.categoryBitMask == ColliderType.Gap.rawValue {
            score = score + 1
            scoreLabel.text = "\(score)"
           print(score)
        }else {
            if gameOver == false {
        print("we contacted")
        gameOver = true
        self.speed = 0
            gameoverLabel.fontName = "Helvetica"
            gameoverLabel.fontSize = 100
            gameoverLabel.text = "Game Over"
            gameoverLabel.zPosition = 2
            gameoverLabel.position = CGPoint(x: frame.midX, y: frame.maxY)
            labelContainer.addChild(gameoverLabel)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOver == false {
     bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
    bird.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
            
        }else {
            
            score = 0
            scoreLabel.text = "0"
            bird.position = CGPoint(x: frame.midX, y: frame.minY)
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            movingObjects.removeAllChildren()
            
            makeBG()
            self.speed = 1
            gameOver = false
            labelContainer.removeAllChildren()
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
       
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
    }
}
