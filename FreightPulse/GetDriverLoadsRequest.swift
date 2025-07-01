//
//  GetDriverLoadsRequest.swift
//  FreightPulse
//
//  Created by Mac on 20/05/25.
//


import Foundation

class GetDriverLoadsRequest: NSObject {
    
    static let shared = GetDriverLoadsRequest()
    
    func GetDriverLoadsRequestAPI(requestParams : [String:Any],_ isLoader:Bool, completion: @escaping (_ message : String?, _ status : Bool, _ dictionary : [DriverLoadsArray]?) -> Void) {
        
        var apiURL = String("".GetDriverLoads)

        apiURL = String(format: "%@%@&type=%@&pageNumber=1&pageSize=100", apiURL,userId(),requestParams["type"] as? String ?? "")
        
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
                        var homeListObject : [DriverLoadsArray] = []
                        if let dataList = data?["data"]?["records"] as? NSArray{
                            for list in dataList{
                                let dict : DriverLoadsArray =   DriverLoadsArray.init(dictionary: list as! [String : Any])
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


class DriverLoadsArray: NSObject {
    var currentLat: String?
    var currentLong: String?
    var deliveryDate: String = ""
    var deliveryLocation: String = ""
    var deliveryLocationLat: String = ""
    var deliveryLocationLong: String = ""
    var deliveryTime: String = ""
    var fleetId: Int = 0
    var loadFleetDetailId: Int = 0
    var loadStatus: String = ""
    var pickupDate: String = ""
    var pickupLocation: String = ""
    var pickupLocationLat: String = ""
    var pickupLocationLong: String = ""
    var pickupTime: String = ""
    var trackingStatus: String = ""
    var loadId = 0

    init(dictionary: [String: Any]) {
        
        if let loadId = dictionary["loadId"] as? Int {
            self.loadId = loadId
        }
        
        if let currentLat = dictionary["currentLat"] as? String {
            self.currentLat = currentLat
        }
        if let currentLong = dictionary["currentLong"] as? String {
            self.currentLong = currentLong
        }
        if let deliveryDate = dictionary["deliveryDate"] as? String {
            self.deliveryDate = deliveryDate
        }
        if let deliveryLocation = dictionary["deliveryLocation"] as? String {
            self.deliveryLocation = deliveryLocation
        }
        if let deliveryLocationLat = dictionary["deliveryLocationLat"] as? String {
            self.deliveryLocationLat = deliveryLocationLat
        }
        if let deliveryLocationLong = dictionary["deliveryLocationLong"] as? String {
            self.deliveryLocationLong = deliveryLocationLong
        }
        if let deliveryTime = dictionary["deliveryTime"] as? String {
            self.deliveryTime = deliveryTime
        }
        if let fleetId = dictionary["fleetId"] as? Int {
            self.fleetId = fleetId
        }
        if let loadFleetDetailId = dictionary["loadFleetDetailId"] as? Int {
            self.loadFleetDetailId = loadFleetDetailId
        }
        if let loadStatus = dictionary["loadStatus"] as? String {
            self.loadStatus = loadStatus
        }
        if let pickupDate = dictionary["pickupDate"] as? String {
            self.pickupDate = pickupDate
        }
        if let pickupLocation = dictionary["pickupLocation"] as? String {
            self.pickupLocation = pickupLocation
        }
        if let pickupLocationLat = dictionary["pickupLocationLat"] as? String {
            self.pickupLocationLat = pickupLocationLat
        }
        if let pickupLocationLong = dictionary["pickupLocationLong"] as? String {
            self.pickupLocationLong = pickupLocationLong
        }
        if let pickupTime = dictionary["pickupTime"] as? String {
            self.pickupTime = pickupTime
        }
        if let trackingStatus = dictionary["trackingStatus"] as? String {
            self.trackingStatus = trackingStatus
        }
    }
}

class UpdateLoadTrackingStatusRequest: NSObject {
    
    static let shared = UpdateLoadTrackingStatusRequest()
    func UpdateLoadTrackingStatusAPI(requestParams : [String:Any], completion: @escaping (_ object: LoginObjectModel?,_ message : String?, _ status : Bool,_ accessToken:String) -> Void)
    {
        
        print("URL---->> ","BaseURL".UpdateLoadTrackingStatus)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString: "BaseURL".UpdateLoadTrackingStatus, parameters: requestParams, authToken: accessToken(), isLoader: false, loaderMessage: "") { (data, error) in
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
