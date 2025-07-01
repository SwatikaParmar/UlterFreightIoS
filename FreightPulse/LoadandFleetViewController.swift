//
//  LoadandFleetViewController.swift
//  FreightPulse
//
//  Created by Mac on 21/05/25.
//

import UIKit

class LoadandFleetViewController: UIViewController {
    
    @IBOutlet weak var lbeTitle: UILabelX!
    @IBOutlet weak var lbeLoadData: UILabelX!
    @IBOutlet weak var lbeFleetData: UILabelX!
    @IBOutlet weak var btnLoadData: UIButton!
    @IBOutlet weak var btnFleetData: UIButton!
    @IBOutlet weak var lbePickupDateTime: UILabel!
    @IBOutlet weak var lbeDeliveryDateTime: UILabel!
    @IBOutlet weak var lbeLoadType: UILabel!
    @IBOutlet weak var lbeLoadDetails: UILabel!
    @IBOutlet weak var lbeWeightValue: UILabel!
    @IBOutlet weak var lbeWeightUnit: UILabel!
    @IBOutlet weak var lbeTargetPrice: UILabel!
    @IBOutlet weak var lbeSpecialRequirements: UILabel!
    @IBOutlet weak var lbeStatus: UILabel!
    @IBOutlet weak var scrollLoadView: UIScrollView!
    @IBOutlet weak var scrollFleetView: UIScrollView!
    
    @IBOutlet weak var lbeVehicleName: UILabel!
    @IBOutlet weak var lbeVehicleType: UILabel!
    @IBOutlet weak var lbeVehicleIdNo: UILabel!
    @IBOutlet weak var lbeRegistrationDocId: UILabel!
    @IBOutlet weak var lbeInsuranceDocId: UILabel!
    @IBOutlet weak var lbeRegistrationDocURL: UILabel!
    @IBOutlet weak var lbeInsuranceDocURL: UILabel!
    @IBOutlet weak var lbeRegistrationDocStatus: UILabel!
    @IBOutlet weak var lbeInsuranceDocStatus: UILabel!
    @IBOutlet weak var lbeCapacity: UILabel!
    @IBOutlet weak var lbeCurrentLocationLat: UILabel!
    @IBOutlet weak var lbeCurrentLocationLong: UILabel!
    @IBOutlet weak var lbeLastMaintenanceDate: UILabel!

    var arrayLoadData : LoadDetailData?
    var arrayFleetData : FleetDetailData?
    var loadId = 0
    var fleetID = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lbeLoadData.backgroundColor = AppColor.AppThemeColor
        lbeFleetData.backgroundColor = UIColor.clear
        lbeLoadData.textColor = UIColor.white
        lbeFleetData.textColor = AppColor.BlackColor
        
        lbeLoadData.layer.cornerRadius = 17
        lbeLoadData.clipsToBounds = true
        lbeLoadData.layer.masksToBounds = true
        
        lbeFleetData.layer.cornerRadius = 17
        lbeFleetData.clipsToBounds = true
        lbeFleetData.layer.masksToBounds = true
        scrollLoadView.isHidden = false
        scrollFleetView.isHidden = true
        GetLoadData(true)
    }
    
    func GetLoadData(_ isLoader: Bool) {
        
        GetLoadDetailRequest.shared.GetLoadDetailRequestAPI(requestParams:["id":loadId], isLoader) { (message,status,dictionary) in
            if status {
                if dictionary != nil{
                    self.arrayLoadData = dictionary
                    self.ShowLoadData()
                }
            }
        }
    }
    
    func GetFleetData(_ isLoader: Bool) {
        
        GetFleetDetailRequest.shared.GetFleetDetailRequestAPI(requestParams:["fleetId":fleetID], isLoader) { (message,status,dictionary) in
            if status {
                if dictionary != nil{
                    self.arrayFleetData = dictionary
                    self.ShowFleetData()
                }
            }
        }
    }
    
    func ShowLoadData() {
                
        lbePickupDateTime.text = "".convertddMMMM(pickupDate: self.arrayLoadData?.pickupDate ?? "", pickupTime: self.arrayLoadData?.pickupTime ?? "")
        lbeDeliveryDateTime.text = "".convertddMMMM(pickupDate: self.arrayLoadData?.deliveryDate ?? "", pickupTime: self.arrayLoadData?.deliveryTime ?? "")
        lbeLoadType.text = arrayLoadData?.loadType
        lbeLoadDetails.text = arrayLoadData?.loadDetails
        lbeWeightUnit.text = arrayLoadData?.weightUnit
        lbeSpecialRequirements.text = arrayLoadData?.specialRequirements
        lbeStatus.text = arrayLoadData?.status
        
        if let weight = arrayLoadData?.weightValue {
            lbeWeightValue.text = String(weight)
        } else {
            lbeWeightValue.text = ""
        }
        
        if let price = arrayLoadData?.targetPrice {
            lbeTargetPrice.text = String(price)
        } else {
            lbeTargetPrice.text = ""
        }

    }


    func ShowFleetData() {
        
        lbeVehicleName.text = arrayFleetData?.vehicleName
        lbeVehicleType.text = arrayFleetData?.vehicleType
        lbeVehicleIdNo.text = arrayFleetData?.vehicleIdentificationNumber
        lbeRegistrationDocId.text = arrayFleetData?.registrationDocumentId
        lbeInsuranceDocId.text = arrayFleetData?.insuranceDocumentId
        lbeRegistrationDocURL.text = arrayFleetData?.registrationDocumentUrl
        lbeInsuranceDocURL.text = arrayFleetData?.insuranceDocumentUrl
        lbeRegistrationDocStatus.text = arrayFleetData?.registrationDocumentStatus
        lbeInsuranceDocStatus.text = arrayFleetData?.insuranceDocumentStatus
        lbeCapacity.text = arrayFleetData?.capacityType
        lbeCurrentLocationLat.text = arrayFleetData?.currentLocationLat
        lbeCurrentLocationLong.text = arrayFleetData?.currentLocationLong
        lbeLastMaintenanceDate.text = arrayFleetData?.lastMaintenanceDate

    }
    
    @IBAction func connected_Load(_ sender: Any) {
        
        lbeLoadData.backgroundColor = AppColor.AppThemeColor
        lbeFleetData.backgroundColor = UIColor.clear
        lbeLoadData.textColor = UIColor.white
        lbeFleetData.textColor = AppColor.BlackColor
        scrollFleetView.isHidden = true
        scrollLoadView.isHidden = false

        GetLoadData(false)
    }
    
    @IBAction func connected_Fleet(_ sender: Any) {
        
        lbeLoadData.backgroundColor = UIColor.clear
        lbeLoadData.textColor = AppColor.BlackColor
        lbeFleetData.textColor = UIColor.white
        lbeFleetData.backgroundColor = AppColor.AppThemeColor
        scrollLoadView.isHidden = true
        scrollFleetView.isHidden = false

        GetFleetData(false)
    }
    
    @IBAction func Back(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
    }
    
}
