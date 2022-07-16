import UIKit

@IBDesignable
class FaceView: UIView {
    
    @IBInspectable
    var scale: CGFloat = 0.90 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var mouthCurvature: Double = -1 { didSet { setNeedsDisplay() } }
    @IBInspectable
    var eyesOpen: Bool = false { didSet { setNeedsDisplay() } }
    @IBInspectable
    var color: UIColor = UIColor.blue { didSet { setNeedsDisplay() } }
    @IBInspectable
    var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
    
    private var skullRadius: CGFloat {
        get {
            return min(bounds.size.width,bounds.size.height)/2 * scale
        }
    }
    
    private var skullCenter: CGPoint {
        get {
            return CGPoint(x: bounds.midX, y: bounds.midY)
        }
    }
    
    private struct Ratios {
        static let SRTEO: CGFloat = 3
        static let SRTER: CGFloat = 10
        static let SRTMW: CGFloat = 1
        static let SRTMH: CGFloat = 3
        static let SRTMO: CGFloat = 3
    }
    
    private enum Eye {
        case Left
        case Right
    }
    
    private func drawCircle (midPoint: CGPoint, withRadius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath(arcCenter: midPoint, radius: withRadius, startAngle: 0.0, endAngle: CGFloat(2*Double.pi), clockwise: true)
        path.lineWidth = lineWidth
        return path
    }
    
    private func getEyeCenter (_ eye: Eye) -> CGPoint {
        let eyeoffset = skullRadius/Ratios.SRTEO
        var eyecenter = skullCenter
        eyecenter.y -= eyeoffset
        switch eye {
        case .Left: eyecenter.x -= eyeoffset
        case .Right: eyecenter.x += eyeoffset
        }
        return eyecenter
    }
    
    private func pathForEye (eye: Eye) -> UIBezierPath {
        let eyeradius = skullRadius/Ratios.SRTER
        let eyecenter = getEyeCenter(eye)
        if eyesOpen {
            return drawCircle(midPoint: eyecenter, withRadius: eyeradius)
        }
        else {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: eyecenter.x-eyeradius, y: eyecenter.y))
            path.addLine(to: CGPoint(x: eyecenter.x+eyeradius, y: eyecenter.y))
            path.lineWidth = lineWidth
            return path
        }
    }
    
    private func pathForMouth () -> UIBezierPath {
        let mouthWidth = skullRadius/Ratios.SRTMW
        let mouthHeight = skullRadius/Ratios.SRTMH
        let mouthOffset = skullRadius/Ratios.SRTMO
        let mouthRect = CGRect(x: skullCenter.x-mouthWidth/2, y: skullCenter.y+mouthOffset, width: mouthWidth, height: mouthHeight)
        let smileOffset = CGFloat(max(-1,min(1,mouthCurvature))) * mouthRect.height
        let start = CGPoint(x: mouthRect.minX, y: mouthRect.minY)
        let end = CGPoint(x: mouthRect.maxX, y: mouthRect.minY)
        let cp1 = CGPoint(x: mouthRect.minX+mouthRect.width/3, y: mouthRect.minY+smileOffset)
        let cp2 = CGPoint(x: mouthRect.maxX-mouthRect.width/3, y: mouthRect.minY+smileOffset)
        let path = UIBezierPath()
        path.move(to: start)
        path.addCurve(to: end, controlPoint1: cp1, controlPoint2: cp2)
        path.lineWidth = lineWidth
        return path
    }
    
    override func draw(_ rect: CGRect) {
        let skull = drawCircle(midPoint: skullCenter, withRadius: skullRadius)
        color.set()
        skull.stroke()
        pathForEye(eye: Eye.Right).stroke()
        pathForEye(eye: Eye.Left).stroke()
        pathForMouth().stroke()
    }
}
