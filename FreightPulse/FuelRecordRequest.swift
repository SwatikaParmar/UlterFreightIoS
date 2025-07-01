//
//  FuelRecordRequest.swift
//  FreightPulse
//
//  Created by Mac on 22/05/25.
//

import Foundation

class FuelRecordRequest: NSObject {
    
    static let shared = FuelRecordRequest()
    
    func FuelRecordRequestAPI(requestParams : [String:Any],_ isLoader:Bool, completion: @escaping (_ message : String?, _ status : Bool, _ dictionary : [FuelRecordData]?) -> Void) {
        
        var apiURL = String("".GetFuelReceipts)

        if requestParams["IsActive"] as? Int ?? 0 == 1 {
            apiURL = String(format: "%@PageNumber=1&PageSize=1000&FleetId=%d&loadId=%d&IsActive=true", apiURL, requestParams["FleetId"] as? Int ?? 0,requestParams["loadId"] as? Int ?? 0)
        }
        else{
            apiURL = String(format: "%@PageNumber=1&PageSize=1000&FleetId=%d&loadId=%d&IsActive=false", apiURL, requestParams["FleetId"] as? Int ?? 0,requestParams["loadId"] as? Int ?? 0)

        }
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
                        var homeListObject : [FuelRecordData] = []
                        if let dataList = data?["data"]?["dataList"] as? NSArray {
                            for list in dataList{
                                let dict : FuelRecordData =   FuelRecordData.init(dictionary: list as! [String : Any])
                                homeListObject.append(dict)
                            }
                            
                            completion(messageString,true,homeListObject)
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


class FuelRecordData: NSObject {
    var id: Int = 0
    var fleetId: Int = 0
    var fuelType: String = ""
    var fuelQuantity: Double = 0
    var fuelCost: Double = 0
    var odometerReading: Int = 0
    var fuelDate: String = ""
    var stationName: String = ""
    var notes: String = ""
    var fuelReceipt: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
    var jurisdiction: String = ""
    var taxRate: Double?
    var taxAmount: Double?
    var fuelUnit: String = ""

    init(dictionary: [String: Any]) {
        if let id = dictionary["id"] as? Int {
            self.id = id
        }
        if let fleetId = dictionary["fleetId"] as? Int {
            self.fleetId = fleetId
        }
        if let fuelType = dictionary["fuelType"] as? String {
            self.fuelType = fuelType
        }
        if let fuelQuantity = dictionary["fuelQuantity"] as? Double {
            self.fuelQuantity = fuelQuantity
        }
        if let fuelCost = dictionary["fuelCost"] as? Double {
            self.fuelCost = fuelCost
        }
        if let odometerReading = dictionary["odometerReading"] as? Int {
            self.odometerReading = odometerReading
        }
        if let fuelDate = dictionary["fuelDate"] as? String {
            self.fuelDate = fuelDate
        }
        if let stationName = dictionary["stationName"] as? String {
            self.stationName = stationName
        }
        if let notes = dictionary["notes"] as? String {
            self.notes = notes
        }
        if let fuelReceipt = dictionary["fuelReceipt"] as? String {
            self.fuelReceipt = fuelReceipt
        }
        if let createdAt = dictionary["createdAt"] as? String {
            self.createdAt = createdAt
        }
        if let updatedAt = dictionary["updatedAt"] as? String {
            self.updatedAt = updatedAt
        }
        if let jurisdiction = dictionary["jurisdiction"] as? String {
            self.jurisdiction = jurisdiction
        }
        if let taxRate = dictionary["taxRate"] as? Double {
            self.taxRate = taxRate
        }
        if let taxAmount = dictionary["taxAmount"] as? Double {
            self.taxAmount = taxAmount
        }
        if let fuelUnit = dictionary["fuelUnit"] as? String {
            self.fuelUnit = fuelUnit
        }
    }
}
