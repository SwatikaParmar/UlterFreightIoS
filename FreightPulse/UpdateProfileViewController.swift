//
//  UpdateProfileViewController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 25/09/24.
//

import UIKit
import CocoaTextField
import CountryPickerView
import DropDown
import AVFoundation
import Photos

class UpdateProfileViewController: UIViewController ,CountriesSelectDelegate {
    @IBOutlet weak var lbeTitle: UILabelX!

    @IBOutlet weak var txt_Name : CocoaTextField!
    @IBOutlet weak var txt_Gender : CocoaTextField!
    @IBOutlet weak var txt_Dob : CocoaTextField!
    @IBOutlet weak var txt_Phone : CocoaTextField!
    @IBOutlet weak var txt_Email : CocoaTextField!
    
    
    @IBOutlet weak var txt_PhoneCont : CocoaTextField!
    @IBOutlet weak var txt_EmailCont : CocoaTextField!
    @IBOutlet weak var txt_Address : CocoaTextField!
    @IBOutlet weak var txt_City : CocoaTextField!
    @IBOutlet weak var txt_Country : CocoaTextField!
    @IBOutlet weak var txt_State : CocoaTextField!
    @IBOutlet weak var txt_PostalCode : CocoaTextField!
    @IBOutlet weak var txt_LastServiceDate : CocoaTextField!
    @IBOutlet weak var imgUserProfile : UIImageView!

    
    @IBOutlet weak var countryPicker: CountryPickerView!
    @IBOutlet weak var countryPickerCont: CountryPickerView!

    @IBOutlet weak var btn_Gender : UIButton!
    @IBOutlet weak var btn_Dob : UIButton!

    let dropGender = DropDown()
    var titleStr = ""
    var genderStr = "Male"
    var countryId = 231
    var stateId = 3923
    var date_DOB = Date()
    var date_LastService = Date()
    var img_UserProfile = UIImage()
    var phoneCode = ""
    var isImageTaken = false
    var isImageUpload = false
    var isImageGallery = false




    override func viewDidLoad() {
        super.viewDidLoad()
        showDataOnProfile()
        self.countryPicker.font = UIFont(name: FontName.Inter.Medium, size: 14)!
        self.countryPicker.delegate = self
        self.phoneCode = "+91"
        countryPicker.setCountryByCode("IN")
        countryPicker.showCountryCodeInView = false
        
        self.countryPickerCont.font = UIFont(name: FontName.Inter.Medium, size: 14)!
        self.countryPickerCont.delegate = self
        self.phoneCode = "+91"
        countryPickerCont.setCountryByCode("IN")
        countryPickerCont.showCountryCodeInView = false

        lbeTitle.text = titleStr
        
        txt_Name.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_Name.placeholder = "Name"
        txt_Name.autocapitalizationType = .none
        applyStyle(to: txt_Name)
        
        txt_Gender.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_Gender.placeholder = "Gender"
        txt_Gender.autocapitalizationType = .none
        applyStyle(to: txt_Gender)
        
        txt_Dob.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_Dob.placeholder = "DOB"
        txt_Dob.autocapitalizationType = .none
        applyStyle(to: txt_Dob)
        
        txt_Email.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_Email.placeholder = "Email"
        txt_Email.keyboardType = .emailAddress
        txt_Email.autocapitalizationType = .none
        applyStyle(to: txt_Email)
        
        
        txt_Phone.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_Phone.placeholder = "Phone number"
        txt_Phone.keyboardType = .phonePad
        txt_Phone.autocapitalizationType = .none
        applyStyle(to: txt_Phone)
        
        
        txt_PhoneCont.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_PhoneCont.placeholder = "Phone number"
        txt_PhoneCont.keyboardType = .phonePad
        txt_PhoneCont.autocapitalizationType = .none
        applyStyle(to: txt_PhoneCont)
        
        txt_EmailCont.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_EmailCont.placeholder = "Email"
        txt_EmailCont.keyboardType = .emailAddress
        txt_EmailCont.autocapitalizationType = .none
        applyStyle(to: txt_EmailCont)
        
        txt_Address.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_Address.placeholder = "Address"
        txt_Address.autocapitalizationType = .none
        applyStyle(to: txt_Address)
        
        txt_City.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_City.placeholder = "City"
        txt_City.autocapitalizationType = .none
        applyStyle(to: txt_City)
        
        txt_Country.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_Country.placeholder = "Country"
        txt_Country.autocapitalizationType = .none
        applyStyle(to: txt_Country)
        
        txt_State.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_State.placeholder = "State"
        txt_State.autocapitalizationType = .none
        applyStyle(to: txt_State)
        
        
        txt_State.text = "California"
        txt_Country.text = "United States";
        
        txt_PostalCode.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_PostalCode.placeholder = "Postal Code"
        txt_PostalCode.autocapitalizationType = .none
        applyStyle(to: txt_PostalCode)
        
        
        txt_LastServiceDate.font = UIFont(name: FontName.Inter.Medium, size: 15.5)!
        txt_LastServiceDate.placeholder = "Last Service Date"
        txt_LastServiceDate.autocapitalizationType = .none
        applyStyle(to: txt_LastServiceDate)
        
        setupDropDowns()

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
            "Male",
            "Female",
            "Other"
            ]
        
        dropGender.selectionAction = { [weak self] (index, item) in
            if index == 0 {
                self!.genderStr = "Male"
            }
            else if (index == 1){
                 self!.genderStr = "Female"
            }
            else{
                self!.genderStr = "Other"
            }
            self!.txt_Gender.text = item
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
        self.view.endEditing(true)
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func gender(_ sender: Any) {
        self.view.endEditing(true)
        dropGender.show()
    }
    
    @IBAction func DOB(_ sender: Any) {
        self.view.endEditing(true)
        addPickerDOB()
    }
    
    
    
    @IBAction func Country(_ sender: Any) {
        self.view.endEditing(true)
        let controller:CountriesListController =  UIStoryboard(storyboard: .main).initVC()
        controller.delegate = self
        controller.topTitle = "Select Country"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func State(_ sender: Any) {
        self.view.endEditing(true)
        let controller:CountriesListController =  UIStoryboard(storyboard: .main).initVC()
        controller.delegate = self
        controller.topTitle = "Select State"
        controller.countryID = countryId
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    @IBAction func LastServiceDate(_ sender: Any) {
        self.view.endEditing(true)
        addPickerLastServiceDate()
    }
    
    
    @IBAction func Update(_ sender: Any){
        if let retrievedDriver = getDriverDetails() {
            
            if retrievedDriver.driverImage.isEmpty {
                if !isImageGallery{
                    self.MessageAlertError(message: "Please select profile image")
                    return
                }
            }
        }
        
        guard let name = txt_Name.text, !name.isEmpty else {
            self.MessageAlertError(message: "Please enter full name")
            return
           }
        
        guard let gender = txt_Gender.text, !gender.isEmpty else {
            self.MessageAlertError(message: "Please select gender")
            return
           }
        guard let dob = txt_Dob.text, !dob.isEmpty else {
            self.MessageAlertError(message: "Please select dob")
            return
           }
        
        guard let phone = txt_Phone.text, !phone.isEmpty else {
            self.MessageAlertError(message: "Please enter phone number")
            return
           }
        
        if phone.count < 9 {
            self.MessageAlertError(message: "Please enter valid phone number")
            return
        }
        
        guard let email = txt_Email.text, !email.isEmpty else {
            self.MessageAlertError(message:"Please enter email")
            return
           }
        
        if email.isValidEmail() {
        }
        else{
            self.MessageAlertError(message: "Please enter valid email address")
            return
        }
        
        guard let phoneCont = txt_PhoneCont.text, !phoneCont.isEmpty else {
            self.MessageAlertError(message: "Please enter contact phone number")
            return
           }
        
        if phoneCont.count < 9 {
            self.MessageAlertError(message: "Please enter valid contact phone number")
            return
        }
        
        guard let emailCont = txt_EmailCont.text, !emailCont.isEmpty else {
            self.MessageAlertError(message: "Please enter contact email")
            return
           }
        
        if emailCont.isValidEmail() {
        }
        else{
            self.MessageAlertError(message: "Please enter valid contact email address")
            return
        }
       
        guard let address = txt_Address.text, !address.isEmpty else {
            self.MessageAlertError(message: "Please enter address")
            return
           }
        
        guard let city = txt_City.text, !city.isEmpty else {
            self.MessageAlertError(message: "Please enter city")
            return
           }
        
        guard let state = txt_State.text, !state.isEmpty else {
            self.MessageAlertError(message: "Please enter state")
            return
           }
        
        guard let country = txt_Country.text, !country.isEmpty else {
            self.MessageAlertError(message: "Please enter country")
            return
           }
        
        guard let postalCode = txt_PostalCode.text, !postalCode.isEmpty else {
            self.MessageAlertError(message: "Please enter postal code")
            return
           }
        
        guard let last = txt_LastServiceDate.text, !last.isEmpty else {
            self.MessageAlertError(message: "Please enter last service date")
            return
           }
        
        
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        let controller = (storyBoard.instantiateViewController(withIdentifier: "UpadteDocumentViewController") as?  UpadteDocumentViewController)!
        
        controller.driverId = userId()
        controller.driverGender = genderStr
        controller.driverName = name
        controller.address = address
        controller.city = city
        controller.stateId = stateId
        controller.countryId = countryId
        controller.postalCode = postalCode
        controller.dob = dob
        controller.contactPhone = phoneCont
        controller.contactEmail = emailCont
        controller.lastServiceDate = last
        controller.dialCode = phoneCode
        controller.phoneNumber = phone
        controller.email = email
        controller.img_UserProfile = img_UserProfile
        
        if self.isImageUpload {
            controller.isImageTaken = false
        }
        else{
            controller.isImageTaken = isImageTaken

        }
        
        
        
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func btnUserProfilePressed(_ sender: Any){
        self.view.endEditing(true)

        addImage(sender as! UIButton)
    }
    
    func chooseState(_ id: Int, _ name: String) {
        txt_State.text = name
        stateId = id
    }

    func chooseCountries(_ id: Int, _ name: String) {
        
        txt_Country.text = name
        countryId = id
        txt_State.text = ""
    }
    
    
    func addPickerDOB(){
        let alert = UIAlertController(style: .alert, title: "Select Date of Birth")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        
        alert.setTitle(font: UIFont(name: FontName.Inter.Medium, size: 14)!, color: AppColor.AppThemeColor)
        
        alert.view.tintColor = AppColor.AppThemeColor
        
        let date = Calendar.current.date(byAdding: .year, value: -2, to: Date())
        date_DOB = date ?? Date()
        
        if self.txt_Dob.text == ""
        {
            date_DOB = date ?? Date()
        }
        else
        {
            let isoDate = txt_Dob.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            date_DOB = dateFormatter.date(from:isoDate ?? "13-08-2002") ?? Date()
            
        }
        
        alert.addDatePicker(mode: .date, date: date_DOB, minimumDate: nil, maximumDate: date) { date in
            self.date_DOB = date
        }
        alert.addAction( title: "OK", style: .default, isEnabled: true) { (action) in
            
            self.txt_Dob.text = "".convertToDDMMyyyy(date:self.date_DOB)
            
        }
        alert.addAction(title: "Cancel", style: .cancel){ (action) in
            
        }
        alert.show()
    }
    
    func addPickerLastServiceDate(){
        let alert = UIAlertController(style: .alert, title: "Select Date")
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.white
        
        alert.setTitle(font: UIFont(name: FontName.Inter.Medium, size: 14)!, color: AppColor.AppThemeColor)
        
        alert.view.tintColor = AppColor.AppThemeColor
        
        let date = Calendar.current.date(byAdding: .year, value: 0, to: Date())
        date_LastService = date ?? Date()
        
        if self.txt_LastServiceDate.text == ""
        {
            date_LastService = date ?? Date()
        }
        else
        {
            let isoDate = txt_LastServiceDate.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            date_LastService = dateFormatter.date(from:isoDate ?? "13-08-2002") ?? Date()
            
        }
        
        alert.addDatePicker(mode: .date, date: date_LastService, minimumDate: nil, maximumDate: Date()) { date in
            self.date_LastService = date
        }
        alert.addAction( title: "OK", style: .default, isEnabled: true) { (action) in
            
            self.txt_LastServiceDate.text = "".convertToDDMMyyyy(date:self.date_LastService)
            
        }
        alert.addAction(title: "Cancel", style: .cancel){ (action) in
            
        }
        alert.show()
    }
    
    func uploadProfileImageApi(){
        
        self.view.endEditing(true)
        
        if isImageTaken {
            isImageGallery = true
        }
        else{
            var fileName = ""
            fileName =  "iOS" + NSUUID().uuidString + ".jpeg"
            let apiURL = String("\("Base".UploadDriverProfilePic)")
            AlamofireRequest().uploadImageRemote(urlString: apiURL, image:  self.img_UserProfile, name: fileName , userID:  UserDefaults.standard.string(forKey: Constants.userId) ?? "", key: "DriverImage"){ data, error -> Void in
                if ((data?.isEmpty) == nil){
                    self.isImageUpload = true
                    self.isImageGallery = true

                }
            }
        }
    }
    
    func showDataOnProfile(){
        let phoneNo = UserDefaults.standard.string(forKey: Constants.phoneNumber)
        self.txt_Phone.text = phoneNo
        
        let emailS = UserDefaults.standard.string(forKey: Constants.email)
        self.txt_Email.text = emailS
        
        if let retrievedDriver = getDriverDetails() {
            
            var urlString = retrievedDriver.driverImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            urlString =  GlobalConstants.BASE_IMAGE_URL + urlString
            imgUserProfile?.sd_setImage(with: URL.init(string:(urlString)),
                                   placeholderImage: UIImage(named: "placeholder_Male"),
                                   options: .refreshCached,
                                   completed: nil)
            
            if retrievedDriver.driverName.isEmpty {
                isImageTaken = true
                return
            }
            
            self.txt_Name.text = retrievedDriver.driverName
            self.txt_Gender.text = retrievedDriver.driverGender
            self.txt_PhoneCont.text = retrievedDriver.contactPhone
            self.txt_EmailCont.text = retrievedDriver.contactEmail
            self.txt_Address.text = retrievedDriver.address
            self.txt_City.text = retrievedDriver.city
            self.txt_State.text = retrievedDriver.state
            self.txt_Country.text = retrievedDriver.country
            self.txt_PostalCode.text = retrievedDriver.postalCode
            self.txt_LastServiceDate.text = retrievedDriver.lastServiceDate
            self.txt_Dob.text = retrievedDriver.dob
            countryId = retrievedDriver.countryId
            stateId = retrievedDriver.stateId
        }
    }
    
}
    

extension UpdateProfileViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
        
        self.img_UserProfile = originalImage
        imgUserProfile.image = originalImage
        imgUserProfile.layer.borderWidth = 1
        imgUserProfile.layer.cornerRadius = imgUserProfile.frame.size.width/2
        imgUserProfile.clipsToBounds = true
        uploadProfileImageApi()
     
        self.dismiss(animated: false, completion: { [weak self] in
        })
    }
}
extension UpdateProfileViewController: CountryPickerViewDelegate {
    func countryPickerView(_ countryPickerView: CountryPickerView, didSelectCountry country: Country) {
        // Only countryPickerInternal has it's delegate set
        let message = "Name: \(country.name) \nCode: \(country.code) \nPhone: \(country.phoneCode)"
        phoneCode = country.phoneCode
        print(message)
    }
}
extension UpdateProfileViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if range.location == 0 && string == " "  {
               return false
           }
        
        if string == ""{
            return true
        }
        if textField.text == "" && string == " "{
            return false
        }
      
        if textField.text?.count ?? 0 > 100{
            return false
        }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         textField.resignFirstResponder()
         return true
     }
    
    func validatePhoneNumber(textField: UITextField) -> Bool {
        guard let phone = textField.text, !phone.isEmpty else {
            print("Phone number field is empty")
            return false
        }
        
        // Regular expression for allowing only digits (10 digits for typical phone number)
        let phoneRegEx = "^[0-9]{10}$"
        let phonePred = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        
        if !phonePred.evaluate(with: phone) {
            print("Invalid phone number. Must be 10 digits.")
            return false
        }
        
        return true
    }
    
    func validateEmail(textField: UITextField) -> Bool {
        guard let email = textField.text, !email.isEmpty else {
            print("Email field is empty")
            return false
        }
        
        // Regular expression for validating email format
        let emailRegEx = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        if !emailPred.evaluate(with: email) {
            print("Invalid email format")
            return false
        }
        
        return true
    }
}
