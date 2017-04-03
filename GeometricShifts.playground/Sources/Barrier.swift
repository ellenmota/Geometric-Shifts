import Foundation
import SpriteKit

public class Barrier: SKSpriteNode{
    
    var length:CGFloat = 0.0
    
    public convenience init(image: String) {
        self.init(imageNamed: image)
    }
}
