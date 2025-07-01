//
//  GetFleetDetailRequest.swift
//  FreightPulse
//
//  Created by Mac on 20/05/25.
//

import Foundation

class GetFleetDetailRequest: NSObject {
    
    static let shared = GetFleetDetailRequest()
    
    func GetFleetDetailRequestAPI(requestParams : [String:Any],_ isLoader:Bool, completion: @escaping (_ message : String?, _ status : Bool, _ dictionary : FleetDetailData?) -> Void) {
        
        var apiURL = String("".GetFleetDetail)

        apiURL = String(format: "%@/%d", apiURL,requestParams["fleetId"] as? Int ?? 0)
        
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
                            let dict : FleetDetailData = FleetDetailData.init(dictionary: dataList )
                            
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

class FleetDetailData: NSObject {
    var fleetId: Int = 0
    var driverId: String = ""
    var driverName: String?
    var carrierId: String = ""
    var vehicleName: String = ""
    var vehicleType: String = ""
    var vehicleIdentificationNumber: String = ""
    var makeYear: String = ""
    var model: String = ""
    var licensePlate: String = ""
    var fuelType: String = ""
    var registrationExpirationDate: String = ""
    var insuranceExpirationDate: String = ""
    var lastMaintenanceDate: String = ""
    var registrationDocumentId: String?
    var insuranceDocumentId: String?
    var isAvailable: Bool = false
    var capacityValue: Int = 0
    var capacityUnit: String = ""
    var capacityType: String = ""
    var currentLocationLat: String = ""
    var currentLocationLong: String = ""
    var createdAt: String = ""
    var updatedAt: String = ""
    var registrationDocumentStatus: String?
    var registrationDocumentUrl: String?
    var insuranceDocumentStatus: String?
    var insuranceDocumentUrl: String?

    init(dictionary: [String: Any]) {
        if let fleetId = dictionary["fleetId"] as? Int {
            self.fleetId = fleetId
        }
        if let driverId = dictionary["driverId"] as? String {
            self.driverId = driverId
        }
        if let driverName = dictionary["driverName"] as? String {
            self.driverName = driverName
        }
        if let carrierId = dictionary["carrierId"] as? String {
            self.carrierId = carrierId
        }
        if let vehicleName = dictionary["vehicleName"] as? String {
            self.vehicleName = vehicleName
        }
        if let vehicleType = dictionary["vehicleType"] as? String {
            self.vehicleType = vehicleType
        }
        if let vin = dictionary["vehicleIdentificationNumber"] as? String {
            self.vehicleIdentificationNumber = vin
        }
        if let makeYear = dictionary["makeYear"] as? String {
            self.makeYear = makeYear
        }
        if let model = dictionary["model"] as? String {
            self.model = model
        }
        if let licensePlate = dictionary["licensePlate"] as? String {
            self.licensePlate = licensePlate
        }
        if let fuelType = dictionary["fuelType"] as? String {
            self.fuelType = fuelType
        }
        if let regExp = dictionary["registrationExpirationDate"] as? String {
            self.registrationExpirationDate = regExp
        }
        if let insExp = dictionary["insuranceExpirationDate"] as? String {
            self.insuranceExpirationDate = insExp
        }
        if let maintenanceDate = dictionary["lastMaintenanceDate"] as? String {
            self.lastMaintenanceDate = maintenanceDate
        }
        if let regDocId = dictionary["registrationDocumentId"] as? String {
            self.registrationDocumentId = regDocId
        }
        if let insDocId = dictionary["insuranceDocumentId"] as? String {
            self.insuranceDocumentId = insDocId
        }
        if let isAvailable = dictionary["isAvailable"] as? Bool {
            self.isAvailable = isAvailable
        }
        if let capacityValue = dictionary["capacityValue"] as? Int {
            self.capacityValue = capacityValue
        }
        if let capacityUnit = dictionary["capacityUnit"] as? String {
            self.capacityUnit = capacityUnit
        }
        if let capacityType = dictionary["capacityType"] as? String {
            self.capacityType = capacityType
        }
        if let currentLocationLat = dictionary["currentLocationLat"] as? String {
            self.currentLocationLat = currentLocationLat
        }
        if let currentLocationLong = dictionary["currentLocationLong"] as? String {
            self.currentLocationLong = currentLocationLong
        }
        if let createdAt = dictionary["createdAt"] as? String {
            self.createdAt = createdAt
        }
        if let updatedAt = dictionary["updatedAt"] as? String {
            self.updatedAt = updatedAt
        }
        if let regDocStatus = dictionary["registrationDocumentStatus"] as? String {
            self.registrationDocumentStatus = regDocStatus
        }
        if let regDocUrl = dictionary["registrationDocumentUrl"] as? String {
            self.registrationDocumentUrl = regDocUrl
        }
        if let insDocStatus = dictionary["insuranceDocumentStatus"] as? String {
            self.insuranceDocumentStatus = insDocStatus
        }
        if let insDocUrl = dictionary["insuranceDocumentUrl"] as? String {
            self.insuranceDocumentUrl = insDocUrl
        }
    }
}
