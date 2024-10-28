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
                    var accessToken : String = ""
                    
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


class DriverDetails: NSObject {
    var driverId: String
    var driverImage: String?
    var driverGender: String
    var driverName: String
    var address: String
    var dob: String
    var city: String
    var stateId: Int
    var countryId: Int
    var postalCode: String
    var licenseDocumentId: String?
    var licenseExpirationDate: String
    var licenseNumber: String
    var contactPhone: String
    var contactEmail: String
    var isOwnerOperator: Bool
    var fleetId: String?
    var isAvailable: Bool
    var lastServiceDate: String
    var isApproved: Bool
    var isActive: Bool
    var createdAt: String
    var updatedAt: String?
    var licenseDocumentURL: String?
    var licenseDocumentStatus: String?
    var driverOnboardingDocumentUrl: String?
    var dialCode: String
    var phoneNumber: String
    var email: String
    init(dict: [String: Any]) {

        
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
        self.fleetId = dict["fleetId"] as? String ?? ""
        self.isAvailable = dict["isAvailable"] as? Bool ?? true
        self.lastServiceDate = dict["lastServiceDate"]as? String ?? ""
        self.isApproved = dict["isApproved"] as? Bool ?? true
        self.isActive = dict["isActive"] as? Bool ?? true
        self.createdAt = dict["createdAt"] as? String ?? ""
        self.updatedAt = dict["updatedAt"] as? String ?? ""
        self.licenseDocumentURL = dict["licenseDocumentURL"] as? String ?? ""
        self.licenseDocumentStatus = dict["licenseDocumentStatus"] as? String ?? ""
        self.driverOnboardingDocumentUrl = dict["driverOnboardingDocumentUrl"] as? String ?? ""
        self.dialCode = dict["dialCode"] as? String ?? ""
        self.phoneNumber = dict["phoneNumber"] as? String ?? ""
        self.email = dict["email"] as? String ?? ""
    }
}
func saveDriverDetails(driver: DriverDetail) {
    let defaults = UserDefaults.standard
    let driverData = NSKeyedArchiver.archivedData(withRootObject: driver)
    defaults.set(driverData, forKey: "DriverDetails")
}
func getDriverDetails() -> DriverDetail? {
    let defaults = UserDefaults.standard
    if let driverData = defaults.object(forKey: "DriverDetails") as? Data {
        if let driver = NSKeyedUnarchiver.unarchiveObject(with: driverData) as? DriverDetail {
            return driver
        }
    }
    return nil
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


class DriverDetail: NSObject, NSCoding {
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
    // Initializer
    init(dict: [String: Any]) {

        self.state = dict["stateName"] as? String ?? ""
        self.country = dict["countryName"] as? String ?? ""
        
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
    
    // MARK: - NSCoding
    required init?(coder aDecoder: NSCoder) {
        driverImage = aDecoder.decodeObject(forKey: "driverImage") as? String ?? ""
        licenseDocumentId = aDecoder.decodeObject(forKey: "licenseDocumentId") as? String ?? ""
        licenseDocumentURL = aDecoder.decodeObject(forKey: "licenseDocumentURL") as? String ?? ""

        state = aDecoder.decodeObject(forKey: "stateName") as? String ?? ""
        country = aDecoder.decodeObject(forKey: "countryName") as? String ?? ""
        
        driverId = aDecoder.decodeObject(forKey: "driverId") as? String ?? ""
        driverGender = aDecoder.decodeObject(forKey: "driverGender") as? String ?? ""
        driverName = aDecoder.decodeObject(forKey: "driverName") as? String ?? ""
        address = aDecoder.decodeObject(forKey: "address") as? String ?? ""
        dob = aDecoder.decodeObject(forKey: "dob") as? String ?? ""
        city = aDecoder.decodeObject(forKey: "city") as? String ?? ""
        stateId = aDecoder.decodeInteger(forKey: "stateId")
        countryId = aDecoder.decodeInteger(forKey: "countryId")
        postalCode = aDecoder.decodeObject(forKey: "postalCode") as? String ?? ""
        licenseExpirationDate = aDecoder.decodeObject(forKey: "licenseExpirationDate") as? String ?? ""
        licenseNumber = aDecoder.decodeObject(forKey: "licenseNumber") as? String ?? ""
        contactPhone = aDecoder.decodeObject(forKey: "contactPhone") as? String ?? ""
        contactEmail = aDecoder.decodeObject(forKey: "contactEmail") as? String ?? ""
        isOwnerOperator = aDecoder.decodeBool(forKey: "isOwnerOperator")
        isAvailable = aDecoder.decodeBool(forKey: "isAvailable")
        lastServiceDate = aDecoder.decodeObject(forKey: "lastServiceDate") as? String ?? ""
        isApproved = aDecoder.decodeBool(forKey: "isApproved")
        isActive = aDecoder.decodeBool(forKey: "isActive")
        createdAt = aDecoder.decodeObject(forKey: "createdAt") as? String ?? ""
        dialCode = aDecoder.decodeObject(forKey: "dialCode") as? String ?? ""
        phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as? String ?? ""
        email = aDecoder.decodeObject(forKey: "email") as? String ?? ""
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
        
       
    }
}
