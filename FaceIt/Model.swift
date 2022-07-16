import Foundation

struct FacialExpression {
    enum Eyes: Int {
        case Open
        case Closed
    }
    
    enum Mouth: Int {
        case Frown
        case Smirk
        case Neutral
        case Grin
        case Smile
        func sadderMouth () -> Mouth {
            return Mouth(rawValue: rawValue - 1) ?? .Frown
        }
        func happierMouth () -> Mouth {
            return Mouth(rawValue: rawValue + 1) ?? .Smile
        }
    }
    var eyes: Eyes
    var mouth: Mouth
}
