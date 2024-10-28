//
//  HomeRequestAPI.swift
//  FreightPulse
//
//  Created by AbsolveTech on 25/10/24.
//

import UIKit

class HomeRequestAPI: NSObject {

}
class UpdateDriverAvailabilityRequest: NSObject {
    
    static let shared = UpdateDriverAvailabilityRequest()
    func UpdateDriverAvailabilityAPI(requestParams : [String:Any], completion: @escaping (_ object: LoginObjectModel?,_ message : String?, _ status : Bool,_ accessToken:String) -> Void)
    {
        
        print("URL---->> ","BaseURL".UpdateDriverAvailability)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString: "BaseURL".UpdateDriverAvailability, parameters: requestParams, authToken: accessToken(), isLoader: false, loaderMessage: "") { (data, error) in
            if error == nil{
                print("*************************************************")
                print(data ?? "No data")
                if let status = data?["isSuccess"] as? Bool
                {
                    
                    var messageString : String = ""
                    
                    if let msg = data?["messages"] as? String{
                        messageString = msg
                    }
                    
                    if status
                    {
                        completion(nil, messageString, status, "")

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
