//
//  GetLoadDetailRequest.swift
//  FreightPulse
//
//  Created by Mac on 21/05/25.
//

import Foundation

class GetLoadDetailRequest: NSObject {
    
    static let shared = GetLoadDetailRequest()
    
    func GetLoadDetailRequestAPI(requestParams : [String:Any],_ isLoader:Bool, completion: @escaping (_ message : String?, _ status : Bool, _ dictionary : LoadDetailData?) -> Void) {
        
        var apiURL = String("".GetLoadDetails)

        apiURL = String(format: "%@?id=%d",apiURL,requestParams["id"] as? Int ?? 0)
        
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
                            let dict : LoadDetailData =   LoadDetailData.init(dictionary: dataList )
                            
                            
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

class LoadDetailData: NSObject {
    var loadId: Int = 0
    var shipperId: String = ""
    var brokerId: String?
    var pickupLocationLong: String = ""
    var pickupLocationLat: String = ""
    var pickupLocation: String = ""
    var deliveryLocationLong: String = ""
    var deliveryLocationLat: String = ""
    var deliveryLocation: String = ""
    var loadDetails: String = ""
    var pickupDate: String = ""
    var deliveryDate: String = ""
    var width: Int = 0
    var length: Int?
    var height: Int = 0
    var widthUnit: String?
    var lengthUnit: String?
    var heightUnit: String?
    var loadType: String = ""
    var weightValue: Int = 0
    var weightUnit: String = ""
    var isAvailable: Bool = false
    var status: String = ""
    var postedAt: String?
    var specialRequirements: String = ""
    var pickupTime: String = ""
    var deliveryTime: String = ""
    var prefferedVehicle: String = ""
    var isUrgent: Bool = false
    var targetPrice: Int = 0
    var finalPrice: Int = 0

    init(dictionary: [String: Any]) {
        if let loadId = dictionary["loadId"] as? Int {
            self.loadId = loadId
        }
        if let shipperId = dictionary["shipperId"] as? String {
            self.shipperId = shipperId
        }
        if let brokerId = dictionary["brokerId"] as? String {
            self.brokerId = brokerId
        }
        if let pickupLocationLong = dictionary["pickupLocationLong"] as? String {
            self.pickupLocationLong = pickupLocationLong
        }
        if let pickupLocationLat = dictionary["pickupLocationLat"] as? String {
            self.pickupLocationLat = pickupLocationLat
        }
        if let pickupLocation = dictionary["pickupLocation"] as? String {
            self.pickupLocation = pickupLocation
        }
        if let deliveryLocationLong = dictionary["deliveryLocationLong"] as? String {
            self.deliveryLocationLong = deliveryLocationLong
        }
        if let deliveryLocationLat = dictionary["deliveryLocationLat"] as? String {
            self.deliveryLocationLat = deliveryLocationLat
        }
        if let deliveryLocation = dictionary["deliveryLocation"] as? String {
            self.deliveryLocation = deliveryLocation
        }
        if let loadDetails = dictionary["loadDetails"] as? String {
            self.loadDetails = loadDetails
        }
        if let pickupDate = dictionary["pickupDate"] as? String {
            self.pickupDate = pickupDate
        }
        if let deliveryDate = dictionary["deliveryDate"] as? String {
            self.deliveryDate = deliveryDate
        }
        if let width = dictionary["width"] as? Int {
            self.width = width
        }
        if let length = dictionary["length"] as? Int {
            self.length = length
        }
        if let height = dictionary["height"] as? Int {
            self.height = height
        }
        if let widthUnit = dictionary["widthUnit"] as? String {
            self.widthUnit = widthUnit
        }
        if let lengthUnit = dictionary["lengthUnit"] as? String {
            self.lengthUnit = lengthUnit
        }
        if let heightUnit = dictionary["heightUnit"] as? String {
            self.heightUnit = heightUnit
        }
        if let loadType = dictionary["loadType"] as? String {
            self.loadType = loadType
        }
        if let weightValue = dictionary["weightValue"] as? Int {
            self.weightValue = weightValue
        }
        if let weightUnit = dictionary["weightUnit"] as? String {
            self.weightUnit = weightUnit
        }
        if let isAvailable = dictionary["isAvailable"] as? Bool {
            self.isAvailable = isAvailable
        }
        if let status = dictionary["status"] as? String {
            self.status = status
        }
        if let postedAt = dictionary["postedAt"] as? String {
            self.postedAt = postedAt
        }
        if let specialRequirements = dictionary["specialRequirements"] as? String {
            self.specialRequirements = specialRequirements
        }
        if let pickupTime = dictionary["pickupTime"] as? String {
            self.pickupTime = pickupTime
        }
        if let deliveryTime = dictionary["deliveryTime"] as? String {
            self.deliveryTime = deliveryTime
        }
        if let prefferedVehicle = dictionary["prefferedVehicle"] as? String {
            self.prefferedVehicle = prefferedVehicle
        }
        if let isUrgent = dictionary["isUrgent"] as? Bool {
            self.isUrgent = isUrgent
        }
        if let targetPrice = dictionary["targetPrice"] as? Int {
            self.targetPrice = targetPrice
        }
        if let finalPrice = dictionary["finalPrice"] as? Int {
            self.finalPrice = finalPrice
        }
    }
}
