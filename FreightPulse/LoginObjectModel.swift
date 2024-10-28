//
//  LoginObjectModel.swift
//  FreightPulse
//
//  Created by AbsolveTech on 22/10/24.
//

import UIKit


class LoginObjectModel : NSObject, NSCoding {
    
    
    var accessToken: String?
    var email: String?
    var firstName = ""
    var lastName  = ""
    var isSocialUser = Bool()
    var smsNotificationStatus = Bool()
    var emailNotificationStatus = Bool()
    var pic = ""
    var LoginStatus = ""
    var isIntro: Bool?
    var timeZone = ""
    var timeZoneCode = ""
    var timeZoneId = 0
    var timeZoneUTCOffset =  ""
    var percentageProfileComplete = 0
    var city = ""
    var country = ""
    var profilepicis = ""
    
    var isEmailVerified = 0
    init(model: [String : Any]) {
        
        
        if let smsNotificationStatus = model["smsNotificationStatus"] as? Bool{
            self.smsNotificationStatus = smsNotificationStatus
        }
        if let smsNotificationStatus = model["emailNotificationStatus"] as? Bool{
            self.emailNotificationStatus = smsNotificationStatus
        }
        if let isSocialUserData = model["isSocialUser"] as? Bool{
            self.isSocialUser = isSocialUserData
        }
        
        if let accessToken = model["accessToken"] as? String{
            self.accessToken = accessToken
        }
        else{
            self.accessToken = model["token"] as? String
 
        }
        
        if let email = model["email"] as? String{
            self.email = email
        }
        
        if let profilePic = model["profilePic"] as? String{
            self.profilepicis = profilePic
        }
        
        if let city = model["city"] as? String{
            self.city = city
        }
        
        if let country = model["country"] as? String{
            self.country = country
        }
        
        
        if let firstName = model["firstName"] as? String{
            self.firstName = firstName
        }
        
        if let lastName = model["lastName"] as? String{
            self.lastName = lastName
        }
        
        if let pic = model["pic"] as? String{
            self.pic = pic
        }
        
        if let isIntro = model["isIntro"] as? Bool{
            self.isIntro = isIntro
        }
        
        if let timeZone = model["timeZone"] as? String{
            self.timeZone = timeZone
        }
        
        if let timeZoneCode = model["timeZoneUTCOffset"] as? String{
            self.timeZoneCode = timeZoneCode
        }
        
        if let timeZoneId = model["timeZoneId"] as? Int{
            self.timeZoneId = timeZoneId
        }
        
        if let isEmailVerifieds = model["isEmailVerified"] as? Int{
            self.isEmailVerified = isEmailVerifieds
        }
        
        if let percentageProfileComplete = model["percentageProfileComplete"] as? Int{
            self.percentageProfileComplete = percentageProfileComplete
        }
        
        if let timeZoneUTCOff = model["timeZoneCode"] as? String{
            self.timeZoneUTCOffset = timeZoneUTCOff
        }
        
        
    }
    
    
    required convenience init(coder aDecoder: NSCoder) {
        var mutDict : [String : Any] = [:]
        
        
        if  let token = aDecoder.decodeBool(forKey:"emailNotificationStatus") as? Bool{
            
            mutDict["emailNotificationStatus"] = token

        }

        if  let token = aDecoder.decodeBool(forKey:"smsNotificationStatus") as? Bool{
        
            mutDict["smsNotificationStatus"] = token
        }
        
        if  let token = aDecoder.decodeBool(forKey:"isSocialUser") as? Bool{
        
            mutDict["isSocialUser"] = token
        }
        
        if  let token = aDecoder.decodeObject(forKey:"accessToken")
        {
            mutDict["accessToken"] = token
        }
        
        if  let email = aDecoder.decodeObject(forKey:"email")
        {
            mutDict["email"] = email
        }
        
        if  let profilePic = aDecoder.decodeObject(forKey:"profilePic")
        {
            mutDict["profilePic"] = profilePic
        }
        
        if  let city = aDecoder.decodeObject(forKey:"city")
        {
            mutDict["city"] = city
        }
        
        if  let country = aDecoder.decodeObject(forKey:"country")
        {
            mutDict["country"] = country
        }
        
        if  let firstName = aDecoder.decodeObject(forKey:"firstName")
        {
            mutDict["firstName"] = firstName
        }
        
        if  let lastName = aDecoder.decodeObject(forKey:"lastName")
        {
            mutDict["lastName"] = lastName
        }
        
        
        if  let pic = aDecoder.decodeObject(forKey:"pic")
        {
            
            mutDict["pic"] =  pic
        }
        
        if  let isIntro = aDecoder.decodeObject(forKey:"isIntro")
        {
            mutDict["isIntro"] = isIntro
        }
        
        if  let timeZone = aDecoder.decodeObject(forKey:"timeZone")
        {
            mutDict["timeZone"] = timeZone
        }
        if  let timeZoneCode = aDecoder.decodeObject(forKey:"timeZoneCode")
        {
            mutDict["timeZoneCode"] = timeZoneCode
        }
        if  let timeZoneId = aDecoder.decodeObject(forKey:"timeZoneId")
        {
            mutDict["timeZoneId"] = timeZoneId
        }
        
        if  let isEmailVerified = aDecoder.decodeObject(forKey:"isEmailVerified")
        {
            mutDict["isEmailVerified"] = isEmailVerified
        }
        
        if  let timeZoneUTCOffset = aDecoder.decodeObject(forKey:"timeZoneUTCOffset")
        {
            mutDict["timeZoneUTCOffset"] = timeZoneUTCOffset
        }
        
        self.init(model: mutDict)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(smsNotificationStatus, forKey: "smsNotificationStatus")
        aCoder.encode(emailNotificationStatus, forKey: "emailNotificationStatus")
        aCoder.encode(isSocialUser, forKey: "isSocialUser")
        aCoder.encode(accessToken, forKey: "accessToken")
        aCoder.encode(email, forKey: "email")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(country, forKey: "country")
        aCoder.encode(profilepicis, forKey: "profilePic")
        
        
        aCoder.encode(pic, forKey: "pic")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        
        aCoder.encode(isIntro, forKey: "isIntro")
        
        aCoder.encode(timeZone, forKey: "timeZone")
        aCoder.encode(timeZoneUTCOffset, forKey: "timeZoneCode")
        aCoder.encode(timeZoneId, forKey: "timeZoneId")
        
        aCoder.encode(isEmailVerified, forKey: "isEmailVerified")
        aCoder.encode(timeZoneCode, forKey: "timeZoneUTCOffset")
        
        
    }
    

}
