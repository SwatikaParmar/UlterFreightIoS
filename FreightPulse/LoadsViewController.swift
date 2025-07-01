//
//  LoadsViewController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 25/09/24.
//

import UIKit

class LoadsViewController: UIViewController {

    @IBOutlet weak var lbePurchace: UILabelX!
    @IBOutlet weak var lbeUpcoming: UILabelX!
    @IBOutlet weak var lbeCompleted: UILabelX!
    
    @IBOutlet weak var btnSingleDay: UIButton!
    @IBOutlet weak var btnMultiDays: UIButton!
    
    @IBOutlet weak var tableViewLoad : UITableView!
    var arrayActiveData : [DriverLoadsArray] = []

    var singleDays = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        lbeUpcoming.backgroundColor = AppColor.AppThemeColor
        lbeCompleted.backgroundColor = UIColor.clear
        lbeUpcoming.textColor = UIColor.white
        lbeCompleted.textColor = AppColor.BlackColor

        lbeUpcoming.layer.cornerRadius = 17
        lbeUpcoming.clipsToBounds = true
        lbeUpcoming.layer.masksToBounds = true
        
        lbeCompleted.layer.cornerRadius = 17
        lbeCompleted.clipsToBounds = true
        lbeCompleted.layer.masksToBounds = true
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        GetActiveData(false)
    }
    
    @IBAction func connected_SingleDay(_ sender: Any) {
        
        singleDays = true

        lbeUpcoming.backgroundColor = AppColor.AppThemeColor
        lbeCompleted.backgroundColor = UIColor.clear
        lbeUpcoming.textColor = UIColor.white
        lbeCompleted.textColor = AppColor.BlackColor
        
        self.arrayActiveData.removeAll()
        self.tableViewLoad.reloadData()
        
        
        GetActiveData(true)
        self.tableViewLoad.reloadData()
        
    }
    
    @IBAction func connected_MultiDays(_ sender: Any) {
        singleDays = false
        
        lbeUpcoming.backgroundColor = UIColor.clear
        lbeUpcoming.textColor = AppColor.BlackColor
        lbeCompleted.textColor = UIColor.white
        lbeCompleted.backgroundColor = AppColor.AppThemeColor
        
        self.arrayActiveData.removeAll()
        self.tableViewLoad.reloadData()
        
        GetActiveData(true)
        self.tableViewLoad.reloadData()


    }
    
    
    @objc func switchValueChanged(_ sender: UISwitch) {

        let params = [
            "loadFleetDetailId": arrayActiveData[sender.tag].loadFleetDetailId,
            "status": "PickedUp",
            ] as [String : Any]
           
        UpdateLoadTrackingStatusRequest.shared.UpdateLoadTrackingStatusAPI(requestParams: params) { (obj, message, success,Verification) in
            NotificationAlert().NotificationAlert(titles: message ?? "isAvailable")
            self.GetActiveData(true)

            }
        }
    
    func GetActiveData(_ isLoader:Bool){
        
        var dict : [String:Any] = [
            "type": "Upcoming"
        ]
        
        if !singleDays {
            dict  = [
                "type": "Completed"
            ] as [String:Any]
        }
    
        GetDriverLoadsRequest.shared.GetDriverLoadsRequestAPI(requestParams:dict, isLoader) { (message,status,dictionary) in
            if status {
                if dictionary != nil{
                    self.arrayActiveData = dictionary ??  self.arrayActiveData
                    self.tableViewLoad.reloadData()
                }
            }
        }
    }
    
}
extension LoadsViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 {
            if singleDays{
                return self.arrayActiveData.count
            }
            return 0
            
        }
        if !singleDays{
            return self.arrayActiveData.count
        }
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell = tableViewLoad.dequeueReusableCell(withIdentifier: "MyJobsAcceptTableViewCell") as! MyJobsAcceptTableViewCell
            
            cell.lbe_SType.text = "Upcoming"
            cell.lbe_SType.textColor =  UIColor(red: 0.0 / 255.0, green: 122.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
            cell.viewBg.layer.borderWidth = 0
            cell.viewBg.layer.borderColor = UIColor.white.cgColor
            cell.btnFuelList.isHidden = true
            cell.imgFuel.isHidden = true
            
            cell.switchOn.isHidden = false
            cell.switchOn.tag = indexPath.row
            cell.switchOn.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            
            cell.lbe_Pickup.text = self.arrayActiveData[indexPath.row].pickupLocation
            cell.lbe_Delivery.text = self.arrayActiveData[indexPath.row].deliveryLocation
            
            cell.lbe_DateTime.text = "".convertddMMMM(pickupDate: self.arrayActiveData[indexPath.row].pickupDate, pickupTime: self.arrayActiveData[indexPath.row].pickupTime)
            
            
            cell.lbe_OrderNo.text = String(format: "%d", self.arrayActiveData[indexPath.row].loadId)
            return cell
        }
        else{
            let cell = tableViewLoad.dequeueReusableCell(withIdentifier: "MyJobsAcceptTableViewCell") as! MyJobsAcceptTableViewCell
            
            cell.lbe_SType.text = "Completed"
            cell.lbe_SType.textColor = UIColor.brown
            cell.viewBg.layer.borderWidth = 0
            cell.viewBg.layer.borderColor = UIColor.white.cgColor
            cell.btnFuelList.isHidden = false
            cell.imgFuel.isHidden = false
            cell.btnFuelList.tag = indexPath.row
            cell.imgFuel.tintColor = .brown
            cell.btnFuelList.addTarget(self, action: #selector(connected_AddFuel(sender:)), for: .touchUpInside)
            cell.switchOn.isHidden = true
            
            cell.lbe_Pickup.text = self.arrayActiveData[indexPath.row].pickupLocation
            cell.lbe_Delivery.text = self.arrayActiveData[indexPath.row].deliveryLocation
            
            cell.lbe_DateTime.text = "".convertddMMMM(pickupDate: self.arrayActiveData[indexPath.row].deliveryDate, pickupTime: self.arrayActiveData[indexPath.row].deliveryTime)
            cell.lbe_OrderNo.text = String(format: "%d", self.arrayActiveData[indexPath.row].loadId)


            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        
        if indexPath.section == 0 {
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let controller = (storyBoard.instantiateViewController(withIdentifier: "ParcelDetailsRequestController") as?  ParcelDetailsRequestController)!
            
            controller.loadId = self.arrayActiveData[indexPath.row].loadId
            controller.fleetId = self.arrayActiveData[indexPath.row].fleetId
            controller.arrayActiveData = self.arrayActiveData
            controller.index = indexPath.row
            
            self.parent?.navigationController?.pushViewController(controller, animated: true)
        }
        if indexPath.section == 1 {
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let controller = (storyBoard.instantiateViewController(withIdentifier: "ParcelDetailsRequestController") as?  ParcelDetailsRequestController)!
            
            controller.loadId = self.arrayActiveData[indexPath.row].loadId
            controller.fleetId = self.arrayActiveData[indexPath.row].fleetId
            controller.arrayActiveData = self.arrayActiveData
            controller.index = indexPath.row
            
            self.parent?.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return 200
        }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return UITableView.automaticDimension
        }
    
    
    
    @objc func connected_AddFuel(sender: UIButton){
        
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        let controller = (storyBoard.instantiateViewController(withIdentifier: "PurchaseFuelListViewController") as?  PurchaseFuelListViewController)!
        controller.IsActive = 0
        controller.fleetId = self.arrayActiveData[sender.tag].fleetId
        controller.loadId = self.arrayActiveData[sender.tag].loadId
        self.parent?.navigationController?.pushViewController(controller, animated: true)

    }
    
}
