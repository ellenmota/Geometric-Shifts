import Foundation
import UIKit
import SpriteKit

public protocol Controls: NSObjectProtocol{

    func moveToRight()
    
    func moveToLeft()
    
    func moveToTop()
    
    func moveToBottom()
}

public class MyController:UIViewController {
    
    public weak var delegate:Controls?
    
    @objc
    
    /// Control the movement to the right

    public func clickOnMoveToRight (target:SKSpriteNode){
        delegate?.moveToRight()
    }
    
    @objc
    /// Control the movement to the left
    public func clickOnMoveToLeft (){
        delegate?.moveToRight()
    }
    
    @objc
    /// Control the movement to the top
    public func clickOnMoveToTop (){
        delegate?.moveToTop()
    }
    
    @objc
     /// Control the movement to the bottom
    public func clickOnMoveToBottom (){
        delegate?.moveToBottom()
    }
}
