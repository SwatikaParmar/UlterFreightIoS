//
//  PurchaseFuelListViewController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 26/10/24.
//

import UIKit

class PurchaseFuelListViewController: UIViewController {
    
    @IBOutlet weak var tableViewList : UITableView!
    @IBOutlet weak var lbeAdd : UILabel!
    @IBOutlet weak var btnAdd : UIButton!

    var arrayFuelRecordData : [FuelRecordData] = []
    var fleetId = 0
    var loadId = 0
    var IsActive = 1

    override func viewDidLoad() {
        super.viewDidLoad()
       

        if IsActive == 1 {
            lbeAdd.isHidden = false
            btnAdd.isHidden = false
        }
        else{
            lbeAdd.isHidden = true
            btnAdd.isHidden = true
        }

        
       
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        GetActiveData(true)
    }
    
    @IBAction func btnBackPreessed(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func AddPreessed(_ sender: Any){
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        let controller = (storyBoard.instantiateViewController(withIdentifier: "AddFuelViewController") as?  AddFuelViewController)!
        controller.fleetId = fleetId
        controller.loadId = loadId
        self.navigationController?.pushViewController(controller, animated: true)
    
        
    }
    
    func GetActiveData(_ isLoader:Bool){
        
        let dict : [String:Any] = [
            "IsActive": IsActive,
            "FleetId": fleetId,
            "loadId" : loadId
        ]
        
        FuelRecordRequest.shared.FuelRecordRequestAPI(requestParams:dict, isLoader) { (message,status,dictionary) in
            if status {
                if dictionary != nil{
                    self.arrayFuelRecordData = dictionary ??  self.arrayFuelRecordData
                    self.tableViewList.reloadData()
                }
            }
        }
    }

}
extension PurchaseFuelListViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return self.arrayFuelRecordData.count

    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableViewList.dequeueReusableCell(withIdentifier: "PurchaseFuelCell") as! PurchaseFuelCell
        
        cell.lbeQuantity.text = String(format: "%.2f (%@)",self.arrayFuelRecordData[indexPath.row].fuelQuantity,self.arrayFuelRecordData[indexPath.row].fuelUnit)
        cell.lbeAmount.text = String(format: "$%.2f",self.arrayFuelRecordData[indexPath.row].fuelCost)
        cell.lbeDate.text = String(format: "%@",self.arrayFuelRecordData[indexPath.row].fuelDate)
        cell.lbeStationName.text = String(format: "%@",self.arrayFuelRecordData[indexPath.row].stationName)
        cell.lbeType.text = String(format: "%@",self.arrayFuelRecordData[indexPath.row].fuelType)

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        let storyBoard = UIStoryboard.init(name: "Home", bundle: nil)
        let controller = (storyBoard.instantiateViewController(withIdentifier: "FuelReceiptViewController") as?  FuelReceiptViewController)!
        controller.urlString = arrayFuelRecordData[indexPath.row].fuelReceipt.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""

        self.navigationController?.pushViewController(controller, animated: true)
    }
    
}
    

class PurchaseFuelCell: UITableViewCell {
    
    @IBOutlet weak var lbeStationName: UILabel!
    @IBOutlet weak var lbeDate: UILabel!
    @IBOutlet weak var lbeQuantity: UILabel!
    @IBOutlet weak var lbeAmount: UILabel!
    
    @IBOutlet weak var lbeType: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
