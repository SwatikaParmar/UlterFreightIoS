//
//  DesignableButton.swift
//  SkyApp
//

import UIKit

@available(iOS 13.0, *)
@IBDesignable
class UIButtonX: UIButton {
    
    enum FromDirection:Int {
        case Top = 0
        case Right = 1
        case Bottom = 2
        case Left = 3
    }
    
    var shadowView: UIView!
    var direction: FromDirection = .Left
    var alphaBefore: CGFloat = 1
    
    @IBInspectable var animate: Bool = false
    @IBInspectable var animateDelay: Double = 0.2
    @IBInspectable var animateFrom: Int {
        get {
            return direction.rawValue
        }
        set (directionIndex) {
            direction = FromDirection(rawValue: directionIndex) ?? .Left
        }
    }
    
    @IBInspectable var popIn: Bool = false
    @IBInspectable var popInDelay: Double = 0.4
    
    override func draw(_ rect: CGRect) {
        self.clipsToBounds = true
        
        if animate {
            let originalFrame = frame
            
            if direction == .Bottom {
                frame = CGRect(x: frame.origin.x, y: frame.origin.y + 200, width: frame.width, height: frame.height)
            }
            
            UIView.animate(withDuration: 0.3, delay: animateDelay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.frame = originalFrame
            }, completion: nil)
        }
        
        if popIn {
            transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
            UIView.animate(withDuration: 0.8, delay: popInDelay, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .allowUserInteraction, animations: {
                self.transform = CGAffineTransform.identity
            }, completion: nil)
        }
        
        if shadowView == nil && shadowOpacity > 0 {
            shadowView = UIView(frame: self.frame)
            shadowView.backgroundColor = UIColor.clear
            shadowView.layer.shadowColor = shadowColor.cgColor
            
            let cornerRadius = Utility.DeviceType.IS_IPAD ? cornerRadiusIpad : self.cornerRadius
            
            shadowView.layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius:cornerRadius ).cgPath
            shadowView.layer.shadowOffset = shadowOffset
            shadowView.layer.shadowOpacity = Float(shadowOpacity)
            shadowView.layer.shadowRadius = shadowRadius
            shadowView.layer.masksToBounds = true
            shadowView.clipsToBounds = false
            
            self.superview?.addSubview(shadowView)
            self.superview?.bringSubviewToFront(self)
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        alphaBefore = alpha
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 0.4
        })
        
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        UIView.animate(withDuration: 0.35, animations: {
            self.alpha = self.alphaBefore
        })
    }
    
    // MARK: - Borders
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
          updateCornerRadius()
        }
    }
    
    @IBInspectable var cornerRadiusIpad: CGFloat = 0 {
        didSet {
         updateCornerRadius()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    // MARK: - Shadow
    
    @IBInspectable public var shadowOpacity: CGFloat = 0
    @IBInspectable public var shadowColor: UIColor = UIColor.clear
    @IBInspectable public var shadowRadius: CGFloat = 0
    @IBInspectable public var shadowOffset: CGSize = CGSize(width: 0, height: 0)
    
    func updateCornerRadius(){
        if Utility.DeviceType.IS_IPAD{
            layer.cornerRadius = cornerRadiusIpad
            layer.masksToBounds = cornerRadiusIpad > 0
        }else{
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
   
    @IBInspectable var DynamicFontSize: CGFloat = 0 {
        didSet {
            overrideFontSize(FontSize: DynamicFontSize)
        }
    }
    
    func overrideFontSize(FontSize: CGFloat){
        let fontName = self.titleLabel?.font.fontName
        let screenWidth = UIScreen.main.bounds.size.width
        var calculatedFontSize = screenWidth / 375 * FontSize
        if Utility.shared.DivceTypeString() == "IPad" {
            calculatedFontSize = FontSize + 5
        }
        else{
            calculatedFontSize = FontSize
        }
        self.titleLabel?.font = UIFont(name: fontName ?? "Helvetica", size: calculatedFontSize)
    }
   
}
