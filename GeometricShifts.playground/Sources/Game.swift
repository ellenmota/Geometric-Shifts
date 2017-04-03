import Foundation
import UIKit
import PlaygroundSupport
import SpriteKit


struct PhyscalContact{
    static let None: UInt32 = 0
    static let Player: UInt32 = 0b1 //1
    static let Barrier: UInt32 = 0b10 //2
    static let Bound: UInt32 = 0b100//4
    static let Winner: UInt32 = 0b1000//8
}


public class Game:NSObject, Controls, SKPhysicsContactDelegate{
    
    //View and Scene
    public var scarpzView: SKView?
    public var scene:MyScene?
    
    //Game objects:
    
    //Player
    public let player = Player(image: "square.png")
    public let playerAngel = Player(image: "angel-square.png")
    
    //Game Over
    public var backgroundDefault:SKSpriteNode?
    public var imageGameOver:SKSpriteNode?
    
    //Winner
    public var imageWinner:SKSpriteNode?
    
    //Barrier
    public let barrier1 = Barrier(image: "barrier.png")
    public let barrier2 = Barrier(image: "barrier.png")
    public let barrier3 = Barrier(image: "barrier.png")
    public let barrier4 = Barrier(image: "barrier.png")
    public let Winner = Barrier(image: "barrier.png")
    
    //Controls Buttom
    public let buttomTop:SKSpriteNode = SKSpriteNode(imageNamed:"arrow-top.png")
    public let buttomBottom:SKSpriteNode = SKSpriteNode(imageNamed:"arrow-bottom.png")
    public let buttomLeft:SKSpriteNode = SKSpriteNode(imageNamed:"arrow-left.png")
    public let buttomRight:SKSpriteNode = SKSpriteNode(imageNamed:"arrow-rigth.png")
    var action:SKAction?
    
    //Contact Collision and Controller
    var lastContactNode: SKNode?
    private var controller:MyController = MyController()
    
    
    override public init(){
        
        super.init()
        self.controller.delegate = self
        self.scarpzView = SKView(frame: CGRect(x:0, y:0, width: 300, height: 600))
        self.scene = MyScene(size: CGSize(width: 300, height: 600))

        //View Game Over
        self.backgroundDefault = SKSpriteNode(imageNamed: "background.jpg")
        self.imageGameOver = SKSpriteNode(imageNamed: "game-over.png")
        self.backgroundDefault?.position = CGPoint(x: 150, y: 300)
        self.backgroundDefault?.zPosition = 1
        self.backgroundDefault?.scale(to: CGSize(width:300, height:600))
        self.backgroundDefault?.isHidden = true
        self.scene?.addChild(backgroundDefault!)
        
        //WINNER
        self.imageWinner = SKSpriteNode(imageNamed: "Winner.png")
        
        //Image GameOver Game Over
        self.imageGameOver?.position = CGPoint(x: 150, y: 300)
        self.imageGameOver?.zPosition = 1
        self.imageGameOver?.scale(to: CGSize(width:200, height:100))
        self.imageGameOver?.isHidden = true
        self.scene?.addChild(imageGameOver!)
        
        
        //Image Winner
        self.imageWinner?.position = CGPoint(x: 150, y: 300)
        self.imageWinner?.zPosition = 1
        self.imageWinner?.scale(to: CGSize(width:250, height:125))
        self.imageWinner?.isHidden = true
        self.scene?.addChild(imageWinner!)
        
        //Player size
        self.player.scale(to: CGSize(width:40, height:40))
        self.playerAngel.scale(to: CGSize(width:60, height:60))
        self.playerAngel.alpha = 0.5
        self.playerAngel.isHidden = true
        self.player.addChild(playerAngel)
        

        self.scene?.controlDelegate = self
       
    
        
        //Control Buttons
        
        //TOP BUTTON
        self.buttomTop.position = CGPoint(x: 140, y: 130)
        self.buttomTop.name = "top"
        self.buttomTop.scale(to: CGSize(width:60, height:40))
        self.scene?.addChild(buttomTop)
        
        //BOTTOM BUTTON
        self.buttomBottom.position = CGPoint(x: 140, y: 50)
        self.buttomBottom.name = "bottom"
        self.buttomBottom.scale(to: CGSize(width:60, height:40))
        self.scene?.addChild(buttomBottom)

        
        //LEFT BUTTON
        self.buttomLeft.position = CGPoint(x: 70, y: 85)
        self.buttomLeft.name = "left"
        self.buttomLeft.scale(to: CGSize(width:60, height:40))
        self.scene?.addChild(buttomLeft)
        
        
        //RIGHT BUTTON
        self.buttomRight.position = CGPoint(x: 205, y: 85)
        self.buttomRight.name = "right"
        self.buttomRight.scale(to: CGSize(width:60, height:40))
        self.scene?.addChild(buttomRight)
    
        
        //BARRIER SIZE
        self.barrier1.scale(to: CGSize(width:513, height:80))
        self.barrier2.scale(to: CGSize(width:160, height:150))
        self.barrier3.scale(to: CGSize(width:190, height:200))
        self.barrier4.scale(to: CGSize(width:260, height:80))
        
        //WINNER SIZE
        self.Winner.scale(to: CGSize(width:100, height:10))
        self.Winner.isHidden = true
        
        //BARRIER POSITIONS
        self.barrier1.position = CGPoint(x: -20, y: 200)
        self.scene?.addChild(barrier1)
        
        self.barrier2.position = CGPoint(x: 230, y: 380)
        self.scene?.addChild(barrier2)
        
        self.barrier3.position = CGPoint(x: 5, y: 380)
        self.scene?.addChild(barrier3)
        
        self.barrier4.position = CGPoint(x: 190, y: 580)
        self.scene?.addChild(barrier4)
        
        //WINNER POSITION
        self.Winner.position = CGPoint(x: 10, y: 600)
        self.scene?.addChild(Winner)
        
        //PLAYER POSITION
        self.player.position = CGPoint(x: 270, y: 200)
        self.player.name = "player"
        self.scene?.addChild(player)
        
       
        
       
        
        /******************* Collisions ********************/
        
        self.scene?.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        
        self.player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        
        self.scene?.physicsWorld.contactDelegate = self
        
        
        
        //Player
        if let physicsPlayer = self.player.physicsBody {
            physicsPlayer.affectedByGravity = true
            physicsPlayer.allowsRotation = true
            physicsPlayer.isDynamic = true
            physicsPlayer.categoryBitMask = PhyscalContact.Player
            physicsPlayer.collisionBitMask = PhyscalContact.Barrier | PhyscalContact.Bound
            
        }
        
        
        //Bound
        self.scene?.physicsBody = SKPhysicsBody(edgeLoopFrom: scarpzView!.frame)
        if let physicsBound = self.scene?.physicsBody {
            physicsBound.affectedByGravity = false
            physicsBound.allowsRotation = false
            physicsBound.isDynamic = false
            physicsBound.categoryBitMask = PhyscalContact.Bound
            physicsBound.collisionBitMask = 0
            physicsBound.contactTestBitMask = PhyscalContact.Player
            
        }
        
        //Barrier
        self.barrier1.physicsBody = SKPhysicsBody(rectangleOf: self.barrier1.size)
        if let physicsBarrier1 = self.barrier1.physicsBody {
            physicsBarrier1.affectedByGravity = false
            physicsBarrier1.allowsRotation = false
            physicsBarrier1.isDynamic = false
            physicsBarrier1.categoryBitMask = PhyscalContact.Barrier
            physicsBarrier1.collisionBitMask = 0
            physicsBarrier1.contactTestBitMask = PhyscalContact.Player
            
        }
        
        self.barrier2.physicsBody = SKPhysicsBody(rectangleOf: self.barrier2.size)
        if let physicsBarrier2 = self.barrier2.physicsBody {
            physicsBarrier2.affectedByGravity = false
            physicsBarrier2.allowsRotation = false
            physicsBarrier2.isDynamic = false
            physicsBarrier2.categoryBitMask = PhyscalContact.Barrier
            physicsBarrier2.collisionBitMask = 0
            physicsBarrier2.contactTestBitMask = PhyscalContact.Player
        }
        
        self.barrier3.physicsBody = SKPhysicsBody(rectangleOf: self.barrier3.size)
        if let physicsBarrier3 = self.barrier3.physicsBody {
            physicsBarrier3.affectedByGravity = false
            physicsBarrier3.allowsRotation = false
            physicsBarrier3.isDynamic = false
            physicsBarrier3.categoryBitMask = PhyscalContact.Barrier
            physicsBarrier3.collisionBitMask = 0
            physicsBarrier3.contactTestBitMask = PhyscalContact.Player
        }
        
        
        self.barrier4.physicsBody = SKPhysicsBody(rectangleOf: self.barrier4.size)
        if let physicsBarrier4 = self.barrier4.physicsBody {
            physicsBarrier4.affectedByGravity = false
            physicsBarrier4.allowsRotation = false
            physicsBarrier4.isDynamic = false
            physicsBarrier4.categoryBitMask = PhyscalContact.Barrier
            physicsBarrier4.collisionBitMask = 0
            physicsBarrier4.contactTestBitMask = PhyscalContact.Player
        }
        
        //WINNER
        self.Winner.physicsBody = SKPhysicsBody(rectangleOf: self.Winner.size)
        if let physicsWinner = self.Winner.physicsBody {
            physicsWinner.affectedByGravity = false
            physicsWinner.allowsRotation = false
            physicsWinner.isDynamic = false
            physicsWinner.categoryBitMask = PhyscalContact.Winner
            physicsWinner.collisionBitMask = 0
            physicsWinner.contactTestBitMask = PhyscalContact.Player
        }
        
        
        
        let point = CGPoint(x: 125, y: 102)
        self.scene?.sceneTouched(point, player)
        
        
        //SCENE
        PlaygroundPage.current.liveView = self.scarpzView
        self.scarpzView?.presentScene(self.scene)
        
        PlaygroundPage.current.needsIndefiniteExecution = true
        self.scarpzView?.showsPhysics = false
    }
    
    
    //Functions for player movement
    
    ///Movement Right
    public func moveToRight() {
        let positionXPlayer = getPlayerPosition().x
        
        self.action = SKAction.moveTo(x: positionXPlayer + 10, duration: 0.1)
        
        self.player.run(self.action!)
       
    }
    
    ///Movement  Left
    public func moveToLeft() {
        
        let positionXPlayer = getPlayerPosition().x
        
        self.action = SKAction.moveTo(x: positionXPlayer - 10, duration: 0.1)
        
        self.player.run(self.action!)
    }
    
   ///Movement Top
    public func moveToTop() {
        
        let positionXPlayer = getPlayerPosition().y
        
        self.action = SKAction.moveTo(y: positionXPlayer + 10, duration: 0.1)
        
        self.player.run(self.action!)
    }
    
    
    ///Movement Bottom
    public func moveToBottom() {
        
        let positionXPlayer = getPlayerPosition().y
        
        self.action = SKAction.moveTo(y: positionXPlayer - 10, duration: 0.1)
        
        self.player.run(self.action!)
        
    }
    
    //Get position player
    public func getPlayerPosition() -> CGPoint {
        return self.player.position
    }
    
    
    /// First collision
    ///
    /// - Parameter contact: Contact with something physical
    public func didBegin(_ contact: SKPhysicsContact)
    {
    
        ///Contact on the top of the screen
        let collisionWinner = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collisionWinner == PhyscalContact.Player | PhyscalContact.Winner
        {
            let showWinnerBackground = SKAction.run({
                self.backgroundDefault!.isHidden = false
            })
            
            let showWinnerGame = SKAction.run({
                self.imageWinner!.isHidden = false
            })
            
            let showSequenceWinner = SKAction.sequence([showWinnerBackground, showWinnerGame])
            
            self.backgroundDefault!.run(showSequenceWinner)
        }
        
        
        ///Contact with some barrier
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
    
        if collision == PhyscalContact.Player | PhyscalContact.Barrier
        {
           
            
            let angelAppear = SKAction.run({ 
                self.playerAngel.isHidden = false
            })
            
            let showGameOver = SKAction.run({
                self.backgroundDefault!.isHidden = false
            })
            
            let showImageGameOver = SKAction.run({
                self.imageGameOver!.isHidden = false
            })
            
            let angelMove = SKAction.moveBy(x: self.playerAngel.position.x, y: self.playerAngel.position.y+600, duration: 2.5)
            
            let fadeOut = SKAction.fadeOut(withDuration: 1)
            let fadeInGameOver = SKAction.fadeIn(withDuration: 1)
            let fadeInImageGameOver = SKAction.fadeIn(withDuration: 1)
            
            let remove = SKAction.removeFromParent()
            
            let showSequenceGameOver = SKAction.sequence([fadeInGameOver,showGameOver, fadeInImageGameOver, showImageGameOver])
            
            let killAngelSequence = SKAction.sequence([angelAppear, angelMove,fadeOut,remove])
            
            let killSequence = SKAction.sequence([fadeOut,remove])
            
            
            self.playerAngel.run(killAngelSequence)
            self.player.run(killSequence)
            self.backgroundDefault!.run(showSequenceGameOver)
            
            
        }
    }
  
    
}
