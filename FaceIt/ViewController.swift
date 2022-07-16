import UIKit

class FaceViewController: UIViewController {
    
    var expression = FacialExpression(eyes: .Closed, mouth: .Frown) {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var faceView: FaceView! {
        didSet {
            faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(changeScale(recognizer:))))
            let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
            swipeDown.direction = .down
            faceView.addGestureRecognizer(swipeDown)
            let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
            swipeUp.direction = .up
            faceView.addGestureRecognizer(swipeUp)
            updateUI()
        }
    }
    
    @IBAction func toggle(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            switch expression.eyes {
            case .Open: expression.eyes = .Closed
            case .Closed: expression.eyes = .Open
            }
        }
    }
    
    @objc private func increaseHappiness () {
        expression.mouth = expression.mouth.happierMouth()
    }
    
    @objc private func decreaseHappiness () {
        expression.mouth = expression.mouth.sadderMouth()
    }
    
    @objc private func changeScale (recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .ended,.changed:
            faceView.scale *= recognizer.scale
            recognizer.scale = 1.0
        default: break
        }
    }
    
    private var mouthCurvatures: [FacialExpression.Mouth:Double] = [.Smile: 1, .Frown: -1, .Grin: 0.5, .Neutral: 0, .Smirk: -0.5]
    
    private func updateUI () {
        if faceView != nil {
            switch expression.eyes {
            case .Open: faceView.eyesOpen = true
            case .Closed: faceView.eyesOpen = false
            }
            faceView.mouthCurvature = mouthCurvatures[expression.mouth] ?? 0.0
        }
    }
}
