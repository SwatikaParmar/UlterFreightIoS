//
//  Constants.swift
//  
//
//  Created by AbsolveTech on 12/07/24.
//

import Foundation
import UIKit


struct Constants {
    
    static let deviceToken = "deviceToken"
    static let accessToken = "accessToken"
    static let userId = "userId"
    static let userType = "userType"
    static let phoneNumber = "phoneNumber"
    static let phoneCode = "phoneCode"
    static let email = "email"
    static let name = "name"
    static let firstName = "firstName"
    static let lastName = "lastName"
    static let userImg = "userImg"
    static let fcmToken = "fcmToken"
    static let status = "status"
    static let ProfileImg = "ProfileImg"
    static let otp = "otp"
    static let phoneOtp = "phoneOtp"
    static let city = "city"
    static let guestUser = "guestUser"
    static let gender = "gender"
    static let login = "LoginBool"
    static let stateName = "stateName"


}

public var typeDelivered = "PickedUp"


public func accessToken() -> String
{
    return UserDefaults.standard.string(forKey: Constants.accessToken) ?? ""
}

public func userId() -> String
{
    return UserDefaults.standard.string(forKey: Constants.userId) ?? ""
}



class FontName{
    struct Inter {
        static let Bold = "Poppins-Bold"
        static let SemiBold = "Poppins-SemiBold"
        static let Regular = "Poppins-Regular"
        static let Medium = "Poppins-Medium"
    }
   
}


class AppColor: NSObject {
    
    static let AppThemeColorCG : CGColor = UIColor(red: 15 / 255.0, green: 82.0 / 255.0, blue: 186.0 / 255.0, alpha: 1.0).cgColor
    static let AppThemeColor : UIColor =  UIColor(red: 15 / 255.0, green: 82.0 / 255.0, blue: 186.0 / 255.0, alpha: 1.0)
    
    static let BrownColor : UIColor =  UIColor(red: 183.0 / 255.0, green: 137.0 / 255.0, blue: 69.0 / 255.0, alpha: 1.0)
    static let BlackColor : UIColor =  UIColor(red: 38.0 / 255.0, green: 50.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0)
    static let AppTealishRGB : UIColor =  UIColor(red: 197.0 / 255.0, green: 154.0 / 255.0, blue: 86.0 / 255.0, alpha: 1.0)
    static let Timebg : UIColor =  UIColor(red: 243.0 / 255.0, green: 243.0 / 255.0, blue: 243.0 / 255.0, alpha: 1.0)
    static let YellowColor : UIColor = UIColor( red: CGFloat(197/255.0), green: CGFloat(154/255.0), blue: CGFloat(86/255.0), alpha: CGFloat(1.0) )
    static let AppThemeColorPro : UIColor =  UIColor(red: 183 / 255.0, green: 137.0 / 255.0, blue: 69.0 / 255.0, alpha: 1.0)

}

enum Language : String{
    case English = "en"
    
}

struct GlobalConstants {
    
    static let serverError = "There was an error connecting to server."
    static let timedOutError = "The request timed out."
    static let oopsError = "Oops!"
    static let successMessage = "SUCCESS!"
    
    static let MalePlaceHolding: String = "placeholder_Male"
    static let FemalePlaceHolding: String = "placeholder_FeMale"
    static let OtherPlaceHolding: String = "placeholder_Male"
    
   // static let GoogleWebAPIKey = "AIzaSyBgLMQ8wvy5yda0qP1_8y1e_aJJ_HrTdZw"
    static let GoogleWebAPIKey = "AIzaSyCn4NaEzeh7g-qW7xtkYewa8xv7LI1cdwU"
    static let BASE_IMAGE_URL = "https://portavoy.s3.us-east-2.amazonaws.com/"
}
extension String{
    
    static let LiveBaseURL = "https://d12jvf41ix7qm4.cloudfront.net/api/"
    
    var path: String{
        return .LiveBaseURL
    }
    
    var LoginURL: String{
        return "Path".path + "Auth/Login"
    }
    var ChangePassword: String{
        return "Path".path + "Auth/ChangePassword"
    }
    var EmailOTP: String{
        return "Path".path + "Auth/EmailOTP"
    }
    
    var ResetPassword: String{
        return "Path".path + "Auth/ResetPassword"
    }
    
    var SignUpURL: String{
        return "Path".path + "Auth/Register"
    }
    
    var GetStates: String{
        return "Path".path + "Content/GetStates"
    }
    
    var GetAllJurisdictions: String{
        return "Path".path + "Admin/GetAllJurisdictions"
    }
    
    var CountriesList: String{
        return "Path".path + "Content/GetCountries"
    }
    
    var AddUpdateDriverProfile: String{
        return "Path".path + "Driver/AddUpdateDriverProfile"
    }
    
    var UploadDriverProfilePic: String{
        return "Path".path + "Driver/UploadDriverProfilePic"
    }
    
    var UploadDriverLicenseDocument: String{
        return "Path".path + "Driver/UploadDriverLicenseDocument"
    }
    
    var GetDriverDetail: String{
        return "Path".path + "Driver/GetDriverDetail"
    }
    
    var UpdateDriverAvailability: String{
        return "Path".path + "Driver/UpdateDriverAvailability"
    }
    
    var getNotificationList: String{
        return "Path".path + "Notification/getNotificationList"
    }
    
    var GetDriverDocuments: String{
        return "Path".path + "Driver/GetDriverDocuments?driverId="
    }
    
    var GetDriverLoads: String{
        return "Path".path + "Driver/GetDriverLoads?driverId="
    }
    
    var UpdateLoadTrackingStatus: String{
        return "Path".path + "Carrier/UpdateLoadTrackingStatus"
    }
    
    var GetFleetDetail: String{
        return "Path".path + "Carrier/GetFleetDetail"
    }
    
    var GetLoadDetails: String{
        return "Path".path + "Shipper/GetLoadDetails"
    }
    
    var AddOrUpdateFuelReceipt: String{
        return "Path".path + "Driver/AddOrUpdateFuelReceipt"
    }
    
    var GetFuelReceipts: String{
        return "Path".path + "Driver/GetFuelReceipts?"
    }
    
    var UploadFleetInsuranceCertificate: String{
        return "Path".path + "Carrier/UploadFleetInsuranceCertificate"
    }
    
    var AddUpdateFleet: String{
        return "Path".path + "Carrier/AddUpdateFleet"
    }
    
    var GetFleetList: String{
        return "Path".path + "Carrier/GetFleetList"
    }
    
    
}
