//
//  StateListAPIRequest.swift
//  FreightPulse
//
//  Created by Mac on 20/05/25.
//

import Foundation

class DocumentListRequest: NSObject {
    
    static let shared = DocumentListRequest()
    
    func DocumentListRequestAPI(requestParams : Int,_ isLoader:Bool, completion: @escaping (_ message : String?, _ status : Bool, _ dictionary : [DocumentDataArray]?) -> Void) {
        
        var apiURL = String("".GetDriverDocuments)

        apiURL = String(format: "%@%@", apiURL,userId())
        
        print("URL---->> ",apiURL)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: [:], authToken:nil, isLoader: isLoader, loaderMessage: "") { (data, error) in
            
            print("*************************************************")
            print(data ?? "No data")
            
            if error == nil{
                var messageString : String = GlobalConstants.serverError
                if let status = data?["isSuccess"] as? Int{
                    if let msg = data?["messages"] as? String{
                        messageString = msg
                    }
                    if status == 1 {
                        var homeListObject : [DocumentDataArray] = []
                        if let dataList = data?["data"] as? NSArray{
                            for list in dataList{
                                let dict : DocumentDataArray =   DocumentDataArray.init(dictionary: list as! [String : Any])
                                homeListObject.append(dict)
                            }
                            
                            completion(messageString,true,homeListObject)
                        }else{
                            completion(messageString, false,nil)
                        }
                    }
                    else
                    {
                        NotificationAlert().NotificationAlert(titles: messageString)
                        completion(messageString, false,nil)
                    }
                }
                else
                {
                    NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                    completion(GlobalConstants.serverError, false,nil)
                }
            }
        }
    }
    
}


class DocumentDataArray: NSObject {
    var documentId: Int = 0
    var userId: String = ""
    var documentName: String = ""
    var status: String = ""
    var documentUrl: String = ""
    var createdAt: String = ""

    init(dictionary: [String: Any]) {
        if let documentId = dictionary["documentId"] as? Int {
            self.documentId = documentId
        }
        if let userId = dictionary["userId"] as? String {
            self.userId = userId
        }
        if let documentType = dictionary["documentName"] as? String {
            self.documentName = documentType
        }
        if let status = dictionary["status"] as? String {
            self.status = status
        }
        if let documentUrl = dictionary["documentUrl"] as? String {
            self.documentUrl = documentUrl
        }
        if let createdAt = dictionary["createdAt"] as? String {
            self.createdAt = createdAt
        }
    }
}
