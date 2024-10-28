//
//  VerifiyViewController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 22/10/24.
//

import UIKit
import SVPinView

class VerifiyViewController: UIViewController ,UITextFieldDelegate{
    @IBOutlet weak var pinViewPhone: SVPinView!
    
    @IBOutlet weak var lbeTextTop: UILabel!

    
    var email = ""
    var codeStr = ""
    var accessToken = ""
    var enterCodeStr = ""
    var trimmedName = ""
    var trimmedlast = ""
    var trimmedPassword = ""
    var stringPhoneNo = ""
    var stringEmail = ""
    var stringPassword = ""

    var stringGender = ""
    var phoneCode = ""
    var img = UIImage()
    var imgIS = false
    var isForgot = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        lbeTextTop.text = String(format: "Please enter the 5-digit code sent to your %@", stringEmail)
        configurePhonePinView()
        
        let alert = UIAlertController(title:codeStr, message:  "Testing OTP", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"OK" , style: .cancel, handler:{ (UIAlertAction)in
            
        }))
        self.present(alert, animated: true, completion: {
            
        })

      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    @IBAction func btnBackPreessed(_ sender: Any){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonLoginPressed(_ sender: Any) {
       
        callData()
    
    }
    
    
    func callData(){
        
       
        
        self.view.endEditing(true)
        if enterCodeStr.trimmingCharacters(in: .whitespaces).count == 0 {
            NotificationAlert().NotificationAlert(titles: "Please enter verification code.")
            return
        }
        else if codeStr !=  enterCodeStr{
            NotificationAlert().NotificationAlert(titles: "Incorrect verification code.")
            return
        }
        else{
            if isForgot {
                
                    
                var param = [String : AnyObject]()
                param["emailOrPhoneNumber"] = stringEmail as AnyObject
                param["newPassword"] = stringPassword as AnyObject

                    
                    UserResetPasswordRequest.shared.ResetPasswordData(requestParams:param, true) { (message,isStatus) in
                        if isStatus {
                            LoginMessageAlert(title: "Congratulation!", message: message ?? "Successfully")
                            }
                        else{
                                NotificationAlert().NotificationAlert(titles: message ?? GlobalConstants.serverError)

                            }
                        }
                    }
            
            else{
                SignUp_User()
            }
        }
        
        func LoginMessageAlert(title:String,message:String)
        {
            let alert = UIAlertController(title: title, message:  message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title:"OK" , style: .cancel, handler:{ (UIAlertAction)in
                
                RootControllerManager().SetRootViewController()

            }))
            self.present(alert, animated: true, completion: {
                
            })
        }
    }
    
    
    func configurePhonePinView(){
        self.view.layoutIfNeeded()

        self.pinViewPhone.font = UIFont.init(name: FontName.Inter.Medium, size: 24.0) ?? UIFont.systemFont(ofSize: 22)
        self.pinViewPhone.borderLineColor = UIColor.darkGray
        self.pinViewPhone.activeBorderLineColor = AppColor.AppThemeColor
        self.pinViewPhone.borderLineThickness = 1.1
        self.pinViewPhone.activeBorderLineThickness = 1.9
        self.pinViewPhone.interSpace = 15
        self.pinViewPhone.style = .box
        self.pinViewPhone.pinLength = 5
        self.pinViewPhone.fieldCornerRadius = 5
        self.pinViewPhone.activeFieldCornerRadius = 5
        self.pinViewPhone.textColor = AppColor.AppThemeColor
        self.pinViewPhone.shouldSecureText = false
        self.pinViewPhone.keyboardType = .numberPad
        self.pinViewPhone.pinInputAccessoryView = { () -> UIView in
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
            doneToolbar.barStyle = UIBarStyle.default
            let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let done: UIBarButtonItem  = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(dismissKeyboard))
            
            var items = [UIBarButtonItem]()
            items.append(flexSpace)
            items.append(done)
            
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            return doneToolbar
        }()
        
        self.pinViewPhone.didChangeCallback = { pin in
            print("The entered pin is \(pin)")
            self.enterCodeStr = String(pin)
        }
        
        self.pinViewPhone.didFinishCallback = { pin in
            print("The entered pin is \(pin)")
            self.enterCodeStr = String(pin)
            self.callData()
        }
    }
    
    //MARK:-  Dismiss Keyboard Action
    @objc func dismissKeyboard(){
        self.view.endEditing(false)
    }
    
    
    
       func SignUp_User(){
           
           var driverArray = [String]()
           driverArray.append("Driver")

                let params = ["email": stringEmail,
                              "password": trimmedPassword,
                              "dialCode": self.phoneCode,
                              "phoneNumber":stringPhoneNo,
                              "roles": driverArray
                ] as [String : Any]
        
           AccountAPIRequest.shared.RegisterUser(requestParams: params) { (obj, msg, success,Verification) in
        
                    if success == false {
                        self.MessageAlertError(message: msg!)
                    }
                    else
                    {
                       
                  
                            UserDefaults.standard.set(true, forKey: Constants.login)
                            UserDefaults.standard.synchronize()
                            RootControllerManager().SetRootViewController()

                    }
                       
            
        }
    }
    
    
    @IBAction func resendAc(_ sender: Any) {
        
        var paramsEmail = ["email":self.stringEmail
                           , "isVerify": true] as [String : Any]
        
        if isForgot {
             paramsEmail = ["email":self.stringEmail
                               , "isVerify": false] as [String : Any]
        }
        self.pinViewPhone.clearPin()
        
        
        ResendEmailAPIRequest.shared.ResendEmail(requestParams: paramsEmail, accessToken:"") { (message, status,otp) in
            
            if status == true{
                self.codeStr = String(otp)
                NotificationAlert().NotificationAlert(titles: message ?? "")

                let alert = UIAlertController(title:self.codeStr, message:  "Testing OTP", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title:"OK" , style: .cancel, handler:{ (UIAlertAction)in
                    
                }))
                self.present(alert, animated: true, completion: {
                    
                })
            }
        }
    }
}


