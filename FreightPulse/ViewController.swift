//
//  ViewController.swift
//  FreightPulse
//
// 
//

import UIKit
import CocoaTextField
import Reachability
import CountryPickerView

class ViewController: UIViewController {
    @IBOutlet weak var txt_Email : CocoaTextField!
    @IBOutlet weak var txt_Password : CocoaTextField!
    @IBOutlet weak var txt_Phone : CocoaTextField!
    @IBOutlet weak var countryPicker: CountryPickerView!

    var eyeClick = true
    var phoneCode = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countryPicker.font = UIFont(name: FontName.Inter.Medium, size: 14)!
        self.countryPicker.delegate = self
        self.phoneCode = "+1"
        countryPicker.setCountryByCode("US")
        countryPicker.showCountryCodeInView = false
        
        addEye()
        txt_Email.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_Email.placeholder = "Email"
        txt_Email.keyboardType = .emailAddress
        txt_Email.autocapitalizationType = .none
        applyStyle(to: txt_Email)
        
       
        txt_Password.placeholder = "Password"
        txt_Password.isSecureTextEntry = true
        txt_Password.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        applyStyle(to: txt_Password)
        
        
        
        txt_Phone.placeholder = "Phone number"
        txt_Phone.keyboardType = .phonePad
        txt_Phone.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
                
        
        applyStyle(to: txt_Phone)

    }
    //Hide KeyBoard When touche on View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view .endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func addEye() {
        txt_Password.isSecureTextEntry = true

        let buttonNew = UIButton(type: .custom)
        buttonNew.setImage(UIImage(named: "eyesHide_ic"), for: .normal)
        buttonNew.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        buttonNew.frame = CGRect(x: CGFloat(txt_Password.frame.size.width - 35), y: CGFloat(5), width: CGFloat(30), height: CGFloat(30))
        buttonNew.addTarget(self, action: #selector(self.eyePassword), for: .touchUpInside)
        txt_Password.rightView = buttonNew
        txt_Password.rightViewMode = .always
    }
    
    @IBAction fileprivate func SignUp(_ sender: Any) {
           self.view .endEditing(true)
           let controller:SignUpVc =  UIStoryboard(storyboard: .main).initVC()
           self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func eyePassword(_ sender: UIButton) {
        if(eyeClick == true) {
            sender.setImage(UIImage(named: "eyes_ic"), for: .normal)
            txt_Password.isSecureTextEntry = false
        } else {
            sender.setImage(UIImage(named: "eyesHide_ic"), for: .normal)
            txt_Password.isSecureTextEntry = true
        }
        eyeClick = !eyeClick
    }
    
    @IBAction fileprivate func ForgotAction(_ sender: Any) {
        self.view .endEditing(true)
            let controller:ForgotViewController =  UIStoryboard(storyboard: .main).initVC()
            self.navigationController?.pushViewController(controller, animated: true)
        
       
    }
    
   

    
    @IBAction fileprivate func SignInAction(_ sender: Any) {
        self.view .endEditing(true)
        
        var trimmedEmail = txt_Email.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = txt_Password.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAc = txt_Phone.text
        
        var dataDict = Dictionary<String, Any>()
        
        
        if (trimmedEmail?.isEmpty)! &&  (trimmedAc?.isEmpty)!{
            MessageAlertError(message: "Please enter your email or phone number")
            return
        }
        
        if (trimmedPassword?.isEmpty)!{
            MessageAlertError(message: "Please enter your password")
            return
        }
        
        if (trimmedEmail?.isEmpty)!{
            trimmedEmail = trimmedAc
            dataDict = ["emailOrPhoneNumber": trimmedEmail ?? "",
                        "password": trimmedPassword ?? "",
                        "dialCode": phoneCode ] as [String : Any]
        }
        else{
           
          
            dataDict = ["emailOrPhoneNumber": trimmedEmail ?? "",
                        "password": trimmedPassword ?? "",
                        "dialCode": "" ] as [String : Any]
        }
    
        loginRequest(Params: dataDict)
    }
    
    //MARK: -  Login Data API Call --
    func loginRequest(Params:[String: Any])
    {
      
        
        LoginAPIRequest.shared.login(requestParams: Params) { (obj, msg, success,Verification,ScreenNumber,accessToken,email) in
            
            if success == false {
                self.MessageAlertError(message: msg!)

            }
            else
            {
                if Verification {
                   
                    UserDefaults.standard.set(true, forKey: Constants.login)
                    UserDefaults.standard.synchronize()
                    RootControllerManager().SetRootViewController()
                }

            }
        }
    }
    
   
}

extension UIViewController {
    
    
        static var hasSafeArea: Bool {
            var statusBarHeight: CGFloat = 0
            let scenes = UIApplication.shared.connectedScenes
            let windowScene = scenes.first as? UIWindowScene
            let window = windowScene?.windows.first
            statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
            if statusBarHeight > 24 {
                return true
         }
            return false
     }
 

    
    func applyStyle(to v: CocoaTextField) {
    
        v.tintColor = UIColor.black
        v.textColor = UIColor.black
        v.inactiveHintColor = UIColor.darkGray
        v.activeHintColor = UIColor.darkGray
        v.focusedBackgroundColor = UIColor.clear
        v.defaultBackgroundColor = UIColor.clear
        v.borderColor = UIColor.clear
        v.errorColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 0.7)

    }

    func MessageAlertError(message:String)
    {
        let alert = UIAlertController(title:"Oops!", message:  message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK" , style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        self.present(alert, animated: true, completion: {
            
        })
    }
    
    func popMessageAlert(title:String,message:String)
    {
        let alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK" , style: .cancel, handler:{ (UIAlertAction)in
            
            self.navigationController?.popViewController(animated: true)
            
        }))
        self.present(alert, animated: true, completion: {
            
        })
    }
    
    func SessionMessageAlert(title:String,message:String)
    {
        let alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK" , style: .cancel, handler:{ (UIAlertAction)in
        
            NotificationCenter.default.post(name: Notification.Name("SessionExpire"), object: nil)
            
        }))
        self.present(alert, animated: true, completion: {
            
        })
        
    }
    
    func InterNetConnection()->Bool  {
        
        let reachability = try! Reachability()
        if reachability.connection != .unavailable {
            return true
        }
        else
        {
            return false
        }
    }
    
    func InternetAlert()
    {
        
        let alert = UIAlertController(title: "No Internet Connection", message: "Internet not available, Cross check your internet connectivity and try again", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
extension ViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        phoneCode = country.phoneCode
        print(message)
    }
}
