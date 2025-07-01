//
//  AddFuelViewController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 26/10/24.
//

import UIKit
import CocoaTextField
import CountryPickerView
import DropDown
import AVFoundation
import Photos
import SDWebImage

class AddFuelViewController: UIViewController, CountriesSelectDelegate {
    func chooseCountries(_ id: Int, _ name: String) {
         
    }
    
    func chooseState(_ id: Int, _ name: String) {
        txt_State.text = name
        stateId = id
    }
    var countryId = 231
    var stateId = 3923
    var fleetId = 0
    var loadId = 0

    @IBOutlet weak var txt_FuelType : CocoaTextField!
    @IBOutlet weak var txt_DateFuel : CocoaTextField!
    @IBOutlet weak var txt_Quantity : CocoaTextField!
    @IBOutlet weak var txt_Amount : CocoaTextField!
    @IBOutlet weak var txt_StationName : CocoaTextField!
    @IBOutlet weak var txt_State : CocoaTextField!
    @IBOutlet weak var txt_Country : CocoaTextField!
    @IBOutlet weak var btn_Country : UIButton!
    @IBOutlet weak var btn_Gender : UIButton!
    @IBOutlet weak var img_Front : UIImageView!
    @IBOutlet weak var txt_Type : CocoaTextField!
    @IBOutlet weak var btn_FuelUnit : UIButton!

    var date_LastService = Date()
    let dropFuelType = DropDown()
    var fuelTypeStr = ""
    var imgLicense = UIImage()
    var img_UserProfile = UIImage()
    let dropCountry = DropDown()
    let dropFuelUnit = DropDown()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDowns()
        txt_FuelType.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_FuelType.placeholder = "Fuel Type"
        txt_FuelType.autocapitalizationType = .none
        applyStyle(to: txt_FuelType)
        
        txt_DateFuel.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_DateFuel.placeholder = "Fuel Date"
        txt_DateFuel.autocapitalizationType = .none
        applyStyle(to: txt_DateFuel)
        
        txt_Quantity.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_Quantity.placeholder = "Quantity"
        txt_Quantity.autocapitalizationType = .none
        txt_Quantity.keyboardType = .numberPad

        applyStyle(to: txt_Quantity)
        
        txt_Amount.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_Amount.placeholder = "Amount ($)"
        txt_Amount.autocapitalizationType = .none
        txt_Amount.keyboardType = .numberPad

        applyStyle(to: txt_Amount)
        
        txt_StationName.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_StationName.placeholder = "Station Name"
        txt_StationName.autocapitalizationType = .none
        applyStyle(to: txt_StationName)
        
        txt_State.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_State.placeholder = "Jurisdiction"
        txt_State.autocapitalizationType = .none
        applyStyle(to: txt_State)
        
        
        txt_Country.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_Country.placeholder = "Country"
        txt_Country.autocapitalizationType = .none
        applyStyle(to: txt_Country)
        txt_Country.text = "USA"
        
        txt_Type.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_Type.placeholder = "Type"
        txt_Type.autocapitalizationType = .none
        applyStyle(to: txt_Type)
        
        
        

        
    }
    
    func setupDropDowns() {
        
        let actionTitleFont = UIFont(name: FontName.Inter.Medium, size: CGFloat(16)) ?? UIFont.systemFont(ofSize: CGFloat(16), weight: .medium)
        DropDown.appearance().backgroundColor = AppColor.AppThemeColor
        DropDown.appearance().selectionBackgroundColor =  AppColor.AppThemeColor
        DropDown.appearance().cornerRadius = 10
        DropDown.appearance().textColor = UIColor.white
        DropDown.appearance().textFont =  actionTitleFont
        setupGenderDropDown()
        setupCountryDropDown()
        FuelUnitDropDown()
    }
    
    
    func setupCountryDropDown() {
        dropCountry.anchorView = btn_Country
        dropCountry.bottomOffset = CGPoint(x: 5, y: btn_Country.bounds.height - 10)
        dropCountry.direction = .bottom

        dropCountry.dataSource = [
            "USA",
            "Canada",
            ]
        
        dropCountry.selectionAction = { [weak self] (index, item) in
            self!.txt_Country.text = item
        }
    }
    
    
    func FuelUnitDropDown() {
        dropFuelUnit.anchorView = btn_FuelUnit
        dropFuelUnit.bottomOffset = CGPoint(x: 5, y: btn_FuelUnit.bounds.height - 10)
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
        
            self!.txt_Type.text = item
        }
    }
    
    
    func setupGenderDropDown() {
        dropFuelType.anchorView = btn_Gender
        dropFuelType.bottomOffset = CGPoint(x: 5, y: btn_Gender.bounds.height - 10)
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
            self!.txt_FuelType.text = item
            self!.fuelTypeStr = item

        }
    }
    
    //Hide KeyBoard When touche on View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func btnBackPreessed(_ sender: Any){
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func type(_ sender: Any) {
        self.view.endEditing(true)
        dropFuelType.show()
    }
    
    @IBAction func FuelUnit(_ sender: Any) {
        self.view.endEditing(true)

        dropFuelUnit.show()
    }
    
    
    @IBAction func DateF(_ sender: Any) {
        self.view.endEditing(true)

        addPickerLastServiceDate()
    }
    
    @IBAction func LicensePressed(_ sender: Any){
        self.view.endEditing(true)

        addImage(sender as! UIButton)
    }
    
    @IBAction func State(_ sender: Any) {
        self.view.endEditing(true)

        let controller:CountriesListController =  UIStoryboard(storyboard: .main).initVC()
        controller.delegate = self
        controller.topTitle = "Select Jurisdictions"
        controller.countryID = countryId
        controller.isJurisdictions = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func Country(_ sender: Any) {
        self.view.endEditing(true)

        dropCountry.show()

    }
    
    @IBAction func Update(_ sender: Any) {
        self.view.endEditing(true)

        guard let fuelType = txt_FuelType.text, !fuelType.isEmpty else {
            self.MessageAlertError(message: "Please select fuel type")
            return
        }
        
        guard let dateFuel = txt_DateFuel.text, !dateFuel.isEmpty else {
            self.MessageAlertError(message: "Please select fuel date")
            return
        }
        
        guard let dateFuel = txt_Type.text, !dateFuel.isEmpty else {
            self.MessageAlertError(message: "Please select quantity type")
            return
        }
        
        guard let quantity = txt_Quantity.text, !quantity.isEmpty else {
            self.MessageAlertError(message: "Please enter quantity")
            return
        }
        
        var FuelQuantity = 0.00
        FuelQuantity = Double(self.txt_Quantity.text ?? "0.00") ?? 0.00
        
        if FuelQuantity == 0.00 {
            self.MessageAlertError(message: "Please enter a valid quantity")
            return
        }
        
        guard let amount = txt_Amount.text, !amount.isEmpty else {
            self.MessageAlertError(message: "Please enter amount")
            return
        }
        
        var FuelCost = 0.00
        FuelCost = Double(self.txt_Amount.text ?? "0.00") ?? 0.00
        
        if FuelCost == 0.00 {
            self.MessageAlertError(message: "Please enter a valid amount")
            return
        }
        
        guard let stationName = txt_StationName.text, !stationName.isEmpty else {
            self.MessageAlertError(message: "Please enter station name")
            return
        }
        
        guard let state = txt_State.text,!state.isEmpty else {
            self.MessageAlertError(message: "Please select jurisdiction")
            return
        }
        
        
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .medium  // You can use .short, .medium, .long, or .full
        formatter.dateStyle = .none    // To print only the time
        var timeString = formatter.string(from: now)
        
        timeString = (self.txt_DateFuel.text ?? "") + " " + timeString
      
        print("Current time: \(timeString)")

        
        let params = [
            "Id": 0,
            "LoadId" : loadId,
            "FleetId": fleetId,
            "FuelType" : self.fuelTypeStr,
            "FuelUnit" : self.txt_Type.text ?? "",
            "FuelQuantity": FuelQuantity,
            "FuelDate": timeString,
            "StationName": txt_StationName.text ?? "",
            "Country": self.txt_Country.text ?? "",
            "FuelCost" : FuelCost,
            "OdometerReading" : 0,
            "Jurisdiction" : self.txt_State.text ?? ""
                     ] as [String : Any]
   
        AlamofireRequest().uploadAddFuelReceipt(parameters: params, image:self.imgLicense, name:"iPhone.jpeg", file: "FuelReceipt", userID:0){ data, isSuccess -> Void in
            
             if isSuccess == true {
                 if let nonEmptyString = data, !nonEmptyString.isEmpty {
                     self.showAlertWith(nonEmptyString)
                 }
                 else{
                     self.MessageAlertError(message: "Something went wrong")
                 }
            }
            else{
                self.MessageAlertError(message: "Something went wrong")
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
    
    func addPickerLastServiceDate(){
        let alert = UIAlertController(style: .alert, title: "Select Date")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        
        alert.setTitle(font: UIFont(name: FontName.Inter.Medium, size: 14)!, color: AppColor.AppThemeColor)
        
        alert.view.tintColor = AppColor.AppThemeColor
        
        let date = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        date_LastService = date ?? Date()
        
        if self.txt_DateFuel.text == ""
        {
            date_LastService = date ?? Date()
        }
        else
        {
            let isoDate = txt_DateFuel.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            date_LastService = dateFormatter.date(from:isoDate ?? "13-08-2002") ?? Date()
            
        }
        
        alert.addDatePicker(mode: .date, date: date_LastService, minimumDate: nil, maximumDate: Date()) { date in
            self.date_LastService = date
        }
        alert.addAction( title: "OK", style: .default, isEnabled: true) { (action) in
            
            self.txt_DateFuel.text = "".convertToDDMMyyyy(date:self.date_LastService)
            
        }
        alert.addAction(title: "Cancel", style: .cancel){ (action) in
            
        }
        alert.show()
    }
}

extension AddFuelViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
            message: "App requires to access your camera to capture image on your business profile and service.",
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
        
        self.imgLicense = originalImage
        img_Front.image = originalImage
        ImageCompressor.compress(image: originalImage, maxByte: 1000000) { image in
            if let compressedImage = image {
                self.imgLicense = compressedImage
            } else {
                print("error")
            }
        }
     
        self.dismiss(animated: false, completion: { [weak self] in
        })
    }
}
struct ImageCompressor {
    static func compress(image: UIImage, maxByte: Int,
                         completion: @escaping (UIImage?) -> ()) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard let currentImageSize = image.jpegData(compressionQuality: 1.0)?.count else {
                return completion(nil)
            }
        
            var iterationImage: UIImage? = image
            var iterationImageSize = currentImageSize
            var iterationCompression: CGFloat = 1.0
        
            while iterationImageSize > maxByte && iterationCompression > 0.01 {
                let percantageDecrease = getPercantageToDecreaseTo(forDataCount: iterationImageSize)
            
                let canvasSize = CGSize(width: image.size.width * iterationCompression,
                                        height: image.size.height * iterationCompression)
                UIGraphicsBeginImageContextWithOptions(canvasSize, false, image.scale)
                defer { UIGraphicsEndImageContext() }
                image.draw(in: CGRect(origin: .zero, size: canvasSize))
                iterationImage = UIGraphicsGetImageFromCurrentImageContext()
            
                guard let newImageSize = iterationImage?.jpegData(compressionQuality: 1.0)?.count else {
                    return completion(nil)
                }
                iterationImageSize = newImageSize
                iterationCompression -= percantageDecrease
                print(newImageSize)
            }
            completion(iterationImage)
        }
    }

    private static func getPercantageToDecreaseTo(forDataCount dataCount: Int) -> CGFloat {
        switch dataCount {
        case 0..<3000000: return 0.05
        case 3000000..<10000000: return 0.1
        default: return 0.2
        }
    }
}
