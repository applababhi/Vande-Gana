//
//  Extensions.swift
//  Base App
//
//  Created by Shalini Sharma on 9/10/18.
//  Copyright © 2018 Shalini Sharma. All rights reserved.
//

import UIKit
import Foundation
import NVActivityIndicatorView
import SDWebImage
import CommonCrypto
import AVKit

// check if string is a number
extension String  {
    var isNumber: Bool {
        return !isEmpty && rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
}

//MARK: //////    Device Check ////////
extension UIViewController
{
    func getDeviceModel() -> String
    {
        var model = ""
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                print("iPhone 5 or 5S or 5C")
                model = "iPhone 5"
            case 1334:
                print("iPhone 6/6S/7/8")
                model = "iPhone 6"
            case 1920, 2208:
                print("iPhone 6+/6S+/7+/8+")
                model = "iPhone 6+"
            case 2436:
                print("iPhone X, XS")
                model = "iPhone XS"
            case 2688:
                print("iPhone XS Max")
                model = "iPhone Max"
            case 1792:
                print("*******************  ************")
                print("its iPhone XR but frames set of MAX")
                print("*******************  ************")
               // model = "iPhone XR"
                model = "iPhone Max"
            default:
                print("Unknown")
                model = "Unknown"
            }
        }
        return model
    }
}

//MARK: //////    Add Shadow to UIView  ////////
extension UIView {
    
    func dropShadow() {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.6
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 3
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

//MARK: //////    UIViewcontroller  ////////
extension UIViewController {
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func showAlertWithTitle(title:String, message:String, okButton:String, cancelButton:String, okSelectorName:Selector?)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if okSelectorName != nil
        {
            let OKAction = UIAlertAction(title: okButton, style: .default) { (action:UIAlertAction!) in
                self.perform(okSelectorName)
            }
            alertController.addAction(OKAction)
        }
        else
        {
            let OKAction = UIAlertAction(title: okButton, style: .default, handler: nil)
            alertController.addAction(OKAction)
        }
        
        if cancelButton != ""
        {
            let cancleAction = UIAlertAction(title: cancelButton, style: .destructive) { (action:UIAlertAction!) in
                print("cancel")
            }
            alertController.addAction(cancleAction)
        }
        
        self.present(alertController, animated: true, completion:nil)
    }
    
    func setViewBackgroundImage(name:String) {
        let backgroundImgView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImgView.image = UIImage(named: name)
        self.view.insertSubview(backgroundImgView, at: 0)
    }
    
    func addLeftPaddingTo(TextField:UITextField)
    {
        let viewT = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        viewT.backgroundColor = .clear
        
        TextField.leftViewMode = UITextField.ViewMode.always
//        let imageView = UIImageView(frame: CGRect(x: 3, y: 4, width: 20, height: 20))
//        let image = UIImage(named: "search")
//        imageView.image = image
//        viewT.addSubview(imageView)
        TextField.leftView = viewT
    }
    
    func addRightPaddingTo(TextField:UITextField, imageName:String)
    {
        let viewT = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        viewT.backgroundColor = .clear
        
        TextField.rightViewMode = UITextField.ViewMode.always
        
        if imageName != ""
        {
            let imageView = UIImageView(frame: CGRect(x: 0, y: 3, width: 15, height: 15))
            imageView.contentMode = .center
            imageView.clipsToBounds = true
            let image = UIImage(named: imageName)
            imageView.image = image
            viewT.addSubview(imageView)
        }
        
        TextField.rightView = viewT
    }
    
    func setHeaderGradient(viewBack:UIView){
        let fistColor = UIColor(named: "App_DarkBlack")!
        let lastColor = UIColor(named: "App_LightBlack")!
        
        let gradient: CAGradientLayer = CAGradientLayer()
//        gradient.colors = [UIColor.red.cgColor, UIColor.blue.cgColor]
        gradient.colors = [fistColor.cgColor, lastColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 170)
        viewBack.layer.insertSublayer(gradient, at: 0)
    }
}

//MARK: //////    Hide Keyboard on Tap  ////////

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapOutKeyboard = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapOutKeyboard)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}


//MARK: //////    Colour Hexa String  ////////
extension UIColor
{
    class func colorWithHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in:(NSCharacterSet.whitespacesAndNewlines as NSCharacterSet) as CharacterSet).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substring(from: 1)
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        let rString = (cString as NSString).substring(to: 2)
        let gString = ((cString as NSString).substring(from: 2) as NSString).substring(to: 2)
        let bString = ((cString as NSString).substring(from: 4) as NSString).substring(to: 2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        Scanner(string: rString).scanHexInt32(&r)
        Scanner(string: gString).scanHexInt32(&g)
        Scanner(string: bString).scanHexInt32(&b)
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
}

// MARK: Activity Indicator
extension UIViewController : NVActivityIndicatorViewable
{
    func showSpinnerWith(title:String)
    {
        DispatchQueue.main.async {
            let size = CGSize(width: 50, height: 50)
            
            self.startAnimating(size, message: title, type: .lineScalePulseOut, color: k_baseColor)
        }
    }
    
    func hideSpinner()
    {
        DispatchQueue.main.async {
            self.stopAnimating()
        }
    }
}

// MARK: TEXTFIELD PH Color
extension UITextField
{
    func setPlaceHolderColorWith(strPH:String)
    {
        self.attributedPlaceholder = NSAttributedString(string: strPH, attributes: [NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.3694939017, green: 0.3694939017, blue: 0.3694939017, alpha: 1)])
    }
}

// MARK: Make Some Text SemiBold
extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont(name: "AvenirNext-Medium", size: 12)!]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let normal = NSAttributedString(string: text)
        append(normal)
        
        return self
    }
}

extension UIImageView {
    
    func setImageUsingUrl(_ imageUrl: String?){
        self.sd_setImage(with: URL(string: imageUrl!), placeholderImage:UIImage(named: "ph"))
    }
}

extension UIViewController
{
    // MARK: Present Modal Custom
    
    func presentModal(vc:UIViewController)
    {
        let transition = CATransition()
        transition.duration = 0.45
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        view.window!.layer.add(transition, forKey: kCATransition)
        DispatchQueue.main.async {
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    func generateCurrentTimeStamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy_MM_dd_hh_mm_ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
}

extension String {
    
    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    public func width(withConstrainedHeight height: CGFloat, font: UIFont, minimumTextWrapWidth:CGFloat) -> CGFloat {
        
        var textWidth:CGFloat = minimumTextWrapWidth
        let incrementWidth:CGFloat = minimumTextWrapWidth * 0.1
        var textHeight:CGFloat = self.height(withConstrainedWidth: textWidth, font: font)
        
        //Increase width by 10% of minimumTextWrapWidth until minimum width found that makes the text fit within the specified height
        while textHeight > height {
            textWidth += incrementWidth
            textHeight = self.height(withConstrainedWidth: textWidth, font: font)
        }
        return ceil(textWidth)
    }
}

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

// MARK: Convert to MD5 Hash encoding
extension String {
    var md5Value: String {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)
        
        if let d = self.data(using: .utf8) {
            _ = d.withUnsafeBytes { body -> String in
                CC_MD5(body.baseAddress, CC_LONG(d.count), &digest)
                
                return ""
            }
        }
        
        return (0 ..< length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}

class UIInsetDownLabel: UILabel {
    var padding = UIEdgeInsets(top: 0, left: 0, bottom: -20, right: 0)
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}

class UIInsetUpLabel: UILabel {
    var padding = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }
    
    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right,
                      height: size.height + padding.top + padding.bottom)
    }
}

extension String{
    func toCurrencyFormat() -> String {
        if let intValue = Int(self){
            let numberFormatter = NumberFormatter()
            numberFormatter.locale = Locale(identifier: "es_MX")
            numberFormatter.numberStyle = NumberFormatter.Style.currency
            return numberFormatter.string(from: NSNumber(value: intValue)) ?? ""
        }
        return ""
    }
}

extension UIViewController
{
    func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {

        let attrs = [
            NSAttributedString.Key.font: UIFont(name: CustomFont.semiBold, size: 17),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let nonBoldAttribute = [
            NSAttributedString.Key.font: UIFont(name: CustomFont.regular, size: 17),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = nonBoldRange {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        return attrStr
    }
    
    func attributedStringWithColor(from string: String, nonBoldRange: NSRange?, color:UIColor) -> NSAttributedString {

        let attrs = [
            NSAttributedString.Key.font: UIFont(name: CustomFont.semiBold, size: 17),
            NSAttributedString.Key.foregroundColor: color
        ]
        let nonBoldAttribute = [
            NSAttributedString.Key.font: UIFont(name: CustomFont.regular, size: 17),
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = nonBoldRange {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        return attrStr
    }
}


extension UIScrollView {
    func scrollToTop(animated: Bool) {
        setContentOffset(CGPoint(x: 0, y: -contentInset.top),
                         animated: animated)
    }

    func scrollToBottom(animated: Bool) {
        setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude),
                     animated: animated)
    }
}


extension StringProtocol {
    var firstUppercased: String {
        return prefix(1).uppercased()  + dropFirst()
    }
    var firstCapitalized: String {
        return prefix(1).capitalized + dropFirst()
    }
}

extension AVAsset {

    func generateThumbnail(completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            let imageGenerator = AVAssetImageGenerator(asset: self)
            let time = CMTime(seconds: 0.0, preferredTimescale: 600)
            let times = [NSValue(time: time)]
            imageGenerator.generateCGImagesAsynchronously(forTimes: times, completionHandler: { _, image, _, _, _ in
                if let image = image {
                    completion(UIImage(cgImage: image))
                } else {
                    completion(nil)
                }
            })
        }
    }
}
