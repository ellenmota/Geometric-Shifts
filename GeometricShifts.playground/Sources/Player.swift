import Foundation

import SpriteKit

public class Player:SKSpriteNode{
    
    public var length:CGFloat = 0.0
    
    ///Receive picture of player Josh
    public convenience init(image: String) {
        self.init(imageNamed: image)
    }


}
