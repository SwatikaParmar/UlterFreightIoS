//
//  AssignedViewController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 25/09/24.
//

import UIKit

class AssignedViewController: UIViewController {

    var titleStr = ""
    @IBOutlet weak var lbeTitle: UILabelX!
    @IBOutlet weak var tableViewAssign : UITableView!

    var singleDays = true
    var arrayActiveData : [DriverLoadsArray] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.lbeTitle.text = titleStr
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        GetActiveData(true)
    }
    
    func GetActiveData(_ isLoader:Bool){
        
        let dict : [String:Any] = [
            "type": "Active"]
    
        GetDriverLoadsRequest.shared.GetDriverLoadsRequestAPI(requestParams:dict, isLoader) { (message,status,dictionary) in
            if status {
                if dictionary != nil{
                    self.arrayActiveData = dictionary ??  self.arrayActiveData
                    self.tableViewAssign.reloadData()
                }
            }
        }
    }
    
    @IBAction func btnBackPreessed(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
  
}
extension AssignedViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return self.arrayActiveData.count

        }
        if section == 1 {
            
            return 1

        }
        
        if section == 2 {
            if singleDays{
                return 2

            }
            return 0

        }
        if !singleDays {
            return 2
        }
        return 0

    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        if indexPath.section == 0 {
            let cell = tableViewAssign.dequeueReusableCell(withIdentifier: "MyJobsAcceptTableViewCell") as! MyJobsAcceptTableViewCell
            
            cell.lbe_SType.text = "Active"
            cell.lbe_SType.textColor =  UIColor(red: 61.0 / 255.0, green: 178.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0)
            cell.viewBg.layer.borderWidth = 2
            cell.viewBg.layer.borderColor = UIColor(red: 61.0 / 255.0, green: 178.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0).cgColor
            cell.imgFuel.tintColor = UIColor(red: 61.0 / 255.0, green: 178.0 / 255.0, blue: 75.0 / 255.0, alpha: 1.0)

            
            cell.btnFuelList.tag = indexPath.row
            cell.btnFuelList.addTarget(self, action: #selector(connected_AddFuel(sender:)), for: .touchUpInside)
            cell.btnFuelList.isHidden = false
            cell.imgFuel.isHidden = false
            
            cell.switchOn.isHidden = true
            cell.switchOn.tag = indexPath.row
            
            cell.lbe_Pickup.text = self.arrayActiveData[indexPath.row].pickupLocation
            cell.lbe_Delivery.text = self.arrayActiveData[indexPath.row].deliveryLocation
            
            cell.lbe_DateTime.text = "".convertddMMMM(pickupDate: self.arrayActiveData[indexPath.row].pickupDate, pickupTime: self.arrayActiveData[indexPath.row].pickupTime)
            
            cell.lbe_OrderNo.text = String(format: "%d", self.arrayActiveData[indexPath.row].loadId)

            return cell
        }
        if indexPath.section == 1 {
            let cell = tableViewAssign.dequeueReusableCell(withIdentifier: "SelectionViewsTableViewCell") as! SelectionViewsTableViewCell
            
            if singleDays{
                cell.lbeSingleDay.backgroundColor = AppColor.AppThemeColor
                cell.lbeMultiDays.backgroundColor = UIColor.clear
                cell.lbeSingleDay.textColor = UIColor.white
                cell.lbeMultiDays.textColor = AppColor.BlackColor

            }
            else{
                cell.lbeMultiDays.backgroundColor = AppColor.AppThemeColor
                cell.lbeSingleDay.backgroundColor = UIColor.clear
                cell.lbeSingleDay.textColor = AppColor.BlackColor
                cell.lbeMultiDays.textColor = UIColor.white

            }

            cell.lbeSingleDay.layer.cornerRadius = 17
            cell.lbeSingleDay.clipsToBounds = true
            cell.lbeSingleDay.layer.masksToBounds = true
            
            cell.lbeMultiDays.layer.cornerRadius = 17
            cell.lbeMultiDays.clipsToBounds = true
            cell.lbeMultiDays.layer.masksToBounds = true
            cell.btnMultiDays.addTarget(self, action: #selector(connected_MultiDays(sender:)), for: .touchUpInside)
            cell.btnSingleDay.addTarget(self, action: #selector(connected_SingleDay(sender:)), for: .touchUpInside)
         
            
            return cell
            
        }
        if indexPath.section == 2 {
            let cell = tableViewAssign.dequeueReusableCell(withIdentifier: "MyJobsAcceptTableViewCell") as! MyJobsAcceptTableViewCell
            
            cell.lbe_SType.text = "Upcoming"
            cell.lbe_SType.textColor =  UIColor(red: 0.0 / 255.0, green: 122.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0)
            cell.viewBg.layer.borderWidth = 0
            cell.viewBg.layer.borderColor = UIColor.white.cgColor
            cell.btnFuelList.isHidden = true
            cell.imgFuel.isHidden = true

            return cell
        }
        else{
            let cell = tableViewAssign.dequeueReusableCell(withIdentifier: "MyJobsAcceptTableViewCell") as! MyJobsAcceptTableViewCell
            
            cell.lbe_SType.text = "Completed"
            cell.lbe_SType.textColor = UIColor.brown
            cell.viewBg.layer.borderWidth = 0
            cell.viewBg.layer.borderColor = UIColor.white.cgColor
            cell.btnFuelList.isHidden = false
            cell.imgFuel.isHidden = false
            cell.btnFuelList.tag = 111
            cell.imgFuel.tintColor = .brown
            cell.btnFuelList.addTarget(self, action: #selector(connected_AddFuel(sender:)), for: .touchUpInside)

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        if indexPath.section == 0 {
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let controller = (storyBoard.instantiateViewController(withIdentifier: "ParcelDetailsRequestController") as?  ParcelDetailsRequestController)!
            
            controller.loadId = self.arrayActiveData[indexPath.row].loadId
            controller.fleetId = self.arrayActiveData[indexPath.row].fleetId
            controller.arrayActiveData = self.arrayActiveData
            controller.index = indexPath.row

            self.navigationController?.pushViewController(controller, animated: true)
        }
        
    }
    
    @objc func connected_MultiDays(sender: UIButton){
        singleDays = false
        self.tableViewAssign.reloadData()
    }
    
    @objc func connected_AddFuel(sender: UIButton){
        
            let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
            let controller = (storyBoard.instantiateViewController(withIdentifier: "AddFuelViewController") as?  AddFuelViewController)!
            controller.fleetId = self.arrayActiveData[sender.tag].fleetId
            controller.loadId = self.arrayActiveData[sender.tag].loadId
            self.navigationController?.pushViewController(controller, animated: true)
        
        
    }
    
    
    @objc func connected_SingleDay(sender: UIButton){
 
        singleDays = true
        self.tableViewAssign.reloadData()

    }
}
    

class MyJobsAcceptTableViewCell: UITableViewCell {

    @IBOutlet weak var btn_Cancel: UIButton!
    
    
    @IBOutlet weak var lbe_Pickup: UILabel!
    @IBOutlet weak var lbe_Delivery: UILabel!
    @IBOutlet weak var lbe_Distance: UILabel!
    @IBOutlet weak var lbe_Duration: UILabel!
    @IBOutlet weak var lbe_Price: UILabel!
    @IBOutlet weak var lbe_SType: UILabel!
    @IBOutlet weak var lbe_Status: UILabel!
    @IBOutlet weak var lbe_DateTime: UILabel!
    @IBOutlet weak var lbe_OrderNo: UILabel!

    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var btnFuelList: UIButton!
    @IBOutlet weak var imgFuel: UIImageView!
    
    @IBOutlet weak var switchOn: UISwitch!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


class SelectionViewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lbeSingleDay: UILabel!
    @IBOutlet weak var lbeMultiDays: UILabel!
    @IBOutlet weak var btnSingleDay: UIButton!
    @IBOutlet weak var btnMultiDays: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}

