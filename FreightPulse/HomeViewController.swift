//
//  HomeViewController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 17/09/24.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var tableViewHome : UITableView!
    @IBOutlet weak var lbeName : UILabel!
    @IBOutlet weak var lbeStatus : UILabel!
    @IBOutlet weak var imgUser : UIImageView!
    @IBOutlet weak var mySwitch : UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        mySwitch.addTarget(self, action: #selector(switchToggled(_:)), for: .valueChanged)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        getProfileAPI()
    }
    
    @IBAction func Menu_Action(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SideMenuUpdate"), object: nil)
        sideMenuController?.showLeftView(animated: true)
    }
    
    @IBAction func notification(_ sender: Any) {
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        let controller = (storyBoard.instantiateViewController(withIdentifier: "NotificationViewController") as?  NotificationViewController)!
        self.parent?.navigationController?.pushViewController(controller, animated: true)

    }
    
    func getProfileAPI(){
        
        if let retrievedDriver = getDriverDetails() {
          
            self.lbeName.text = retrievedDriver.driverName
         
        }
        
        GetProfileRequest.shared.getProfileAPI(requestParams:[:], false) { (user,message,isStatus) in
            if isStatus {
                if user != nil{
                    
                    
                    if let retrievedDriver = getDriverDetails() {
                        self.mySwitch.isOn = retrievedDriver.isAvailable
                        if retrievedDriver.isAvailable {
                            self.lbeStatus.text = "Available"
                            self.lbeStatus.textColor = .green
                        }
                        else{
                            self.lbeStatus.text = "Not Available"
                            self.lbeStatus.textColor = .red

                        }
                        self.lbeName.text = retrievedDriver.driverName
                        var urlString = retrievedDriver.driverImage.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                        urlString =  GlobalConstants.BASE_IMAGE_URL + urlString
                        
                        self.imgUser?.sd_setImage(with: URL.init(string:(urlString)),
                                               placeholderImage: UIImage(named: "placeholder_Male"),
                                               options: .refreshCached,
                                               completed: nil)
                    }
                    
                }
            }
        }
    }
    
    @objc func switchToggled(_ sender: UISwitch) {
            if sender.isOn {
                UpdateDriverAvailability(true)
                lbeStatus.text = "Available"
                self.lbeStatus.textColor = .green

            } else {
                UpdateDriverAvailability(false)
                lbeStatus.text = "Not Available"
                self.lbeStatus.textColor = .red

            }
        }
    
    
    func UpdateDriverAvailability(_ isAvailable:Bool)
    {
        
        let params = [
                        "driverId": userId(),
                        "isAvailable": isAvailable,
                        ] as [String : Any]
           
     
        UpdateDriverAvailabilityRequest.shared.UpdateDriverAvailabilityAPI(requestParams: params) { (obj, message, success,Verification) in
            NotificationAlert().NotificationAlert(titles: message ?? "isAvailable")
    
            }
        }
}
extension HomeViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        
        let cell = tableViewHome.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
        
        if indexPath.row == 0
        {
            cell.lbeName.text = "View Assigned Loads"
        }
        if indexPath.row == 1
        {
            cell.lbeName.text = "Update Profile"
        }
        if indexPath.row == 2
        {
            cell.lbeName.text = "Purchased Fuel Receipts"
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return  100
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if indexPath.row == 0 {
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let controller = (storyBoard.instantiateViewController(withIdentifier: "AssignedViewController") as?  AssignedViewController)!
            controller.titleStr = "Assigned"
            self.parent?.navigationController?.pushViewController(controller, animated: true)
        }
        if indexPath.row == 1
        {
            
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let controller = (storyBoard.instantiateViewController(withIdentifier: "UpdateProfileViewController") as?  UpdateProfileViewController)!
            controller.titleStr = "Update Profile"
            self.parent?.navigationController?.pushViewController(controller, animated: true)
        }
        
        if indexPath.row == 2
        {
            
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let controller = (storyBoard.instantiateViewController(withIdentifier: "PurchaseFuelListViewController") as?  PurchaseFuelListViewController)!
            self.parent?.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    
}
class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var lbeName: UILabel!
    
}
