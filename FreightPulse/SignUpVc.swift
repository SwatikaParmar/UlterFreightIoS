//
//  SignUpVc.swift
//  FreightPulse
//
//  Created by AbsolveTech on 17/09/24.
//

import UIKit
import CocoaTextField
import CountryPickerView

class SignUpVc: UIViewController {
    @IBOutlet weak var txt_Phone : CocoaTextField!
    @IBOutlet weak var txt_Email : CocoaTextField!
    @IBOutlet weak var txt_Password : CocoaTextField!
    @IBOutlet weak var txt_PasswordConfirm : CocoaTextField!
    @IBOutlet weak var countryPicker: CountryPickerView!

    
    var trimmedEmail = ""
    var trimmedPassword = ""
    var trimmedPhone = ""
    var eyeClick = true
    var eyeClickC = true
    var phoneCode = ""


    override func viewDidLoad() {
        super.viewDidLoad()
        self.countryPicker.font = UIFont(name: FontName.Inter.Regular, size: 14)!
        self.countryPicker.delegate = self
        self.phoneCode = "+1"
        countryPicker.setCountryByCode("US")
        countryPicker.showCountryCodeInView = false
        addEye()
        
        
        txt_Phone.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        applyStyle(to: txt_Phone)
        txt_Phone.placeholder = "Phone number"
        txt_Phone.keyboardType = .phonePad

        
        txt_Email.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        applyStyle(to: txt_Email)
        txt_Email.placeholder = "Email"
        
        txt_Password.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!

        applyStyle(to: txt_Password)
        txt_Password.placeholder = "Password"
        txt_PasswordConfirm.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!

        applyStyle(to: txt_PasswordConfirm)
        txt_PasswordConfirm.placeholder = "Confirm Password"
        
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
        
        txt_PasswordConfirm.isSecureTextEntry = true

        let buttonNewC = UIButton(type: .custom)
        buttonNewC.setImage(UIImage(named: "eyesHide_ic"), for: .normal)
        buttonNewC.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
        buttonNewC.frame = CGRect(x: CGFloat(txt_PasswordConfirm.frame.size.width - 35), y: CGFloat(5), width: CGFloat(30), height: CGFloat(30))
        buttonNewC.addTarget(self, action: #selector(self.eyePassword1), for: .touchUpInside)
        txt_PasswordConfirm.rightView = buttonNewC
        txt_PasswordConfirm.rightViewMode = .always
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
    
    @IBAction func eyePassword1(_ sender: UIButton) {
        if(eyeClickC == true) {
            sender.setImage(UIImage(named: "eyes_ic"), for: .normal)
            txt_PasswordConfirm.isSecureTextEntry = false
        } else {
            sender.setImage(UIImage(named: "eyesHide_ic"), for: .normal)
            txt_PasswordConfirm.isSecureTextEntry = true
        }
        eyeClickC = !eyeClickC
    }
    
    
    @IBAction func back(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
  
    
    //Hide KeyBoard When touche on View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
 
    @IBAction func SignUp(_ sender: Any) {
        
        self.view.endEditing(true)
        

        trimmedEmail = txt_Email.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        trimmedPassword = txt_Password.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        trimmedPhone = txt_Phone.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        let  trimmedCPassword = txt_PasswordConfirm.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

        
        if (trimmedEmail.isEmpty){
            self.MessageAlertError(message: "Please enter email")
            return
        }
        
        if trimmedEmail.isValidEmail() {
        }
        else{
            self.MessageAlertError(message: "Please enter valid email address")
            return
        }
        
        if (trimmedPhone.isEmpty){
            self.MessageAlertError(message: "Please enter phone number")
            return
        }
        
        if trimmedPhone.count < 9 {
            self.MessageAlertError(message: "Please Enter valid phone number")
            return
        }
        
        if (trimmedPassword.isEmpty){
            self.MessageAlertError(message: "Please enter password")
            return
        }
        
        
        if trimmedPassword.count < 6{
            self.MessageAlertError(message: "Password should be 6 characters or more")
            return
        }
        else if trimmedCPassword.trimmingCharacters(in: .whitespaces).count == 0 {
            NotificationAlert().NotificationAlert(titles: "Please enter confirm password")
            return
        }
        else  if (trimmedPassword.trimmingCharacters(in: .whitespaces)) != (trimmedCPassword.trimmingCharacters(in: .whitespaces)){
           
            NotificationAlert().NotificationAlert(titles: "Password not match")
            return
        }
        
        
        
        
        let paramsEmail = ["email":self.trimmedEmail
                           , "isVerify": true] as [String : Any]
        self.callResendEmailApi(param: paramsEmail)
        
    }
    
    //MARK:-  Resend OTP on Email
    func callResendEmailApi(param : [String : Any]){
        
        ResendEmailAPIRequest.shared.ResendEmail(requestParams: param, accessToken:"") { (message, status,otp) in
            
            if status == true{
                let controller:VerifiyViewController = UIStoryboard(storyboard: .main).initVC()
                controller.codeStr = String(otp)
                controller.email = self.trimmedEmail
                controller.trimmedPassword = self.trimmedPassword
                controller.stringPhoneNo = self.trimmedPhone
                controller.stringEmail = self.trimmedEmail
                controller.phoneCode = self.phoneCode
                self.navigationController?.pushViewController(controller, animated: true)
                
            }
            else
            {
                self.MessageAlertError(message: message!)
            }
        }
    }
    
}
extension SignUpVc: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == " "  {
               return false
           }
        
        if string == ""{
            return true
        }
        if textField.text == "" && string == " "{
            return false
        }
      
        if textField.text?.count ?? 0 > 100{
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
     }
    
}
extension SignUpVc: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        phoneCode = country.phoneCode
        print(message)
    }
}
