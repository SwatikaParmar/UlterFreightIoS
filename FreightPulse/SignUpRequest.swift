//
//  SignUpRequest.swift
//  FreightPulse
//
//  Created by AbsolveTech on 22/10/24.
//

import UIKit


class ResendEmailAPIRequest: NSObject {
    
    static let shared = ResendEmailAPIRequest()
    
    func ResendEmail(requestParams : [String:Any],accessToken:String, completion: @escaping (_ message : String?, _ status : Bool, _ otp:Int) -> Void) {
        
        AlamofireRequest.shared.PostBodyForRawData(urlString: "BaseURL".EmailOTP, parameters: requestParams, authToken: "", isLoader: true, loaderMessage: "") { (data, error) in
            
            if error == nil{
                print(data as Any)
                
                if let status = data?["isSuccess"] as? Bool{
                    
                    var messageString : String = ""
                    var OTP = 0
                    
                    if let msg = data?["messages"] as? String{
                        messageString = msg
                    }
                    
                    if status == true
                    {
                        if let Result = data?["data"] as? [String : Any]{
                            
                            if let otpCodes = Result["otp"] as? Int{
                                OTP = otpCodes
                            }
                        }
                        
                        completion(messageString, true,OTP)
                    }
                    else{
                        
                        completion(messageString, false,OTP)
                    }
                }
                else
                {
                    completion( GlobalConstants.serverError, false,0)
                }
                
            }else{
                completion( GlobalConstants.serverError, false,0)
            }
        }
    }
}

class AccountAPIRequest: NSObject {
    
    static let shared = AccountAPIRequest()
    func RegisterUser(requestParams : [String:Any], completion: @escaping (_ object: LoginObjectModel?,_ message : String?, _ status : Bool,_ accessToken:String) -> Void)
    {
        
        print("URL---->> ","BaseURL".SignUpURL)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString: "BaseURL".SignUpURL, parameters: requestParams, authToken: "", isLoader: true, loaderMessage: "") { (data, error) in
            if error == nil{
                print("*************************************************")
                print(data ?? "No data")
                if let status = data?["isSuccess"] as? Bool
                {
                    
                    var messageString : String = ""
                    var accessToken : String = ""
                    
                    if let msg = data?["messages"] as? String{
                        messageString = msg
                    }
                    
                    if status == true
                    {
                        if let Result = data?["data"] as? [String : Any]{
                            
                            if let accessTokenS = Result["token"] as? String{
                                accessToken = accessTokenS
                                
                                UserDefaults.standard.set(accessToken, forKey: Constants.accessToken)
                                UserDefaults.standard.synchronize()
                                
                                if let phoneNumber = Result["id"] {
                                    if phoneNumber is NSNull || phoneNumber == nil || (phoneNumber as? String) == "<null>" {
                                        
                                    } else {
                                        UserDefaults.standard.set(Result["id"], forKey: Constants.userId)
                                    }
                                }
                                
                                if let phoneNumber = Result["email"] {
                                    if phoneNumber is NSNull || phoneNumber == nil || (phoneNumber as? String) == "<null>" {
                                        
                                    } else {
                                        
                                        UserDefaults.standard.set(Result["email"], forKey: Constants.email)
                                    }
                                }
                                
                                
                                if let phoneNumber = Result["phoneNumber"] {
                                    
                                    if phoneNumber is NSNull || phoneNumber == nil || (phoneNumber as? String) == "<null>" {
                                        
                                    } else {
                                        UserDefaults.standard.set(Result["phoneNumber"], forKey: Constants.phoneNumber)
                                        
                                    }
                                }
                                
                                if let phoneNumber = Result["dialCode"] {
                                    if phoneNumber is NSNull || phoneNumber == nil || (phoneNumber as? String) == "<null>" {
                                        
                                    } else {
                                        UserDefaults.standard.set(Result["dialCode"], forKey: Constants.phoneCode)
                                    }
                                }
                                
                                
                                UserDefaults.standard.synchronize()
                                
                            }
                            let userModel : LoginObjectModel = LoginObjectModel.init(model: Result as [String : Any])
                            completion(userModel, messageString, status, "")
                        }
                    }
                    else
                    {
                        completion(nil, messageString, status,"")
                    }
                }
                else
                {
                    completion(nil, GlobalConstants.serverError, false,"")
                }
            }
            else{
                completion(nil,GlobalConstants.serverError, false,"")
            }
        }
    }
}

class UserResetPasswordRequest: NSObject {

    static let shared = UserResetPasswordRequest()
    func ResetPasswordData(requestParams : [String:Any], _ isLoader : Bool, completion: @escaping (_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String("BaseURL".ResetPassword)
        
    
        AlamofireRequest.shared.PostBodyForRawData(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: isLoader, loaderMessage: "") { (data, error) in
                
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = ""
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status {
                                 completion(messageString,true)
                             }else{
                                 completion(messageString,false)
                             }
                         }
                         else
                         {
                             completion(GlobalConstants.serverError,false)
                         }
                        }
                        else
                        {
                            completion(GlobalConstants.serverError,false)
                        }
                }
            }
        }


class LoginAPIRequest: NSObject {
    
    static let shared = LoginAPIRequest()
    
    func login(requestParams : [String:Any], completion: @escaping (_ object: LoginObjectModel?,_ message : String?, _ status : Bool,_ Verification : Bool,_ ScreenNumber:Int,_ accessToken:String,_ OTP:String) -> Void) {
        
        print("URL---->> ","BaseURL".LoginURL)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString: "BaseURL".LoginURL, parameters: requestParams, authToken: "", isLoader: true, loaderMessage: "") { (data, error) in
            print("*************************************************")
            print(data ?? "No data")
            if error == nil{
                
                if let status = data?["isSuccess"] as? Bool{
                    var messageString : String = ""
                    var accessToken : String = ""
                    var emailConfirmed : Bool = false
                    var lastScreenId : Int = 0
                    var email : String = ""
                    
                    if let msg = data?["messages"] as? String{
                        messageString = msg
                    }
                    
                    if status == true{
                        
                        if let Result = data?["data"] as? [String : Any]{
                  
                            if let accessTokenS = Result["token"] as? String{
                                accessToken = accessTokenS
                                
                                UserDefaults.standard.set(accessToken, forKey: Constants.accessToken)
                                UserDefaults.standard.synchronize()
                                
                                if let phoneNumber = Result["id"] {
                                    if phoneNumber is NSNull || phoneNumber == nil || (phoneNumber as? String) == "<null>" {
                                      
                                    } else {
                                        UserDefaults.standard.set(Result["id"], forKey: Constants.userId)
                                    }
                                }
                                
                                if let phoneNumber = Result["email"] {
                                    if phoneNumber is NSNull || phoneNumber == nil || (phoneNumber as? String) == "<null>" {
                                      
                                    } else {
                                        
                                        UserDefaults.standard.set(Result["email"], forKey: Constants.email)
                                    }
                                }
                                
                                
                                if let phoneNumber = Result["phoneNumber"] {
                                    
                                    if phoneNumber is NSNull || phoneNumber == nil || (phoneNumber as? String) == "<null>" {
                                      
                                    } else {
                                        UserDefaults.standard.set(Result["phoneNumber"], forKey: Constants.phoneNumber)

                                    }
                                }
                                
                                if let phoneNumber = Result["dialCode"] {
                                    if phoneNumber is NSNull || phoneNumber == nil || (phoneNumber as? String) == "<null>" {
                                      
                                    } else {
                                        UserDefaults.standard.set(Result["dialCode"], forKey: Constants.phoneCode)
                                    }
                                }
                                

                                UserDefaults.standard.synchronize()
                                let userModel : LoginObjectModel = LoginObjectModel.init(model: Result as [String : Any])
                                completion(userModel, messageString, status,true,lastScreenId,accessToken, email)

                            }
                        }
                    }
                    else
                    {
                            completion(nil, messageString,status,emailConfirmed,lastScreenId,"", "")
                    }
                }
                else
                {
                    completion(nil, GlobalConstants.serverError, false,false,0,"","")
                }
            }
            else{
                completion(nil,GlobalConstants.serverError, false,false,0,"","")
            }
        }
    }
    
}
