//
//  DocumentsViewController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 25/09/24.
//

import UIKit
import AVFoundation
import Photos
import SDWebImage

class DocumentsViewController: UIViewController {

    @IBOutlet weak var lbeTitle: UILabelX!
    
    @IBOutlet weak var tableViewDocument: UITableView!

    var imgLicense = UIImage()
    var img_UserProfile = UIImage()
    
    var arrayDocumentData : [DocumentDataArray] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        GetDocumentListData(true)
    }
    
    func GetDocumentListData(_ isLoader:Bool){
    
        DocumentListRequest.shared.DocumentListRequestAPI(requestParams:0, isLoader) { (message,status,dictionary) in
            if status {
                if dictionary != nil{
                    self.arrayDocumentData = dictionary ??  self.arrayDocumentData
                    self.tableViewDocument.reloadData()
                }
            }
        }
    }
    
    @IBAction func LicensePressed(_ sender: Any){
        self.view.endEditing(true)

       // addImage(sender as! UIButton)
    }
        
}

extension DocumentsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayDocumentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableViewDocument.dequeueReusableCell(withIdentifier: "DocumentTableViewCell") as! DocumentTableViewCell
        
        
        cell.lbe_Name.text = self.arrayDocumentData[indexPath.row].documentName
        
        var urlString = self.arrayDocumentData[indexPath.row].documentUrl.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        urlString =  GlobalConstants.BASE_IMAGE_URL + urlString
        
        cell.img_Front?.sd_setImage(with: URL.init(string:(urlString)),
                               placeholderImage: UIImage(named: "imgPlaceH"),
                               options: .refreshCached,
                               completed: nil)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 260
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        let controller = (storyBoard.instantiateViewController(withIdentifier: "FuelReceiptViewController") as?  FuelReceiptViewController)!
        controller.urlString = self.arrayDocumentData[indexPath.row].documentUrl.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
         
        controller.titleString = self.arrayDocumentData[indexPath.row].documentName
        
        self.parent?.navigationController?.pushViewController(controller, animated: true)
    }
}

extension DocumentsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
       // img_Front.image = originalImage
     
        self.dismiss(animated: false, completion: { [weak self] in
        })
    }
}


class DocumentTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var img_Front: UIImageView!
    @IBOutlet weak var lbe_Name: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}
