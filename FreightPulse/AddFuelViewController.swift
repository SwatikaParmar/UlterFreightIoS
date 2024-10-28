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

    @IBOutlet weak var txt_FuelType : CocoaTextField!
    @IBOutlet weak var txt_VehicleNo : CocoaTextField!
    @IBOutlet weak var txt_DateFuel : CocoaTextField!
    @IBOutlet weak var txt_Quantity : CocoaTextField!
    @IBOutlet weak var txt_Amount : CocoaTextField!
    @IBOutlet weak var txt_StationName : CocoaTextField!
    @IBOutlet weak var txt_State : CocoaTextField!
    @IBOutlet weak var btn_Gender : UIButton!
    @IBOutlet weak var img_Front : UIImageView!

    var date_LastService = Date()
    let dropGender = DropDown()
    var genderStr = ""
    var imgLicense = UIImage()
    var img_UserProfile = UIImage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDropDowns()
        txt_FuelType.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_FuelType.placeholder = "Fuel Type"
        txt_FuelType.autocapitalizationType = .none
        applyStyle(to: txt_FuelType)
        
        
        txt_VehicleNo.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_VehicleNo.placeholder = "Vehicle No"
        txt_VehicleNo.autocapitalizationType = .none
        applyStyle(to: txt_VehicleNo)
        
        txt_DateFuel.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_DateFuel.placeholder = "Fuel Date"
        txt_DateFuel.autocapitalizationType = .none
        applyStyle(to: txt_DateFuel)
        
        txt_Quantity.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_Quantity.placeholder = "Quantity (gallons)"
        txt_Quantity.autocapitalizationType = .none
        txt_Quantity.keyboardType = .numberPad

        applyStyle(to: txt_Quantity)
        
        txt_Amount.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_Amount.placeholder = "Amount"
        txt_Amount.autocapitalizationType = .none
        txt_Amount.keyboardType = .numberPad

        applyStyle(to: txt_Amount)
        
        txt_StationName.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_StationName.placeholder = "Station Name"
        txt_StationName.autocapitalizationType = .none
        applyStyle(to: txt_StationName)
        
        
        txt_State.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_State.placeholder = "State"
        txt_State.autocapitalizationType = .none
        applyStyle(to: txt_State)

        // Do any additional setup after loading the view.
    }
    
    func setupDropDowns() {
        
        let actionTitleFont = UIFont(name: FontName.Inter.Medium, size: CGFloat(16)) ?? UIFont.systemFont(ofSize: CGFloat(16), weight: .medium)
        DropDown.appearance().backgroundColor = AppColor.AppThemeColor
        DropDown.appearance().selectionBackgroundColor =  AppColor.AppThemeColor
        DropDown.appearance().cornerRadius = 10
        DropDown.appearance().textColor = UIColor.white
        DropDown.appearance().textFont =  actionTitleFont
        setupGenderDropDown()
    }
    func setupGenderDropDown() {
        dropGender.anchorView = btn_Gender
        dropGender.bottomOffset = CGPoint(x: 5, y: btn_Gender.bounds.height - 10)
        dropGender.direction = .bottom

        dropGender.dataSource = [
            "Diesel",
            "Petrol",
            "Gasohol",
            "Propane",
            "Ethanol",
            "Methanol",
            "Electricity",

            ]
        
        dropGender.selectionAction = { [weak self] (index, item) in
            if index == 0 {
                self!.genderStr = "Diesel"
            }
            else if (index == 1){
                 self!.genderStr = "Petrol"
            }
            else if (index == 2){
                 self!.genderStr = "Gasohol"
            }
            else if (index == 3){
                 self!.genderStr = "Propane"
            }
            else if (index == 4){
                 self!.genderStr = "Ethanol"
            }
            else if (index == 5){
                 self!.genderStr = "Methanol"
            }
            else if (index == 6){
                 self!.genderStr = "Electricity"
            }
            self!.txt_FuelType.text = item
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

        dropGender.show()
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
        controller.topTitle = "Select State"
        controller.countryID = countryId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func Update(_ sender: Any) {
        self.view.endEditing(true)
   
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
     
        self.dismiss(animated: false, completion: { [weak self] in
        })
    }
}
