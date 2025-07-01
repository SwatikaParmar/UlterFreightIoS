//
//  UpadteDocumentViewController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 24/10/24.
//

import UIKit
import CocoaTextField
import CountryPickerView
import DropDown
import AVFoundation
import Photos
import SDWebImage

class UpadteDocumentViewController: UIViewController {
    @IBOutlet weak var txt_LicenseNumber : CocoaTextField!
    @IBOutlet weak var txt_LicenseExpirationDate : CocoaTextField!
    
    @IBOutlet weak var btn_LicenseExpirationDate : UIButton!

    @IBOutlet weak var img_Front : UIImageView!
    
    var date_LastService = Date()
    var imgLicense = UIImage()
    var img_UserProfile = UIImage()
    var isImageTaken = false
    var isLicenseImageTaken = false

    
    var driverId: String = ""
    var driverGender: String = ""
    var driverName: String = ""
    var address: String = ""
    var city: String = ""
    var stateId: Int = 0
    var countryId: Int = 0
    var postalCode: String = ""
    var dob: String = ""
    var contactPhone: String = ""
    var contactEmail: String = ""
    var lastServiceDate: String = ""
    var dialCode: String = ""
    var phoneNumber: String = ""
    var email: String = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()

        txt_LicenseNumber.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_LicenseNumber.placeholder = "License Number"
        txt_LicenseNumber.autocapitalizationType = .none
        applyStyle(to: txt_LicenseNumber)
        
        txt_LicenseExpirationDate.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_LicenseExpirationDate.placeholder = "License Expiration Date"
        txt_LicenseExpirationDate.autocapitalizationType = .none
        applyStyle(to: txt_LicenseExpirationDate)
        
        
        if let retrievedDriver = getDriverDetails() {
            self.txt_LicenseExpirationDate.text = retrievedDriver.licenseExpirationDate
            self.txt_LicenseNumber.text = retrievedDriver.licenseNumber
            
            
            var urlString = retrievedDriver.licenseDocumentURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            urlString =  GlobalConstants.BASE_IMAGE_URL + urlString
            
            img_Front?.sd_setImage(with: URL.init(string:(urlString)),
                                   placeholderImage: UIImage(named: ""),
                                   options: .refreshCached,
                                   completed: nil)
       
        }
    }
    
    
    
    //Hide KeyBoard When touche on View
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view .endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    
    @IBAction func btnBackPreessed(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func LicensePressed(_ sender: Any){
        self.view.endEditing(true)

        addImage(sender as! UIButton)
    }
    
    @IBAction func LicenseExpirationDate(_ sender: Any) {
        self.view.endEditing(true)
        
        self.addPickerLicenseExpirationDate()
        
    }
    
    @IBAction func Update(_ sender: Any){
        self.update_User()
        
    }
    func addPickerLicenseExpirationDate(){
        let alert = UIAlertController(style: .alert, title: "Select License Expiration Date")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        
        alert.setTitle(font: UIFont(name: FontName.Inter.Medium, size: 14)!, color: AppColor.AppThemeColor)
        
        alert.view.tintColor = AppColor.AppThemeColor
        
        let date = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        date_LastService = date ?? Date()
        
        if self.txt_LicenseExpirationDate.text == ""
        {
            date_LastService = date ?? Date()
        }
        else
        {
            let isoDate = txt_LicenseExpirationDate.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            date_LastService = dateFormatter.date(from:isoDate ?? "13-08-2002") ?? Date()
            
        }
        
        alert.addDatePicker(mode: .date, date: date_LastService, minimumDate: date_LastService, maximumDate: nil) { date in
            self.date_LastService = date
        }
        alert.addAction( title: "OK", style: .default, isEnabled: true) { (action) in
            
            self.txt_LicenseExpirationDate.text = "".convertToDDMMyyyy(date:self.date_LastService)
            
        }
        alert.addAction(title: "Cancel", style: .cancel){ (action) in
            
        }
        alert.show()
    }

    func update_User(){
        
        guard let licenseNumber = txt_LicenseNumber.text, !licenseNumber.isEmpty else {
            self.MessageAlertError(message: "Please enter license number")
            return
           }
        
        guard let licenseExpirationDate = txt_LicenseExpirationDate.text, !licenseExpirationDate.isEmpty else {
            self.MessageAlertError(message: "Please enter license expiration date")
            return
           }
        
        let params =
                [
                   "driverId": driverId,
                   "driverGender": driverGender,
                   "driverName": driverName,
                   "address": address,
                   "city": city,
                   "stateId": stateId,
                   "countryId": countryId,
                   "postalCode": postalCode,
                   "dob": dob,
                   "licenseExpirationDate": licenseExpirationDate,
                   "licenseNumber": licenseNumber,
                   "contactPhone": contactPhone,
                   "contactEmail": contactEmail,
                   "lastServiceDate": lastServiceDate,
                   "dialCode": dialCode,
                   "phoneNumber": phoneNumber,
                   "email": email
               ] as [String : Any]
           
     
        UpdateProfileRequest.shared.updateUser(requestParams: params) { (obj, message, success,Verification) in
     
                 if success {
                     if self.isLicenseImageTaken {
                         self.updateDocument(message!)
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
    
    
    func updateDocument(_ message:String){
        var fileName = ""
        fileName =  "iOS" + NSUUID().uuidString + ".jpeg"
        let apiURL = String("\("Base".UploadDriverLicenseDocument)")
        AlamofireRequest().uploadImageRemote(urlString: apiURL, image:  self.imgLicense, name: fileName , userID:  UserDefaults.standard.string(forKey: Constants.userId) ?? "", key: "LicenseDocument"){ data, error -> Void in
            if let nonEmptyString = data, !nonEmptyString.isEmpty {
                self.uploadProfileImageApi("")
            }
        }
    }
    
    func uploadProfileImageApi(_ message:String){
        
        self.view.endEditing(true)
        
        if !isImageTaken {
            self.showAlertWith(message)
        }
        else{
            var fileName = ""
            fileName =  "iOS" + NSUUID().uuidString + ".jpeg"
            let apiURL = String("\("Base".UploadDriverProfilePic)")
            AlamofireRequest().uploadImageRemote(urlString: apiURL, image:  self.img_UserProfile, name: fileName , userID:  UserDefaults.standard.string(forKey: Constants.userId) ?? "", key: "DriverImage"){ data, error -> Void in
                if let nonEmptyString = data, !nonEmptyString.isEmpty {

                    self.showAlertWith(message)

                }
            }
        }
    }
    
    func showAlertWith(_ message:String) {
        let alert = UIAlertController(title: "Success!", message: message, preferredStyle: .alert)

          let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
              RootControllerManager().SetRootViewController()
               
          }

          alert.addAction(confirmAction)

        self.present(alert, animated: true, completion: nil)
    }
    
    }
    


extension UpadteDocumentViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
        isLicenseImageTaken = true
     
        self.dismiss(animated: false, completion: { [weak self] in
        })
    }
}

class RectangularDashedView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    @IBInspectable var dashWidth: CGFloat = 0
    @IBInspectable var dashColor: UIColor = .clear
    @IBInspectable var dashLength: CGFloat = 0
    @IBInspectable var betweenDashesSpace: CGFloat = 0
    
    var dashBorder: CAShapeLayer?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dashBorder?.removeFromSuperlayer()
        let dashBorder = CAShapeLayer()
        dashBorder.lineWidth = dashWidth
        dashBorder.strokeColor = dashColor.cgColor
        dashBorder.lineDashPattern = [dashLength, betweenDashesSpace] as [NSNumber]
        dashBorder.frame = bounds
        dashBorder.fillColor = nil
        if cornerRadius > 0 {
            dashBorder.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        } else {
            dashBorder.path = UIBezierPath(rect: bounds).cgPath
        }
        layer.addSublayer(dashBorder)
        self.dashBorder = dashBorder
    }
}

