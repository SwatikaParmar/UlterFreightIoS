//
//  UpdateFleetRequest.swift
//  FreightPulse
//
//  Created by AbsolveTech on 11/06/25.
//

import Foundation
class UpdateFleetRequest: NSObject {
    
    static let shared = UpdateFleetRequest()
    func updateFleet(requestParams : [String:Any], completion: @escaping (_ id: Int,_ message : String?, _ status : Bool,_ accessToken:String) -> Void)
    {
        
        print("URL---->> ","BaseURL".AddUpdateFleet)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString: "BaseURL".AddUpdateFleet, parameters: requestParams, authToken: accessToken(), isLoader: true, loaderMessage: "") { (data, error) in
            if error == nil{
                print("*************************************************")
                print(data ?? "No data")
                if let status = data?["isSuccess"] as? Bool
                {
                    
                    var messageString : String = ""
                    if let msg = data?["messages"] as? String{
                        messageString = msg
                    }
                    
                    if status == true
                    {
                        if let id = data?["data"]?["fleetId"] as? Int{
                            completion(id, messageString, status, "")
                        }
                        else{
                            completion(0, messageString, status, "")

                        }
                    }
                    else
                    {
                        completion(0, messageString, status,"")
                    }
                }
                else
                {
                    completion(0, GlobalConstants.serverError, false,"")
                }
            }
            else{
                completion(0,GlobalConstants.serverError, false,"")
            }
        }
    }
}
class GetFleetListRequest: NSObject {
    
    static let shared = GetFleetListRequest()
    
    func GetFleetListRequestAPI(requestParams : [String:Any],_ isLoader:Bool, completion: @escaping (_ message : String?, _ status : Bool, _ dictionary : [FleetVehicle]?) -> Void) {
        
        var apiURL = String("".GetFleetList)

        apiURL = String(format: "%@?DriverId=%@", apiURL,userId())
        
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
                        var homeListObject : [FleetVehicle] = []
                        if let dataList = data?["data"] as? NSArray{
                            for list in dataList{
                                let dict : FleetVehicle =  FleetVehicle.init(dict: list as! [String : Any])
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
class FleetVehicle: NSObject {
    var capacityUnit: String?
    var capacityValue: Int = 0
    var carrierId: String?
    var driverId: String?
    var driverName: String?
    var fleetId: Int = 0
    var fleetImage: String?
    var isAvailable: Bool = false
    var licensePlate: String?
    var vehicleName: String?
    var vehicleType: String?
    
    init(dict: [String: Any]) {
        self.capacityUnit = dict["capacityUnit"] as? String
        self.capacityValue = dict["capacityValue"] as? Int ?? 0
        self.carrierId = dict["carrierId"] as? String
        self.driverId = dict["driverId"] as? String
        self.driverName = dict["driverName"] as? String
        self.fleetId = dict["fleetId"] as? Int ?? 0
        self.fleetImage = dict["fleetImage"] as? String
        self.isAvailable = (dict["isAvailable"] as? Int == 1)
        self.licensePlate = dict["licensePlate"] as? String
        self.vehicleName = dict["vehicleName"] as? String
        self.vehicleType = dict["vehicleType"] as? String
    }
}
