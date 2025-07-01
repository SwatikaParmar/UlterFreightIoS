//
//  UpdateFleetViewController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 11/06/25.
//

import UIKit
import CocoaTextField
import CountryPickerView
import DropDown
import AVFoundation
import Photos
import Alamofire
class UpdateFleetViewController: UIViewController {

    @IBOutlet weak var txt_VehicleName : CocoaTextField!
    @IBOutlet weak var txt_VehicleNo : CocoaTextField!
    @IBOutlet weak var txt_VehicleType : CocoaTextField!
    @IBOutlet weak var txt_MaintenanceDate : CocoaTextField!
    @IBOutlet weak var txt_RegistrationDate : CocoaTextField!
    @IBOutlet weak var txt_InsuranceDate : CocoaTextField!
    @IBOutlet weak var txt_VehicleCapacity : CocoaTextField!
    @IBOutlet weak var txt_VehicleUnit : CocoaTextField!

    @IBOutlet weak var txt_CapacityType : CocoaTextField!
    @IBOutlet weak var txt_VehicleModelNo : CocoaTextField!
    @IBOutlet weak var txt_VehicleMakeDate : CocoaTextField!
    @IBOutlet weak var txt_VehicleFuelType : CocoaTextField!
    @IBOutlet weak var txt_VehicleLicensePlateNo : CocoaTextField!
    
    
    @IBOutlet weak var btn_VehicleType : UIButton!
    @IBOutlet weak var btn_MaintenanceDate : UIButton!
    @IBOutlet weak var btn_RegistrationDate : UIButton!
    @IBOutlet weak var btn_InsuranceDate : UIButton!
    @IBOutlet weak var btn_VehicleUnit : UIButton!
    @IBOutlet weak var btn_CapacityType : UIButton!
    @IBOutlet weak var btn_VehicleMakeDate : UIButton!
    @IBOutlet weak var btn_VehicleFuelType : UIButton!
    
    @IBOutlet weak var lbeTitle : UILabel!
    @IBOutlet weak var imgFleetImage : UIImageView!
    @IBOutlet weak var imgRegistrationDocument : UIImageView!
    @IBOutlet weak var imgInsuranceCertificate : UIImageView!

    
    let dropFuelType = DropDown()
    let dropFuelUnit = DropDown()
    let dropVehicleType = DropDown()
    let dropCapacityType = DropDown()
    
    var dateMaintenance = Date()
    var dateRegistration = Date()
    var dateInsurance = Date()
    var dateMake = Date()
    
    var titleStr = ""
    var isType = 1
    var fleetId = 0
    var imgInsurance = UIImage()
    var imgRegistration = UIImage()
    var imgFleet = UIImage()
    var isFleetImageUpload = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbeTitle.text = titleStr
        txt_VehicleName.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_VehicleName.placeholder = "Vehicle Name"
        txt_VehicleName.autocapitalizationType = .none
        applyStyle(to: txt_VehicleName)
        
        txt_VehicleNo.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_VehicleNo.placeholder = "Vehicle Identification No."
        txt_VehicleNo.autocapitalizationType = .none
        applyStyle(to: txt_VehicleNo)
        
        
        txt_VehicleType.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_VehicleType.placeholder = "Vehicle Type"
        txt_VehicleType.autocapitalizationType = .none
        applyStyle(to: txt_VehicleType)
        
        txt_MaintenanceDate.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_MaintenanceDate.placeholder = "Last Maintenance Date"
        txt_MaintenanceDate.autocapitalizationType = .none
        applyStyle(to: txt_MaintenanceDate)
        
        txt_RegistrationDate.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_RegistrationDate.placeholder = "Registration Expiration Date"
        txt_RegistrationDate.autocapitalizationType = .none
        applyStyle(to: txt_RegistrationDate)
        
        txt_InsuranceDate.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_InsuranceDate.placeholder = "Insurance Expiration Date"
        txt_InsuranceDate.autocapitalizationType = .none
        applyStyle(to: txt_InsuranceDate)
        
        txt_VehicleCapacity.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_VehicleCapacity.placeholder = "Capacity Value"
        txt_VehicleCapacity.autocapitalizationType = .none
        applyStyle(to: txt_VehicleCapacity)
        
        
        txt_VehicleUnit.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_VehicleUnit.placeholder = "Capacity Unit"
        txt_VehicleUnit.autocapitalizationType = .none
        applyStyle(to: txt_VehicleUnit)
        
        txt_CapacityType.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_CapacityType.placeholder = "Capacity Type"
        txt_CapacityType.autocapitalizationType = .none
        applyStyle(to: txt_CapacityType)
        
        txt_VehicleModelNo.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_VehicleModelNo.placeholder = "Vehicle Model"
        txt_VehicleModelNo.autocapitalizationType = .none
        applyStyle(to: txt_VehicleModelNo)
        
        
        txt_VehicleMakeDate.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_VehicleMakeDate.placeholder = "Make Year"
        txt_VehicleMakeDate.autocapitalizationType = .none
        applyStyle(to: txt_VehicleMakeDate)
        
        txt_VehicleFuelType.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_VehicleFuelType.placeholder = "Fuel Type"
        txt_VehicleFuelType.autocapitalizationType = .none
        applyStyle(to: txt_VehicleFuelType)
        
        txt_VehicleLicensePlateNo.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_VehicleLicensePlateNo.placeholder = "License Plate"
        txt_VehicleLicensePlateNo.autocapitalizationType = .none
        applyStyle(to: txt_VehicleLicensePlateNo)
        
        setupCapacityTypeDropDown()
        setupVehicleTypeDropDown()
        setupFuelTypeDropDown()
        setupFuelUnitDropDown()
    }
    
    func setupCapacityTypeDropDown() {
        dropCapacityType.anchorView = btn_CapacityType
        dropCapacityType.bottomOffset = CGPoint(x: 5, y: btn_CapacityType.bounds.height - 10)
        dropCapacityType.direction = .bottom

        dropCapacityType.dataSource = [
            "CargoCapacity",      // The weight of cargo a vehicle can carry
            "TowingCapacity",    // The weight a vehicle can tow
            "Furniture",
            "MedicalSupplies"
            ]
        
        
        dropCapacityType.selectionAction = { [weak self] (index, item) in
        
            self!.txt_CapacityType.text = item
        }
    }
    
    func setupVehicleTypeDropDown() {
        dropVehicleType.anchorView = btn_VehicleType
        dropVehicleType.bottomOffset = CGPoint(x: 5, y: btn_VehicleType.bounds.height - 10)
        dropVehicleType.direction = .bottom

        dropVehicleType.dataSource = [
                 "LightDutyTruck",
                 "MediumDutyTruck",
                 "HeavyDutyTruck",
                 "FlatbedTruck",
                 "TankerTruck",
                 "RefrigeratedTruck",
                 "DumpTruck",
                 "DryVan",
                 "IntermodalContainer",
                 "LowboyTrailer",
                 "LivestockTrailer",
            ]
        
        
        dropVehicleType.selectionAction = { [weak self] (index, item) in
        
            self!.txt_VehicleType.text = item
        }
    }
    
    
    func setupFuelTypeDropDown() {
        dropFuelType.anchorView = btn_VehicleFuelType
        dropFuelType.bottomOffset = CGPoint(x: 5, y: btn_VehicleFuelType.bounds.height - 10)
        dropFuelType.direction = .bottom

        dropFuelType.dataSource = [
                        "Gasoline",
                        "SpecialDiesel",
                        "Propane",
                        "Ethanol",
                        "Methanol",
                        "E85",
                        "M85",
                        "A55",
                        "Gasohol",
                        "Electricity",
                        "Biodiesel",
                        "Hythane",
                        "Lng",
                        "Cng",
                        "Hydrogen"
                        ]
        
        
        dropFuelType.selectionAction = { [weak self] (index, item) in
            self!.txt_VehicleFuelType.text = item

        }
    }
    
    func setupFuelUnitDropDown() {
        dropFuelUnit.anchorView = btn_VehicleUnit
        dropFuelUnit.bottomOffset = CGPoint(x: 5, y: btn_VehicleUnit.bounds.height - 10)
        dropFuelUnit.direction = .bottom

        dropFuelUnit.dataSource = [
            "Liters",
            "Gallons",
            "Kilograms",
            "KilowattHours",
            "CubicMeters",
            "Pounds",
            "Tons"
            ]
        
        
        dropFuelUnit.selectionAction = { [weak self] (index, item) in
        
            self!.txt_VehicleUnit.text = item
        }
    }
 
    
    func lastMaintenanceDate(){
        let alert = UIAlertController(style: .alert, title: "Select Date")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        
        alert.setTitle(font: UIFont(name: FontName.Inter.Medium, size: 14)!, color: AppColor.AppThemeColor)
        
        alert.view.tintColor = AppColor.AppThemeColor
        
        let date = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        dateMaintenance = date ?? Date()
        
        if self.txt_MaintenanceDate.text == ""
        {
            dateMaintenance = date ?? Date()
        }
        else
        {
            let isoDate = txt_MaintenanceDate.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateMaintenance = dateFormatter.date(from:isoDate ?? "13-08-2002") ?? Date()
            
        }
        
        alert.addDatePicker(mode: .date, date: dateMaintenance, minimumDate: nil, maximumDate: Date()) { date in
            self.dateMaintenance = date
        }
        alert.addAction( title: "OK", style: .default, isEnabled: true) { (action) in
            
            self.txt_MaintenanceDate.text = "".convertToDDMMyyyy(date:self.dateMaintenance)
            
        }
        alert.addAction(title: "Cancel", style: .cancel){ (action) in
            
        }
        alert.show()
    }
    
    func lastRegistrationDate(){
        let alert = UIAlertController(style: .alert, title: "Select Date")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        
        alert.setTitle(font: UIFont(name: FontName.Inter.Medium, size: 14)!, color: AppColor.AppThemeColor)
        
        alert.view.tintColor = AppColor.AppThemeColor
        
        let date = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        dateRegistration = date ?? Date()
        
        if self.txt_RegistrationDate.text == ""
        {
            dateRegistration = date ?? Date()
        }
        else
        {
            let isoDate = txt_RegistrationDate.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateRegistration = dateFormatter.date(from:isoDate ?? "13-08-2002") ?? Date()
            
        }
        
        alert.addDatePicker(mode: .date, date: dateRegistration, minimumDate: nil, maximumDate: Date()) { date in
            self.dateRegistration = date
        }
        alert.addAction( title: "OK", style: .default, isEnabled: true) { (action) in
            
            self.txt_RegistrationDate.text = "".convertToDDMMyyyy(date:self.dateRegistration)
            
        }
        alert.addAction(title: "Cancel", style: .cancel){ (action) in
            
        }
        alert.show()
    }
    
    func lastInsuranceDate(){
        let alert = UIAlertController(style: .alert, title: "Select Date")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        
        alert.setTitle(font: UIFont(name: FontName.Inter.Medium, size: 14)!, color: AppColor.AppThemeColor)
        
        alert.view.tintColor = AppColor.AppThemeColor
        
        let date = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        dateInsurance = date ?? Date()
        
        if self.txt_InsuranceDate.text == ""
        {
            dateInsurance = date ?? Date()
        }
        else
        {
            let isoDate = txt_InsuranceDate.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateInsurance = dateFormatter.date(from:isoDate ?? "13-08-2002") ?? Date()
            
        }
        
        alert.addDatePicker(mode: .date, date: dateInsurance, minimumDate: nil, maximumDate: Date()) { date in
            self.dateInsurance = date
        }
        alert.addAction( title: "OK", style: .default, isEnabled: true) { (action) in
            
            self.txt_InsuranceDate.text = "".convertToDDMMyyyy(date:self.dateInsurance)
            
        }
        alert.addAction(title: "Cancel", style: .cancel){ (action) in
            
        }
        alert.show()
    }
    
    
    func lastMakeDate(){
        let alert = UIAlertController(style: .alert, title: "Select Date")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        
        alert.setTitle(font: UIFont(name: FontName.Inter.Medium, size: 14)!, color: AppColor.AppThemeColor)
        
        alert.view.tintColor = AppColor.AppThemeColor
        
        let date = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        dateMake = date ?? Date()
        
        if self.txt_VehicleMakeDate.text == ""
        {
            dateMake = date ?? Date()
        }
        else
        {
            let isoDate = txt_VehicleMakeDate.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            dateMake = dateFormatter.date(from:isoDate ?? "13-08-2002") ?? Date()
            
        }
        
        alert.addDatePicker(mode: .date, date: dateMake, minimumDate: nil, maximumDate: Date()) { date in
            self.dateMake = date
        }
        alert.addAction( title: "OK", style: .default, isEnabled: true) { (action) in
            
            self.txt_VehicleMakeDate.text = "".convertToDDMMyyyy(date:self.dateMake)
            
        }
        alert.addAction(title: "Cancel", style: .cancel){ (action) in
            
        }
        alert.show()
    }
    
    @IBAction func btnBackPreessed(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func VehicleType(_ sender: Any){
        dropVehicleType.show()
        
    }
    @IBAction func Maintenance(_ sender: Any){
        lastMaintenanceDate()
    }
    
     @IBAction func Registration(_ sender: Any){
        lastRegistrationDate()
    }
    
    
    @IBAction func Insurance(_ sender: Any){
        lastInsuranceDate()
    }

    @IBAction func Unit(_ sender: Any){
        dropFuelUnit.show()

    }
    
    @IBAction func Type(_ sender: Any){
        dropCapacityType.show()

    }
    
    @IBAction func MakeYear(_ sender: Any){
        lastMakeDate()
    }
    
    @IBAction func FuelType(_ sender: Any){
        dropFuelType.show()

    }
    
    @IBAction func RegistrationDocument(_ sender: Any){
        self.view.endEditing(true)
        isType = 2
        addImage(sender as! UIButton)
    }
    
    @IBAction func FleetImage(_ sender: Any){
        self.view.endEditing(true)
        isType = 1
        addImage(sender as! UIButton)
    }
    
    @IBAction func InsuranceCertificate(_ sender: Any){
        
        self.view.endEditing(true)
        isType = 3
        addImage(sender as! UIButton)
    }
    
    @IBAction func Update(_ sender: Any){
        
        updateFleet()
    }
    
    func updateFleet(){
        
        guard let name = txt_VehicleName.text, !name.isEmpty else {
            self.MessageAlertError(message: "Vehicle Name is required")
            return
           }
        
        guard let Identification = txt_VehicleNo.text, !Identification.isEmpty else {
            self.MessageAlertError(message: "Vehicle Identification Number is required")
            return
           }
        
        guard let Type = txt_VehicleType.text, !Type.isEmpty else {
            self.MessageAlertError(message: "Vehicle Type is required")
            return
           }
        guard let Maintenance = txt_MaintenanceDate.text, !Maintenance.isEmpty else {
            self.MessageAlertError(message: "Last Maintenance date is required")
            return
           }
        
        
        guard let Registration = txt_RegistrationDate.text, !Registration.isEmpty else {
            self.MessageAlertError(message: "Registration Expiration Date is required")
            return
           }
        
        guard let Insurance = txt_InsuranceDate.text, !Insurance.isEmpty else {
            self.MessageAlertError(message: "Insurance Expiration Date is required")
            return
           }
        
        guard let Capacity = txt_VehicleCapacity.text, !Capacity.isEmpty else {
            self.MessageAlertError(message: "Capacity Value is required")
            return
           }
        
        guard let Unit = txt_VehicleUnit.text, !Unit.isEmpty else {
            self.MessageAlertError(message: "Capacity Unit is required")
            return
           }
        
        guard let Model = txt_VehicleModelNo.text, !Model.isEmpty else {
            self.MessageAlertError(message: "Model is required")
            return
           }
        
        guard let Make = txt_VehicleMakeDate.text, !Make.isEmpty else {
            self.MessageAlertError(message: "Make Year is required")
            return
           }
        guard let Fuel = txt_VehicleFuelType.text, !Fuel.isEmpty else {
            self.MessageAlertError(message: "Fuel Type is required")
            return
           }
        guard let Plate = txt_VehicleLicensePlateNo.text, !Plate.isEmpty else {
            self.MessageAlertError(message: "License Plate no is required")
            return
           }
        
        if isFleetImageUpload == false{
            self.MessageAlertError(message: "License Plate no is required")
            return
           }
        
        let params =
                [
                    
                      "fleetId": fleetId,
                      "driverId": userId(),
                      "vehicleName": name,
                      "vehicleType": Type,
                      "vehicleIdentificationNumber": Identification,
                      "makeYear": Make,
                      "model": Model,
                      "licensePlate": Plate,
                      "fuelType": Fuel,
                      "registrationExpirationDate": Registration,
                      "insuranceExpirationDate": Insurance,
                      "lastMaintenanceDate": Maintenance,
                      "isAvailable": true,
                      "capacityValue": Capacity,
                      "capacityUnit": Unit,
                      "capacityType": txt_CapacityType.text ?? "",
                      "currentLocationLat": "",
                      "currentLocationLong": ""
                    
               ] as [String : Any]
           
     
        UpdateFleetRequest.shared.updateFleet(requestParams: params) { (id, message, success,Verification) in
     
                 if success {
                     if self.isFleetImageUpload  {
                         if id > 0 {
                             self.updateDocument(message!,id)
                         }
                         else{
                             self.showAlertWith(message ?? "Submit Successfully")

                         }
                     }
                     else{
                         self.showAlertWith(message ?? "Submit Successfully")
                     }
                 }
                 else
                 {
                     self.MessageAlertError(message: message!)
                 }
            }
        }
    
    func showAlertWith(_ message:String) {
        let alert = UIAlertController(title: "Success!", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
            self.navigationController?.popViewController(animated: true)
               
        }

        alert.addAction(confirmAction)

        self.present(alert, animated: true, completion: nil)
    }
    
    
    func updateDocument(_ message:String, _ id:Int){
        var fileName = ""
        fileName =  "iOS" + NSUUID().uuidString + ".jpeg"
        
        let token = accessToken()
        
        let bearer : String = "Bearer \(token )"
        
        let parameters = ["FleetId": id]
        
        
        Indicator.shared.startAnimating(withMessage:"", colorType: UIColor.white, colorText:UIColor.white)
 
        let dataF = imgFleet.jpegData(compressionQuality: 0.5)
        let dataI = imgInsurance.jpegData(compressionQuality: 0.5)
        let dataR = imgRegistration.jpegData(compressionQuality: 0.5)

        
        let urlString = "BaseURL".UploadFleetInsuranceCertificate
        let headers: HTTPHeaders
        headers = ["Content-type": "multipart/form-data",
                   "Content-Disposition" : "form-data",
                   "Authorization": bearer]
        
        AF.upload(multipartFormData: { (multipartFormData) in
            
            for (key, value) in parameters {
                if let intValue = value as? Int {
                    multipartFormData.append("\(intValue)".data(using: .utf8)!, withName: key)
                }
              
            }
            
            
            if dataF != nil{
                multipartFormData.append(dataF!, withName:"FleetImage", fileName:fileName, mimeType: "image/jpeg")
            }
            if dataI != nil{
                multipartFormData.append(dataI!, withName:"InsuranceCertificate", fileName:fileName, mimeType: "image/jpeg")
            }
            if dataR != nil{
                multipartFormData.append(dataR!, withName:"RegistrationDocument", fileName:fileName, mimeType: "image/jpeg")
            }
            
        },to: URL.init(string: urlString)!, usingThreshold: UInt64.init(),
                  method: .post,
                  headers: headers).response{ response in
            
            if((response.error == nil)){
                do{
                    if let jsonData = response.data{
                        
                        if let jsonString = String(data: jsonData, encoding: .utf8) {
                                        print("Response JSON String: \(jsonString)")
                                    } else {
                                        print("Failed to convert data to string.")
                                    }
                        
                        let parsedData = try JSONSerialization.jsonObject(with: jsonData) as! Dictionary<String, AnyObject>
                        print(parsedData)
                        
                        let isSuccess = parsedData["isSuccess"] as? Int
                        if isSuccess == 1 {
                            Indicator.shared.stopAnimating()
                            self.showAlertWith(message)

                        }
                        else{
                            Indicator.shared.stopAnimating()
                            print(response.error ?? "failure")
                            let errorMessage: String = response.error?.localizedDescription ?? "Unknown error"
                            self.MessageAlertError(message: errorMessage)

                        }
                    }
                }catch{
                    print(response.error ?? "failure")
                    Indicator.shared.stopAnimating()
                    let errorMessage: String = response.error?.localizedDescription ?? "Unknown error"
                    self.MessageAlertError(message: errorMessage)
                }
            }
            else{
                print(response.error ?? "failure")
                Indicator.shared.stopAnimating()
                let errorMessage: String = response.error?.localizedDescription ?? "Unknown error"
                self.MessageAlertError(message: errorMessage)
            }
        }
    }
    
}

extension UpdateFleetViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func addImage(_ sender: UIButton){
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let takePic = UIAlertAction(title: "Take Photo", style: .default,handler: {
            (alert: UIAlertAction!) -> Void in
            self.checkCameraAccess()
        })
        let choseAction = UIAlertAction(title: "Choose from Library",style: .default,handler: {
            (alert: UIAlertAction!) -> Void in
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            myPickerController.modalPresentationStyle = .fullScreen
            self.present(myPickerController, animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        optionMenu.addAction(takePic)
        optionMenu.addAction(choseAction)
        optionMenu.addAction(cancelAction)
        
        if let popoverController = optionMenu.popoverPresentationController {
                popoverController.sourceView = sender
                popoverController.sourceRect = sender.bounds
            }
        
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func checkCameraAccess() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        
        case .authorized:
            print("Authorized, proceed")
            DispatchQueue.main.async {
                let myPickerController = UIImagePickerController()
                myPickerController.delegate = self
                myPickerController.sourceType = UIImagePickerController.SourceType.camera
                myPickerController.modalPresentationStyle = .fullScreen
                myPickerController.showsCameraControls = true
                self.present(myPickerController, animated: true, completion: nil)
            }
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { success in
                if success {
                    print("Permission granted, proceed")
                    DispatchQueue.main.async {
                        let myPickerController = UIImagePickerController()
                        myPickerController.delegate = self
                        myPickerController.sourceType = UIImagePickerController.SourceType.camera
                        myPickerController.modalPresentationStyle = .fullScreen
                        myPickerController.showsCameraControls = true
                        self.present(myPickerController, animated: true, completion: nil)
                    }
                }
                else{
                    self.dismiss(animated: false, completion: nil)
                }
            }
        default:
            self.alertToEncourageCameraAccessInitially()
        }
    }
    
    func alertToEncourageCameraAccessInitially() {
        
        let alert = UIAlertController(
            title: "Alert",
            message: "App requires to access your camera to capture image on your Fleet profile.",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let originalImage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage else { return }
        
        if isType == 1 {
            self.imgFleet = originalImage
            imgFleetImage.image = originalImage
            isFleetImageUpload = true
        }
        else if isType == 2 {
            self.imgRegistration = originalImage
            imgRegistrationDocument.image = originalImage
        }
        else{
            self.imgInsurance = originalImage
            imgInsuranceCertificate.image = originalImage
        }
      

        self.dismiss(animated: false, completion: { [weak self] in
        })
    }
}
