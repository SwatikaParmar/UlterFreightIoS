//
//  AlamofireRequest.swift
//
//
//  Created by AbsolveTech on 15/07/24.
//

import Foundation
import Alamofire
import Reachability
import NVActivityIndicatorView

class AlamofireRequest: NSObject {
    static let shared = AlamofireRequest()
    var StatusCodeValue = 0
    
    // MARK: - PostBodyForRawData
    func PostBodyForRawData(urlString : String,parameters : Parameters ,authToken : String?,isLoader : Bool, loaderMessage : String, completion: @escaping (_ success: [String : AnyObject]?,_ error : Error?) -> Void) {
        let reachability = try! Reachability()
        if reachability.connection != .unavailable {
            
            if isLoader{
                Indicator.shared.startAnimating(withMessage: loaderMessage, colorType: UIColor.white, colorText:UIColor.white)
            }
            
            if let urL = URL(string: urlString) {
                if let data = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted),
                   let jsonString = String(data: data, encoding: .utf8) {
                    
                    var request = URLRequest(url: urL)
                    request.httpMethod = HTTPMethod.post.rawValue
                    
                    if authToken != nil && authToken != ""{
                        let bearer : String = "Bearer \(authToken!)"
                        print(bearer)
                        request.addValue(bearer, forHTTPHeaderField: "Authorization")
                    }
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = jsonString.data(using: .utf8)
                    
                    AF.request(request).responseData { response in
                        if isLoader{
                            Indicator.shared.stopAnimating()
                        }
                        if let statusCode = response.response?.statusCode
                        {
                            self.StatusCodeValue = statusCode
                            self.SessionEnd(code: self.StatusCodeValue)
                        }
                        switch response.result {
                        case .success(let data):
                            do {
                                let asJSON = try JSONSerialization.jsonObject(with: data)
                                Indicator.shared.stopAnimating()
                                if let responseDictionary = asJSON as? [String: AnyObject] {
                                    completion(responseDictionary, nil)
                                }
                                else{
                                    Indicator.shared.stopAnimating()
                                    completion(nil , response.error)
                                }
                            } catch {
                                Indicator.shared.stopAnimating()
                                completion(nil,response.error)
                            }
                        case .failure(let error):
                            Indicator.shared.stopAnimating()
                            completion(nil,error)
                            break
                        }
                    }
                }
                else{
                    Indicator.shared.stopAnimating()
                    completion(nil,nil)
                }
            }
            else
            {
                Indicator.shared.stopAnimating()
                completion(nil,nil)
                
            }
        }
        else
        {
            Indicator.shared.stopAnimating()
            InternetConnectionAlert()
        }
    }
    
    
    // MARK: - GetBodyFrom
    func GetBodyFrom(urlString : String,parameters : Parameters ,authToken : String?,isLoader : Bool, loaderMessage : String, completion: @escaping (_ success: [String : AnyObject]?,_ error : Error?) -> Void)  {
        
        
         let reachability = try! Reachability()
         if reachability.connection != .unavailable {
             if isLoader{
               Indicator.shared.startAnimating(withMessage: loaderMessage, colorType: UIColor.white, colorText:UIColor.white)
             }
    
        if let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.get.rawValue
                
            if authToken != nil{
                let bearer : String = "Bearer \(authToken!)"
                print(bearer)
                urlRequest.addValue(bearer, forHTTPHeaderField: "Authorization")
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
                
            AF.request(urlRequest).responseData { response in
                        
                if isLoader{
                    Indicator.shared.stopAnimating()
                }
                if let statusCode = response.response?.statusCode
                {
                    self.StatusCodeValue = statusCode
                    self.SessionEnd(code: self.StatusCodeValue)
                }
                switch response.result {
                case .success(let data):
                    do {
                        let asJSON = try JSONSerialization.jsonObject(with: data)
                        if let responseDictionary = asJSON as? [String: AnyObject] {
                            completion(responseDictionary, nil)
                        }
                        else{
                            Indicator.shared.stopAnimating()
                            completion(nil , response.error)
                        }
                    } catch {
                        Indicator.shared.stopAnimating()
                        completion(nil,response.error)
                    }
                case .failure(let error):
                    Indicator.shared.stopAnimating()
                    completion(nil,error)
                    break
                }
            }
        }
             else{
                 Indicator.shared.stopAnimating()
                 completion(nil,nil)
             }
         }
            else
            {
                Indicator.shared.stopAnimating()
                InternetConnectionAlert()
            }
    }
    
    
    // MARK: - postBodyFrom
    func GetPostBodyFrom(urlString : String,parameters : Parameters ,authToken : String?,isLoader : Bool, loaderMessage : String, completion: @escaping (_ success: [String : AnyObject]?,_ error : Error?) -> Void)  {
        
        
        let reachability = try! Reachability()
         if reachability.connection != .unavailable {
             if isLoader{
                 Indicator.shared.startAnimating(withMessage: loaderMessage, colorType: UIColor.white, colorText:UIColor.white)
             }
    
        if let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.post.rawValue
                
            if authToken != nil{
                let bearer : String = "Bearer \(authToken!)"
                print(bearer)
                urlRequest.addValue(bearer, forHTTPHeaderField: "Authorization")
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
                
            AF.request(urlRequest).responseData { response in
                        
                if isLoader{
                    Indicator.shared.stopAnimating()
                }
                if let statusCode = response.response?.statusCode
                {
                    self.StatusCodeValue = statusCode
                    self.SessionEnd(code: self.StatusCodeValue)
                }
                switch response.result {
                case .success(let data):
                    do {
                        let asJSON = try JSONSerialization.jsonObject(with: data)
                        if let responseDictionary = asJSON as? [String: AnyObject] {
                            completion(responseDictionary, nil)
                        }
                        else{
                            Indicator.shared.stopAnimating()
                            completion(nil , response.error)
                        }
                    } catch {
                        Indicator.shared.stopAnimating()
                        completion(nil,response.error)
                    }
                case .failure(let error):
                    Indicator.shared.stopAnimating()
                    completion(nil,error)
                    break
                }
            }
        }
             else{
                 Indicator.shared.stopAnimating()
                 completion(nil,nil)
             }
         }
            else
            {
                Indicator.shared.stopAnimating()
                InternetConnectionAlert()
            }
    }
    
    
    // MARK: - LivePostBodyForRawData
    func LivePostBodyForRawData(urlString : String,parameters : Parameters ,authToken : String?,isLoader : Bool, loaderMessage : String, completion: @escaping (_ success: [String : AnyObject]?,_ error : Error?) -> Void) {
        let reachability = try! Reachability()
        if reachability.connection != .unavailable {
            
            if isLoader{
                Indicator.shared.startAnimating(withMessage: loaderMessage, colorType: UIColor.white, colorText:UIColor.white)
            }
            
            if let urL = URL(string: urlString) {
                if let data = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted),
                   let jsonString = String(data: data, encoding: .utf8) {
                    
                    var request = URLRequest(url: urL)
                    request.httpMethod = HTTPMethod.post.rawValue
                    
                    if authToken != nil && authToken != ""{
                        let bearer : String = "Bearer \(authToken!)"
                        request.addValue(bearer, forHTTPHeaderField: "Authorization")
                    }
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.httpBody = jsonString.data(using: .utf8)
                    
                    AF.request(request).responseData { response in
                        debugPrint(response)
                        if isLoader{
                            Indicator.shared.stopAnimating()
                        }
                        if let statusCode = response.response?.statusCode
                        {
                            self.StatusCodeValue = statusCode
                            self.SessionEnd(code: self.StatusCodeValue)
                        }
                        switch response.result {
                        case .success(let data):
                            do {
                                let asJSON = try JSONSerialization.jsonObject(with: data)
                                if let responseDictionary = asJSON as? [String: AnyObject] {
                                    completion(responseDictionary, nil)
                                }
                                else{
                                    Indicator.shared.stopAnimating()
                                    completion(nil , response.error)
                                }
                            } catch {
                                Indicator.shared.stopAnimating()
                                completion(nil,response.error)
                            }
                        case .failure(let error):
                            Indicator.shared.stopAnimating()
                            completion(nil,error)
                            break
                        }
                    }
                }
                else{
                    Indicator.shared.stopAnimating()
                    completion(nil,nil)
                }
            }
            else
            {
                Indicator.shared.stopAnimating()
                completion(nil,nil)
                
            }
        }
        else
        {
            Indicator.shared.stopAnimating()
        }
    }
    
    
    
    // MARK: - DeleteBodyFrom
    func DeleteBodyFrom(urlString : String,parameters : Parameters ,authToken : String?,isLoader : Bool, loaderMessage : String, completion: @escaping (_ success: [String : AnyObject]?,_ error : Error?) -> Void)  {
        
        
         let reachability = try! Reachability()
         if reachability.connection != .unavailable {
             if isLoader{
                 Indicator.shared.startAnimating(withMessage: loaderMessage, colorType: UIColor.white, colorText:UIColor.white)
             }
    
        if let url = URL(string: urlString) {
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = HTTPMethod.delete.rawValue
                
            if authToken != nil{
                let bearer : String = "Bearer \(authToken!)"
                print(bearer)
                urlRequest.addValue(bearer, forHTTPHeaderField: "Authorization")
                urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            }
                
            AF.request(urlRequest).responseData { response in
                        
                if isLoader{
                    Indicator.shared.stopAnimating()
                }
                if let statusCode = response.response?.statusCode
                {
                    self.StatusCodeValue = statusCode
                    self.SessionEnd(code: self.StatusCodeValue)
                }
                switch response.result {
                case .success(let data):
                    do {
                        let asJSON = try JSONSerialization.jsonObject(with: data)
                        if let responseDictionary = asJSON as? [String: AnyObject] {
                            completion(responseDictionary, nil)
                        }
                        else{
                            Indicator.shared.stopAnimating()
                            completion(nil , response.error)
                        }
                    } catch {
                        Indicator.shared.stopAnimating()
                        completion(nil,response.error)
                    }
                case .failure(let error):
                    Indicator.shared.stopAnimating()
                    completion(nil,error)
                    break
                }
            }
        }
             else{
                 Indicator.shared.stopAnimating()
                 completion(nil,nil)
             }
         }
            else
            {
                Indicator.shared.stopAnimating()
                InternetConnectionAlert()
            }
    }
    
    
    func uploadImageRemote(urlString : String, image:UIImage,name:String,userID:String,key:String, callback:@escaping (_ data: String?, _ error: NSError? ) -> Void){
        
        let data = image.jpegData(compressionQuality: 0.1)
        if data == nil{
            print("data return nil")
            return
        }
        
        let token = accessToken()
        
        let bearer : String = "Bearer \(token )"
        
        let parameters = ["DriverId": userID]
        let headers: HTTPHeaders
        headers = ["Content-type": "multipart/form-data",
                   "Content-Disposition" : "form-data",
                   "Authorization": bearer]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append((value).data(using: String.Encoding.utf8)!, withName: key)
            }
            
            
            multipartFormData.append(data!, withName: key, fileName:name, mimeType: "image/jpeg")
            
        },to: URL.init(string: urlString)!, usingThreshold: UInt64.init(),
                  method: .post,
                  headers: headers).response{ response in
            
            if((response.error == nil)){
                do{
                    if let jsonData = response.data{
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        print(parsedData)
                        let dataImage = parsedData["data"] as? String
                        print(dataImage ?? "")
                        callback(dataImage , nil )
                        
                    }
                }catch{
                    print("error message")
                    callback("failure",nil)

                }
            }
            else{
                print(response.error ?? "")
                callback("failure",nil)

            }
        }
    }
    
    
    func uploadImageArray(urlString : String, pictures: [UIImage],name:String,userID:String, callback:@escaping (_ data: String?, _ error: NSError? ) -> Void){
        
        
        let token = accessToken()
        
        let bearer : String = "Bearer \(token )"
        
        let parameters = ["ProductId": userID]
        let headers: HTTPHeaders
        headers = ["Content-type": "multipart/form-data",
                   "Content-Disposition" : "form-data",
                   "Authorization": bearer]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                multipartFormData.append((value).data(using: String.Encoding.utf8)!, withName: key)
            }
            
            for i in 0..<pictures.count {
                if let imageData = pictures[i].jpegData(compressionQuality: 1) {
                            multipartFormData.append(imageData, withName: "Images", fileName: name, mimeType: "image/jpeg")
                        }
                    }

            
        },to: URL.init(string: urlString)!, usingThreshold: UInt64.init(),
                  method: .post,
                  headers: headers).response{ response in
            
            if((response.error == nil)){
                do{
                    if let jsonData = response.data{
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        print(parsedData)
                        let dataImage = "successfully"
                        print(dataImage)
                        callback(dataImage , nil )
                        
                    }
                }catch{
                    print("error message")
                    callback("failure",nil)

                }
            }
            else{
                print(response.error)
                callback("failure",nil)

            }
        }
    }
    
    func uploadAddFuelReceipt(parameters : [String : Any], image:UIImage,name:String,file:String,userID:Int, callback:@escaping (_ data: String?, _ isError: Bool ) -> Void){
            Indicator.shared.startAnimating(withMessage:"", colorType: UIColor.white, colorText:UIColor.white)
     
            let data = image.jpegData(compressionQuality: 0.5)
            
    
            let urlString = "BaseURL".AddOrUpdateFuelReceipt
            let token = accessToken()
            let bearer : String = "Bearer \(token )"
            let headers: HTTPHeaders
            headers = ["Content-type": "multipart/form-data",
                       "Content-Disposition" : "form-data",
                       "Authorization": bearer]
            
            AF.upload(multipartFormData: { (multipartFormData) in
                
                for (key, value) in parameters {
                    if let intValue = value as? Int {
                        multipartFormData.append("\(intValue)".data(using: .utf8)!, withName: key)
                    }
                    else if let intValue = value as? Double {
                        multipartFormData.append("\(intValue)".data(using: .utf8)!, withName: key)
                    }
                    else if let stringValue = value as? String {
                        multipartFormData.append(stringValue.data(using: .utf8)!, withName: key)
                    }
                }
                
                
                if data != nil{
                    multipartFormData.append(data!, withName:file, fileName:name, mimeType: "image/jpeg")
                }
                
            },to: URL.init(string: urlString)!, usingThreshold: UInt64.init(),
                      method: .post,
                      headers: headers).response{ response in
                
                if((response.error == nil)){
                    do{
                        if let jsonData = response.data{
                            
                            if let jsonString = String(data: jsonData, encoding: .utf8) {
                                            print("Response JSON String: \(jsonString)")
                                        } else {
                                            print("Failed to convert data to string.")
                                        }
                            
                            let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                            print(parsedData)
                            
                            let isSuccess = parsedData["isSuccess"] as? Int
                            if isSuccess == 1 {
                                Indicator.shared.stopAnimating()
                                callback("Fuel receipt updated successfully.", true )
                            }
                            else{
                                Indicator.shared.stopAnimating()
                                print(response.error ?? "failure")

                                callback("Something went wrong",false)
                            }
                        }
                    }catch{
                        print(response.error ?? "failure")
                        Indicator.shared.stopAnimating()
                        callback("Something went wrong",false)
                    }
                }
                else{
                    print(response.error ?? "failure")
                    Indicator.shared.stopAnimating()
                    callback("Something went wrong",false)
                }
            }
        }
    // MARK: - SessionEnd

    func SessionEnd(code:Int)
    {
        if code == 401
        {
            if let token = UserDefaults.standard.string(forKey: Constants.accessToken), !token.isEmpty {
                
                    let alert = UIAlertController(title: "Session Expired", message: "Please login again.", preferredStyle: .alert)
                    
                    let No = UIAlertAction(title: "OK", style: .default, handler: { action in
                       
                        UserDefaults.standard.removeObject(forKey: Constants.accessToken)
                        UserDefaults.standard.removeObject(forKey: Constants.login)
                        UserDefaults.standard.removeObject(forKey: Constants.userImg)
                        UserDefaults.standard.removeObject(forKey: Constants.firstName)
                        UserDefaults.standard.removeObject(forKey: Constants.lastName)
                        UserDefaults.standard.removeObject(forKey: Constants.email)
                        UserDefaults.standard.removeObject(forKey: Constants.phoneNumber)
                        UserDefaults.standard.removeObject(forKey: Constants.userImg)
                        RootControllerManager().SetRootViewController()
                        
                    })
                    alert.addAction(No)
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                }
            return
        }
    }
    
    // MARK: - InternetConnectionAlert
    func InternetConnectionAlert()
        {
            NotificationAlert().NotificationAlert(titles: "Oops, No Internet connection!")
        }
}


class Indicator: NSObject {
        static let shared = Indicator()
        var activityIndicator: NVActivityIndicatorView!
        var loadingOverlay: UIView?
 
        func startAnimating(withMessage : String, colorType : UIColor, colorText : UIColor) {
 
            if let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first?.windows
                .first(where: \.isKeyWindow) {
 
                let frame = CGRect(x: (window.bounds.width - 60) / 2,
                                           y: (window.bounds.height - 60) / 2,
                                           width: 60,
                                           height: 60)
                activityIndicator = NVActivityIndicatorView(frame: frame,
                                                             type: .ballPulse,
                                                             color: AppColor.AppThemeColor,
                                                             padding: 0)
                
                let overlay = UIView(frame: window.bounds)
                    overlay.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25)
                    overlay.isUserInteractionEnabled = true
                    overlay.tag = 999
                
                if loadingOverlay != nil {
                    loadingOverlay?.removeFromSuperview()
                    loadingOverlay = nil
                }
                overlay.addSubview(activityIndicator)
                window.addSubview(overlay)
                loadingOverlay = overlay
                activityIndicator.startAnimating()
        }
    }
    
    
    func stopAnimating(){
        
        if loadingOverlay != nil {
            loadingOverlay?.removeFromSuperview()
            loadingOverlay = nil
        }
        
        if activityIndicator != nil {
            activityIndicator.stopAnimating()
        }
        
    }
}
