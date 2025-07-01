//
//  UpdateProfileRequest.swift
//  FreightPulse
//
//  Created by AbsolveTech on 25/10/24.
//

import Foundation
class UpdateProfileRequest: NSObject {
    
    static let shared = UpdateProfileRequest()
    func updateUser(requestParams : [String:Any], completion: @escaping (_ object: LoginObjectModel?,_ message : String?, _ status : Bool,_ accessToken:String) -> Void)
    {
        
        print("URL---->> ","BaseURL".AddUpdateDriverProfile)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.PostBodyForRawData(urlString: "BaseURL".AddUpdateDriverProfile, parameters: requestParams, authToken: accessToken(), isLoader: true, loaderMessage: "") { (data, error) in
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
                        if let Result = data?["data"] as? [String : Any]{
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


class GetProfileRequest: NSObject {

    static let shared = GetProfileRequest()
    
    func getProfileAPI(requestParams : [String:Any] ,_ isLoader:Bool, completion: @escaping (_ objectData: DriverDetail?,_ message : String?, _ isStatus : Bool) -> Void) {

        let apiURL = String(format: "%@/%@","BaseURL".GetDriverDetail, userId())
         
        print("URL---->> ",apiURL)
        print("Request---->> ",requestParams)
        
        AlamofireRequest.shared.GetBodyFrom(urlString:apiURL, parameters: requestParams, authToken:accessToken(), isLoader: isLoader, loaderMessage: "") { (data, error) in
                
                     print(data ?? "No data")
                     if error == nil{
                         var messageString : String = ""
                         if let status = data?["isSuccess"] as? Bool{
                             if let msg = data?["messages"] as? String{
                                 messageString = msg
                             }
                             if status{
                               
                                 if let dataList = data?["data"] as? [String:Any]{
                                       
                                     let driver : DriverDetail = DriverDetail.init(dict: dataList as [String : Any])
                                     saveDriverDetails(driver: driver)
                                     completion(driver,messageString,true)

                                 }
                                 else{
                                     completion(nil,messageString,true)
                                 }
                      
                             }else{
                                 NotificationAlert().NotificationAlert(titles: messageString)
                                 completion(nil,messageString,false)
                             }
                         }
                         else
                         {
                             completion(nil,"",false)
                         }
                    }
                    else
                        {
                            print(error ?? "No error")
                            if !(error?.localizedDescription.contains(GlobalConstants.timedOutError) ?? true) {
                                NotificationAlert().NotificationAlert(titles: GlobalConstants.serverError)
                            }
                        completion(nil,"",false)
                    }
                }
            }
        }


func saveDriverDetails(driver: DriverDetail) {
    do {
        let data = try NSKeyedArchiver.archivedData(withRootObject: driver, requiringSecureCoding: true)
        UserDefaults.standard.set(data, forKey: "DriverDetail")
        UserDefaults.standard.synchronize()
    } catch {
        print("Failed to archive DriverDetail: \(error)")
    }
}

func getDriverDetails() -> DriverDetail? {
    guard let data = UserDefaults.standard.data(forKey: "DriverDetail") else { return nil }
        do {
            let driver = try NSKeyedUnarchiver.unarchivedObject(ofClass: DriverDetail.self, from: data)
            return driver
        } catch {
            print("Failed to unarchive DriverDetail: \(error)")
            return nil
        }
    }

class DriverDetail: NSObject, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    
    var driverId: String
    var driverGender: String
    var driverName: String
    var address: String
    var dob: String
    var city: String
    var stateId: Int
    var countryId: Int
    var postalCode: String
    var licenseExpirationDate: String
    var licenseNumber: String
    var contactPhone: String
    var contactEmail: String
    var isOwnerOperator: Bool
    var isAvailable: Bool
    var lastServiceDate: String
    var isApproved: Bool
    var isActive: Bool
    var createdAt: String
    var dialCode: String
    var phoneNumber: String
    var email: String
    var driverImage : String
    var licenseDocumentId: String
    var licenseDocumentURL: String
    var state: String
    var country: String
    var loadFleetDetailId : Int = 0
    var fleetId : Int = 0
    var loadId : Int = 0

    // Initializer
    init(dict: [String: Any]) {
        self.state = dict["stateName"] as? String ?? ""
        self.country = dict["countryName"] as? String ?? ""
        self.loadFleetDetailId = dict["loadFleetDetailId"] as? Int ?? 0
        self.loadId = dict["loadId"] as? Int ?? 0
        self.fleetId = dict["fleetId"] as? Int ?? 0
        self.driverId = dict["driverId"] as? String ?? ""
        self.driverImage = dict["driverImage"] as? String ?? ""
        self.driverGender = dict["driverGender"] as? String ?? ""
        self.driverName = dict["driverName"] as? String ?? ""
        self.address = dict["address"] as? String ?? ""
        self.dob = dict["dob"] as? String ?? ""
        self.city = dict["city"] as? String ?? ""
        self.stateId = dict["stateId"] as? Int ?? 0
        self.countryId = dict["countryId"] as? Int ?? 0
        self.postalCode = dict["postalCode"] as? String ?? ""
        self.licenseDocumentId = dict["licenseDocumentId"] as? String ?? ""
        self.licenseExpirationDate = dict["licenseExpirationDate"] as? String ?? ""
        self.licenseNumber = dict["licenseNumber"] as? String ?? ""
        self.contactPhone = dict["contactPhone"] as? String ?? ""
        self.contactEmail = dict["contactEmail"] as? String ?? ""
        self.isOwnerOperator = dict["isOwnerOperator"] as? Bool ?? true
        self.isAvailable = dict["isAvailable"] as? Bool ?? true
        self.lastServiceDate = dict["lastServiceDate"]as? String ?? ""
        self.isApproved = dict["isApproved"] as? Bool ?? true
        self.isActive = dict["isActive"] as? Bool ?? true
        self.createdAt = dict["createdAt"] as? String ?? ""
        self.licenseDocumentURL = dict["licenseDocumentURL"] as? String ?? ""
        self.dialCode = dict["dialCode"] as? String ?? ""
        self.phoneNumber = dict["phoneNumber"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
    }
    
    // MARK: - NSSecureCoding
    required init?(coder aDecoder: NSCoder) {
        driverImage = aDecoder.decodeObject(of: NSString.self, forKey: "driverImage") as String? ?? ""
        licenseDocumentId = aDecoder.decodeObject(of: NSString.self, forKey: "licenseDocumentId") as String? ?? ""
        licenseDocumentURL = aDecoder.decodeObject(of: NSString.self, forKey: "licenseDocumentURL") as String? ?? ""
        state = aDecoder.decodeObject(of: NSString.self, forKey: "state") as String? ?? ""
        country = aDecoder.decodeObject(of: NSString.self, forKey: "country") as String? ?? ""
        driverId = aDecoder.decodeObject(of: NSString.self, forKey: "driverId") as String? ?? ""
        driverGender = aDecoder.decodeObject(of: NSString.self, forKey: "driverGender") as String? ?? ""
        driverName = aDecoder.decodeObject(of: NSString.self, forKey: "driverName") as String? ?? ""
        address = aDecoder.decodeObject(of: NSString.self, forKey: "address") as String? ?? ""
        dob = aDecoder.decodeObject(of: NSString.self, forKey: "dob") as String? ?? ""
        city = aDecoder.decodeObject(of: NSString.self, forKey: "city") as String? ?? ""
        stateId = aDecoder.decodeInteger(forKey: "stateId")
        countryId = aDecoder.decodeInteger(forKey: "countryId")
        postalCode = aDecoder.decodeObject(of: NSString.self, forKey: "postalCode") as String? ?? ""
        licenseExpirationDate = aDecoder.decodeObject(of: NSString.self, forKey: "licenseExpirationDate") as String? ?? ""
        licenseNumber = aDecoder.decodeObject(of: NSString.self, forKey: "licenseNumber") as String? ?? ""
        contactPhone = aDecoder.decodeObject(of: NSString.self, forKey: "contactPhone") as String? ?? ""
        contactEmail = aDecoder.decodeObject(of: NSString.self, forKey: "contactEmail") as String? ?? ""
        isOwnerOperator = aDecoder.decodeBool(forKey: "isOwnerOperator")
        isAvailable = aDecoder.decodeBool(forKey: "isAvailable")
        lastServiceDate = aDecoder.decodeObject(of: NSString.self, forKey: "lastServiceDate") as String? ?? ""
        isApproved = aDecoder.decodeBool(forKey: "isApproved")
        isActive = aDecoder.decodeBool(forKey: "isActive")
        createdAt = aDecoder.decodeObject(of: NSString.self, forKey: "createdAt") as String? ?? ""
        dialCode = aDecoder.decodeObject(of: NSString.self, forKey: "dialCode") as String? ?? ""
        phoneNumber = aDecoder.decodeObject(of: NSString.self, forKey: "phoneNumber") as String? ?? ""
        email = aDecoder.decodeObject(of: NSString.self, forKey: "email") as String? ?? ""
        loadFleetDetailId = aDecoder.decodeInteger(forKey: "loadFleetDetailId")
        fleetId = aDecoder.decodeInteger(forKey: "fleetId")
        loadId = aDecoder.decodeInteger(forKey: "loadId")
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(driverId, forKey: "driverId")
        aCoder.encode(driverGender, forKey: "driverGender")
        aCoder.encode(driverName, forKey: "driverName")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(dob, forKey: "dob")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(stateId, forKey: "stateId")
        aCoder.encode(countryId, forKey: "countryId")
        aCoder.encode(postalCode, forKey: "postalCode")
        aCoder.encode(licenseExpirationDate, forKey: "licenseExpirationDate")
        aCoder.encode(licenseNumber, forKey: "licenseNumber")
        aCoder.encode(contactPhone, forKey: "contactPhone")
        aCoder.encode(contactEmail, forKey: "contactEmail")
        aCoder.encode(isOwnerOperator, forKey: "isOwnerOperator")
        aCoder.encode(isAvailable, forKey: "isAvailable")
        aCoder.encode(lastServiceDate, forKey: "lastServiceDate")
        aCoder.encode(isApproved, forKey: "isApproved")
        aCoder.encode(isActive, forKey: "isActive")
        aCoder.encode(createdAt, forKey: "createdAt")
        aCoder.encode(dialCode, forKey: "dialCode")
        aCoder.encode(phoneNumber, forKey: "phoneNumber")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(driverImage, forKey: "driverImage")
        aCoder.encode(licenseDocumentId, forKey: "licenseDocumentId")
        aCoder.encode(licenseDocumentURL, forKey: "licenseDocumentURL")
        aCoder.encode(state, forKey: "state")
        aCoder.encode(country, forKey: "country")
        aCoder.encode(loadFleetDetailId, forKey: "loadFleetDetailId")
        aCoder.encode(fleetId, forKey: "fleetId")
        aCoder.encode(loadId, forKey: "loadId")
    }
}

