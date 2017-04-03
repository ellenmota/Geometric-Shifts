import Foundation
import SpriteKit

public class MyScene:SKScene {
    
    public var lastTouchLocation:CGPoint?
    public weak var controlDelegate:Controls?
    
    
    /// Controlar Toques na tela
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
        let touchLocation = touch.location(in: self)
        
        let touchedNodes = self.nodes(at: touchLocation)
        
        guard touchedNodes.count > 0 else {
            return
        }
        
        //By clicking the up arrow
        if(touchedNodes[0].name == "top"){
            controlDelegate?.moveToTop()
        }
        
        //By clicking the down arrow
        if(touchedNodes[0].name == "bottom"){
            controlDelegate?.moveToBottom()
        }
        
        //By clicking the right arrow
        if(touchedNodes[0].name == "right"){
            controlDelegate?.moveToRight()
        }
        
        //By clicking the left arrow
        if(touchedNodes[0].name == "left"){
            controlDelegate?.moveToLeft()
        }
    
    
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{
            return
        }
    }
    
    public func sceneTouched(_ touchLocation:CGPoint, _ player: Player) {
        lastTouchLocation = touchLocation

    }

    
}
