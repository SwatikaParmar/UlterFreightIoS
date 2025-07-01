//
//  NotificationDataRequest.swift
//  FreightPulse
//
//  Created by Mac on 23/05/25.
//

import Foundation

class NotificationDataRequest: NSObject {
    
    static let shared = NotificationDataRequest()
    
    func NotificationDataRequestAPI(requestParams : [String:Any],_ isLoader:Bool, completion: @escaping (_ message : String?, _ status : Bool, _ dictionary : NotificationData?) -> Void) {
        
        var apiURL = String("".getNotificationList)

        apiURL = String(format: "%@PageNumber=1&PageSize=100",apiURL,requestParams["id"] as? Int ?? 0)
        
        print("URL---->> ",apiURL)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: [:], authToken:nil, isLoader: isLoader, loaderMessage: "") { (data, error) in
            
            print("*************************************************")
            print(data ?? "No data")
            
            if error == nil{
                var messageString : String = ""
                if let status = data?["isSuccess"] as? Int{
                    if let msg = data?["message"] as? String{
                        messageString = msg
                    }
                    if status == 1 {
                        if let dataList = data?["data"] as? [String : Any]{
                            let dict : NotificationData =  NotificationData.init(dictionary: dataList )
                            
                            completion(messageString,true,dict)
                        }else{
                            completion(messageString, false,nil)
                        }
                    }
                    else
                    {
                        NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                        completion(GlobalConstants.serverError, false,nil)
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

class NotificationResponse: NSObject {
    var statusCode: Int = 0
    var isSuccess: Bool = false
    var messages: String = ""
    var data: NotificationData?

    init(dict: [String: Any]) {
        super.init()
        self.statusCode = dict["statusCode"] as? Int ?? 0
        self.isSuccess = dict["isSuccess"] as? Bool ?? false
        self.messages = dict["messages"] as? String ?? ""

        if let dataDict = dict["data"] as? [String: Any] {
            self.data = NotificationData(dictionary: dataDict)
        }
    }
}

class NotificationData: NSObject {
    var totalCount: Int = 0
    var pageSize: Int = 0
    var currentPage: Int = 0
    var totalPages: Int = 0
    var previousPage: String = ""
    var nextPage: String = ""
    var searchQuery: String = ""
    var dataList: [Any] = []

    init(dictionary: [String: Any]) {
        super.init()
        self.totalCount = dictionary["totalCount"] as? Int ?? 0
        self.pageSize = dictionary["pageSize"] as? Int ?? 0
        self.currentPage = dictionary["currentPage"] as? Int ?? 0
        self.totalPages = dictionary["totalPages"] as? Int ?? 0
        self.previousPage = dictionary["previousPage"] as? String ?? ""
        self.nextPage = dictionary["nextPage"] as? String ?? ""
        self.searchQuery = dictionary["searchQuery"] as? String ?? ""
        self.dataList = dictionary["dataList"] as? [Any] ?? []
    }
}
