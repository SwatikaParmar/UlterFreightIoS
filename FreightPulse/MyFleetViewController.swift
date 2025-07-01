//
//  MyFleetViewController.swift
//  FreightPulse
//
//  Created by AbsolveTech on 11/06/25.
//

import UIKit

class MyFleetViewController: UIViewController {
    @IBOutlet weak var tableViewMyFleet: UITableView!
    var arrayMyFleet : [FleetVehicle] = []

    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GetFleetData(false)
    }
    
    
    @IBAction func btnBackPreessed(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func Add(_ sender: Any){
        let storyBoard = UIStoryboard.init(name: "Fleet", bundle: nil)
        let controller = (storyBoard.instantiateViewController(withIdentifier: "UpdateFleetViewController") as?  UpdateFleetViewController)!
        controller.titleStr = "Add Fleet"
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func GetFleetData(_ isLoader:Bool){
        
        let dict : [String:Any] = [:]
        GetFleetListRequest.shared.GetFleetListRequestAPI(requestParams:dict, isLoader) { (message,status,dictionary) in
            if status {
                if dictionary != nil{
                    self.arrayMyFleet = dictionary ??  self.arrayMyFleet
                    self.tableViewMyFleet.reloadData()
                }
            }
        }
    }


}
extension MyFleetViewController: UITableViewDataSource,UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return arrayMyFleet.count

    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableViewMyFleet.dequeueReusableCell(withIdentifier: "MyFleetCell") as! MyFleetCell
        
        cell.lbeName.text = arrayMyFleet[indexPath.row].vehicleName
        var urlString = arrayMyFleet[indexPath.row].fleetImage?.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? ""
        urlString =  GlobalConstants.BASE_IMAGE_URL + urlString
        
        cell.imgView?.sd_setImage(with: URL.init(string:(urlString)),
                               placeholderImage: UIImage(named: "imgPlaceH"),
                               options: .refreshCached,
                               completed: nil)

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
     
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
    
    }
    
}
    

class MyFleetCell: UITableViewCell {
    
    @IBOutlet weak var lbeName: UILabel!
    @IBOutlet weak var lbeStatus: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var imgView: UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
