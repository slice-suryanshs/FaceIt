import UIKit

class EmotionsViewController: UIViewController {
    
    private let emotionalFaces: [String:FacialExpression] = [
        "Angry": FacialExpression(eyes: .Closed, mouth: .Frown),
        "Happy": FacialExpression(eyes: .Open, mouth: .Smile),
        "Worried": FacialExpression(eyes: .Open, mouth: .Smirk),
        "Mischievious": FacialExpression(eyes: .Open, mouth: .Grin)
    ]
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationvc = segue.destination
        if let navcon = destinationvc as? UINavigationController {
            destinationvc = navcon.visibleViewController ?? destinationvc
        }
        if let facevc = destinationvc as? FaceViewController {
            if let identifier = segue.identifier {
                if let expression = emotionalFaces[identifier] {
                    facevc.expression = expression
                    if let sendingButton = sender as? UIButton {
                        facevc.navigationItem.title = sendingButton.titleLabel!.text!
                    }
                }
            }
        }
    }
}
